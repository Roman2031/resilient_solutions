#!/bin/bash

# Build script for iOS Release
# Builds optimized iOS app for production deployment

set -e  # Exit on error

# Check if script is executable
if [[ ! -x "$0" ]]; then
    echo "Warning: Script is not executable. Run: chmod +x $0"
fi

echo "================================================"
echo "Building iOS Release"
echo "================================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed or not in PATH"
    exit 1
fi

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: iOS builds require macOS"
    exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
flutter clean

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Update CocoaPods
echo "Updating CocoaPods..."
cd ios
pod install --repo-update
cd ..

# Run code generation
echo "Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

# Build iOS with obfuscation
echo "Building iOS release..."
flutter build ios --release \
    --obfuscate \
    --split-debug-info=build/ios/symbols \
    --dart-define=KEYCLOAK_BASE_URL="${KEYCLOAK_BASE_URL:-https://auth.kingdom.com}" \
    --dart-define=KEYCLOAK_REALM="${KEYCLOAK_REALM:-KingdomStage}" \
    --dart-define=KEYCLOAK_CLIENT_ID="${KEYCLOAK_CLIENT_ID:-MobileApp}" \
    --dart-define=WORDPRESS_API_URL="${WORDPRESS_API_URL:-https://learning.kingdominc.com/wp-json}" \
    --dart-define=CALL_SERVICE_API_URL="${CALL_SERVICE_API_URL:-https://callcircle.resilentsolutions.com/api}" \
    --dart-define=ADMIN_PORTAL_API_URL="${ADMIN_PORTAL_API_URL:-https://callcircle.resilentsolutions.com/api/v1/admin}"

echo ""
echo "================================================"
echo "Build complete!"
echo "================================================"
echo "iOS build completed successfully."
echo "To archive and submit to App Store:"
echo "  1. Open ios/Runner.xcworkspace in Xcode"
echo "  2. Select 'Any iOS Device' as the build target"
echo "  3. Product → Archive"
echo "  4. Distribute App → App Store Connect"
echo ""
echo "Symbols: build/ios/symbols"
echo "================================================"
