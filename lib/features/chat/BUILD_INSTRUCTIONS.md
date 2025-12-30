# Chat Feature Build Instructions

## Code Generation Required

This feature uses Freezed for immutable models and Riverpod Generator for providers.
Before building or running the app, you need to generate the required files.

### Run Code Generation

```bash
cd "Flutter App"

# Generate all code (models + providers)
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Files That Will Be Generated

The following files will be created by build_runner:

**Models:**
- `lib/features/chat/models/message_thread.freezed.dart`
- `lib/features/chat/models/message_thread.g.dart`

**Providers:**
- `lib/features/chat/providers/messages_provider.g.dart`
- `lib/features/chat/providers/activity_provider.g.dart`

### Troubleshooting

If you get compilation errors about missing generated files:

1. Make sure you're in the `Flutter App` directory
2. Run `flutter pub get` to install dependencies
3. Run the build_runner command above
4. Restart your IDE/editor

### Testing

After code generation, you can run tests:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/chat/messages_provider_test.dart
```
