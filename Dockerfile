# Flutter Web Docker Build
# Stage 1: Build the Flutter web app
FROM cirrusci/flutter:3.8.1 AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Run code generation
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Build web app
RUN flutter build web --release \
    --dart-define=KEYCLOAK_BASE_URL=https://auth.kingdom.com \
    --dart-define=KEYCLOAK_REALM=KingdomStage \
    --dart-define=KEYCLOAK_CLIENT_ID=MobileApp \
    --dart-define=WORDPRESS_API_URL=https://learning.kingdominc.com/wp-json \
    --dart-define=CALL_SERVICE_API_URL=https://callcircle.resilentsolutions.com/api \
    --dart-define=ADMIN_PORTAL_API_URL=https://callcircle.resilentsolutions.com/api/v1/admin

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built web app
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
