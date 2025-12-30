# Test Suite

This directory contains the test suite for the Kingdom Call Flutter application.

## Test Structure

```
test/
├── unit/               # Unit tests for business logic
│   ├── auth/          # Authentication-related tests
│   └── repositories/  # Repository tests
├── widget/            # Widget tests for UI components
└── integration/       # Integration tests for end-to-end flows
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/unit/auth/token_parser_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### View coverage report
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Guidelines

### Unit Tests
- Test business logic in isolation
- Mock external dependencies
- Fast execution
- No UI rendering

### Widget Tests
- Test widget rendering and user interactions
- Use `WidgetTester` for pumping widgets
- Verify UI elements are displayed correctly
- Test user interactions (taps, scrolls, etc.)

### Integration Tests
- Test complete user flows
- Use real dependencies where possible
- Test authentication, navigation, and data flows
- Run on actual devices/emulators

## Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: Cover all critical UI components
- **Integration Tests**: Cover main user flows

## Adding New Tests

1. Create test file with `_test.dart` suffix
2. Import `package:flutter_test/flutter_test.dart`
3. Use `group()` to organize related tests
4. Use `test()` or `testWidgets()` for individual tests
5. Follow AAA pattern: Arrange, Act, Assert

## Test Naming Convention

- Unit tests: `[class_name]_test.dart`
- Widget tests: `[screen_name]_test.dart`
- Integration tests: `[flow_name]_integration_test.dart`

## Mocking

For unit tests, use `mockito` or create manual mocks:

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ApiService])
void main() {
  // Use mocks in tests
}
```

## CI/CD Integration

Tests are automatically run in the CI/CD pipeline:
- Code quality checks run first
- Unit and widget tests run before builds
- Coverage reports are uploaded to Codecov

## Troubleshooting

### Tests fail with "MissingPluginException"
- Widget tests that depend on platform channels need special setup
- Use `TestWidgetsFlutterBinding.ensureInitialized()`

### Async tests timing out
- Use `await tester.pumpAndSettle()` for widget tests
- Increase timeout: `test('name', () {}, timeout: Timeout(Duration(seconds: 30)))`

### Generated code not found
- Run `flutter pub run build_runner build` before running tests
