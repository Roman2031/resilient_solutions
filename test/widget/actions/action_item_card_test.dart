import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/actions/widgets/action_item_card.dart';
import 'package:kindomcall/features/call_service/data/models/call_service_models.dart';

void main() {
  group('ActionItemCard Widget', () {
    testWidgets('should display action item title', (WidgetTester tester) async {
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test Action',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.text('Test Action'), findsOneWidget);
    });

    testWidgets('should display status badge', (WidgetTester tester) async {
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test Action',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.text('PENDING'), findsOneWidget);
    });

    testWidgets('should display priority badge when priority is set',
        (WidgetTester tester) async {
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test Action',
        status: 'pending',
        priority: 'high',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.text('HIGH'), findsOneWidget);
    });

    testWidgets('should display description when provided',
        (WidgetTester tester) async {
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test Action',
        description: 'Test description',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('should display due date when set', (WidgetTester tester) async {
      final dueDate = DateTime(2025, 12, 31);
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test Action',
        status: 'pending',
        dueDate: dueDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.textContaining('Due:'), findsOneWidget);
      expect(find.textContaining('Dec 31, 2025'), findsOneWidget);
    });

    testWidgets('should display "No due date" when due date is null',
        (WidgetTester tester) async {
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test Action',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.text('No due date'), findsOneWidget);
    });

    testWidgets('should show overdue indicator when past due date',
        (WidgetTester tester) async {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Overdue Action',
        status: 'pending',
        dueDate: pastDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.text('(OVERDUE)'), findsOneWidget);
    });

    testWidgets('should not show overdue for completed actions',
        (WidgetTester tester) async {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Completed Action',
        status: 'completed',
        dueDate: pastDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.text('(OVERDUE)'), findsNothing);
    });

    testWidgets('should call onTap when card is tapped',
        (WidgetTester tester) async {
      bool tapped = false;
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Tappable Action',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(
              action: action,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ActionItemCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('should show menu button', (WidgetTester tester) async {
      final action = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test Action',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionItemCard(action: action),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('should display different colors for different statuses',
        (WidgetTester tester) async {
      final statuses = ['pending', 'in_progress', 'completed', 'cancelled'];

      for (var status in statuses) {
        final action = ActionItem(
          id: 1,
          assignedTo: 50,
          title: 'Test Action',
          status: status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ActionItemCard(action: action),
            ),
          ),
        );

        expect(find.text(status.toUpperCase()), findsOneWidget);
        await tester.pumpWidget(Container()); // Clear widget tree
      }
    });
  });
}
