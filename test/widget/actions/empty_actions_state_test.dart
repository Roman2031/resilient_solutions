import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/actions/widgets/empty_actions_state.dart';

void main() {
  group('EmptyActionsState Widget', () {
    testWidgets('should display message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyActionsState(
              message: 'No actions found',
            ),
          ),
        ),
      );

      expect(find.text('No actions found'), findsOneWidget);
    });

    testWidgets('should display subtitle when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyActionsState(
              message: 'No actions found',
              subtitle: 'Try creating a new action',
            ),
          ),
        ),
      );

      expect(find.text('Try creating a new action'), findsOneWidget);
    });

    testWidgets('should display icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyActionsState(
              message: 'No actions found',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.task_alt), findsOneWidget);
    });

    testWidgets('should display action button when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyActionsState(
              message: 'No actions found',
              onAction: () {},
              actionLabel: 'Create Action',
            ),
          ),
        ),
      );

      expect(find.text('Create Action'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onAction when button is pressed',
        (WidgetTester tester) async {
      bool actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyActionsState(
              message: 'No actions found',
              onAction: () {
                actionCalled = true;
              },
              actionLabel: 'Create Action',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(actionCalled, true);
    });

    testWidgets('should not display button when onAction is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyActionsState(
              message: 'No actions found',
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('should center content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyActionsState(
              message: 'No actions found',
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
    });
  });
}
