#!/bin/bash

# Build script for Web Release
# Builds optimized web app for production deployment

set -e  # Exit on error

# Check if script is executable
if [[ ! -x "$0" ]]; then
    echo "Warning: Script is not executable. Run: chmod +x $0"
fi

echo "================================================"
echo "Building Web Release"
echo "================================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed or not in PATH"
    exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
flutter clean

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Run code generation
echo "Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

# Build web
echo "Building web release..."
flutter build web --release \
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
echo "Web build: build/web"
echo ""
echo "To test locally:"
echo "  cd build/web && python3 -m http.server 8000"
echo "  Then open: http://localhost:8000"
echo ""
echo "To deploy:"
echo "  - Firebase Hosting: firebase deploy --only hosting"
echo "  - Docker: docker build -t kingdom-call-web ."
echo "  - Static hosting: Copy build/web/* to your web server"
echo "================================================"
