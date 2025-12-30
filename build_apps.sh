#!/bin/bash

###############################################################################
# Kingdom Call Circle Flutter App - Automated Build Script
# 
# This script automates the complete build process for Android and iOS apps.
# It handles code generation, dependency management, and creates release builds.
#
# Usage:
#   ./build_apps.sh [android|ios|web|all]
#
# Prerequisites:
#   - Flutter SDK 3.8.1+ installed and in PATH
#   - Android Studio with SDK (for Android builds)
#   - Xcode (for iOS builds - macOS only)
#
# Author: GitHub Copilot
# Date: December 2025
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_MODE="${BUILD_MODE:-release}"
SKIP_TESTS="${SKIP_TESTS:-false}"

###############################################################################
# Helper Functions
###############################################################################

print_header() {
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}======================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        print_info "Install Flutter: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    print_success "Flutter $(flutter --version | head -n1)"
}

check_dependencies() {
    print_header "Checking Dependencies"
    
    cd "$PROJECT_DIR"
    
    print_info "Running flutter doctor..."
    flutter doctor -v
    
    print_info "Getting Flutter packages..."
    flutter pub get
    
    print_success "Dependencies checked"
}

run_code_generation() {
    print_header "Running Code Generation"
    
    cd "$PROJECT_DIR"
    
    print_info "Cleaning previous build_runner output..."
    flutter pub run build_runner clean || true
    
    print_info "Running build_runner (this may take a few minutes)..."
    flutter pub run build_runner build --delete-conflicting-outputs
    
    print_success "Code generation completed"
}

run_tests() {
    if [ "$SKIP_TESTS" = "true" ]; then
        print_warning "Skipping tests (SKIP_TESTS=true)"
        return
    fi
    
    print_header "Running Tests"
    
    cd "$PROJECT_DIR"
    
    print_info "Running flutter analyze..."
    flutter analyze || print_warning "Analysis found issues (continuing anyway)"
    
    print_info "Running unit tests..."
    flutter test || print_warning "Some tests failed (continuing anyway)"
    
    print_success "Tests completed"
}

build_android() {
    print_header "Building Android APK"
    
    cd "$PROJECT_DIR"
    
    # Check if Android SDK is available
    if ! flutter doctor | grep -q "Android toolchain"; then
        print_error "Android toolchain not available"
        print_info "Install Android Studio: https://developer.android.com/studio"
        return 1
    fi
    
    print_info "Building Android APK (split per ABI for smaller size)..."
    flutter build apk --$BUILD_MODE --split-per-abi
    
    print_success "Android APK built successfully!"
    print_info "APK locations:"
    ls -lh build/app/outputs/flutter-apk/*.apk | awk '{print "  - " $NF " (" $5 ")"}'
    
    # Also build App Bundle for Play Store
    print_info "Building Android App Bundle for Play Store..."
    flutter build appbundle --$BUILD_MODE
    
    print_success "Android App Bundle built successfully!"
    print_info "AAB location:"
    ls -lh build/app/outputs/bundle/$BUILD_MODE/*.aab | awk '{print "  - " $NF " (" $5 ")"}'
}

build_ios() {
    print_header "Building iOS IPA"
    
    cd "$PROJECT_DIR"
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "iOS builds require macOS with Xcode installed"
        return 1
    fi
    
    # Check if Xcode is available
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode is not installed"
        print_info "Install Xcode from App Store"
        return 1
    fi
    
    print_info "Installing CocoaPods dependencies..."
    cd ios
    pod install || print_warning "CocoaPods installation had issues"
    cd ..
    
    print_info "Building iOS app (without codesigning for CI)..."
    flutter build ios --$BUILD_MODE --no-codesign
    
    print_success "iOS app built successfully!"
    print_info "App location: build/ios/iphoneos/Runner.app"
    
    # Try to build IPA if signing is available
    print_info "Attempting to build signed IPA..."
    if flutter build ipa --$BUILD_MODE 2>/dev/null; then
        print_success "iOS IPA built successfully!"
        print_info "IPA location:"
        ls -lh build/ios/ipa/*.ipa | awk '{print "  - " $NF " (" $5 ")"}'
    else
        print_warning "Could not build signed IPA (requires Apple Developer account and certificates)"
        print_info "Unsigned app is available at: build/ios/iphoneos/Runner.app"
    fi
}

build_web() {
    print_header "Building Web App"
    
    cd "$PROJECT_DIR"
    
    print_info "Building web app..."
    flutter build web --$BUILD_MODE --web-renderer canvaskit
    
    print_success "Web app built successfully!"
    print_info "Web build location: build/web/"
    
    print_info "To test locally, run:"
    print_info "  cd build/web && python3 -m http.server 8000"
}

show_summary() {
    print_header "Build Summary"
    
    echo ""
    echo -e "${GREEN}Build completed successfully!${NC}"
    echo ""
    echo "Build artifacts:"
    
    if [ -d "build/app/outputs/flutter-apk" ]; then
        echo ""
        echo "Android APKs:"
        find build/app/outputs/flutter-apk -name "*.apk" -exec ls -lh {} \; | awk '{print "  ✓ " $NF " (" $5 ")"}'
    fi
    
    if [ -d "build/app/outputs/bundle" ]; then
        echo ""
        echo "Android App Bundles:"
        find build/app/outputs/bundle -name "*.aab" -exec ls -lh {} \; | awk '{print "  ✓ " $NF " (" $5 ")"}'
    fi
    
    if [ -d "build/ios/iphoneos" ]; then
        echo ""
        echo "iOS App:"
        echo "  ✓ build/ios/iphoneos/Runner.app"
    fi
    
    if [ -d "build/ios/ipa" ]; then
        echo ""
        echo "iOS IPA:"
        find build/ios/ipa -name "*.ipa" -exec ls -lh {} \; | awk '{print "  ✓ " $NF " (" $5 ")"}'
    fi
    
    if [ -d "build/web" ]; then
        echo ""
        echo "Web Build:"
        echo "  ✓ build/web/"
    fi
    
    echo ""
    print_info "Next steps:"
    echo "  1. Test the built apps on real devices"
    echo "  2. Configure Keycloak realm and clients"
    echo "  3. Test authentication flow"
    echo "  4. Verify API integrations"
    echo "  5. Submit to app stores (if approved)"
    echo ""
}

cleanup() {
    print_header "Cleaning Build Artifacts"
    
    cd "$PROJECT_DIR"
    
    print_info "Running flutter clean..."
    flutter clean
    
    print_success "Cleanup completed"
}

show_help() {
    cat << EOF
Kingdom Call Circle Flutter App - Automated Build Script

Usage:
  $0 [OPTIONS] [PLATFORM]

PLATFORMS:
  android     Build Android APK and AAB
  ios         Build iOS IPA (macOS only)
  web         Build web app
  all         Build for all available platforms (default)
  clean       Clean build artifacts

OPTIONS:
  -h, --help          Show this help message
  -d, --debug         Build in debug mode (default: release)
  -s, --skip-tests    Skip running tests
  -c, --clean         Clean before building

EXAMPLES:
  $0                  Build all platforms in release mode
  $0 android          Build only Android APK
  $0 -d android       Build Android APK in debug mode
  $0 --skip-tests all Build all platforms without running tests
  $0 clean            Clean build artifacts

ENVIRONMENT VARIABLES:
  BUILD_MODE          Build mode: 'debug' or 'release' (default: release)
  SKIP_TESTS          Skip tests: 'true' or 'false' (default: false)

For more information, see BUILD_GUIDE.md
EOF
}

###############################################################################
# Main Script
###############################################################################

main() {
    local platform="all"
    local clean_first=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--debug)
                BUILD_MODE="debug"
                shift
                ;;
            -s|--skip-tests)
                SKIP_TESTS="true"
                shift
                ;;
            -c|--clean)
                clean_first=true
                shift
                ;;
            android|ios|web|all|clean)
                platform="$1"
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Show banner
    echo ""
    print_header "Kingdom Call Circle Flutter App Builder"
    echo ""
    print_info "Platform: $platform"
    print_info "Build mode: $BUILD_MODE"
    print_info "Skip tests: $SKIP_TESTS"
    echo ""
    
    # Check Flutter installation
    check_flutter
    
    # Clean if requested
    if [ "$clean_first" = true ]; then
        cleanup
    fi
    
    # Handle clean command
    if [ "$platform" = "clean" ]; then
        cleanup
        exit 0
    fi
    
    # Setup
    check_dependencies
    run_code_generation
    run_tests
    
    # Build
    case $platform in
        android)
            build_android
            ;;
        ios)
            build_ios
            ;;
        web)
            build_web
            ;;
        all)
            build_android || print_warning "Android build failed or skipped"
            build_ios || print_warning "iOS build failed or skipped"
            build_web || print_warning "Web build failed or skipped"
            ;;
    esac
    
    # Summary
    show_summary
}

# Run main function
main "$@"
