import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/allnotes/widgets/empty_notes_state.dart';

void main() {
  group('EmptyNotesState Widget', () {
    testWidgets('should display message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyNotesState(
              message: 'No notes found',
            ),
          ),
        ),
      );

      expect(find.text('No notes found'), findsOneWidget);
    });

    testWidgets('should display subtitle when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyNotesState(
              message: 'No notes found',
              subtitle: 'Notes will appear here',
            ),
          ),
        ),
      );

      expect(find.text('Notes will appear here'), findsOneWidget);
    });

    testWidgets('should display icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyNotesState(
              message: 'No notes found',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.note_alt_outlined), findsOneWidget);
    });

    testWidgets('should display action button when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyNotesState(
              message: 'No notes found',
              onAction: () {},
              actionLabel: 'Create Note',
            ),
          ),
        ),
      );

      expect(find.text('Create Note'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onAction when button is pressed',
        (WidgetTester tester) async {
      bool actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyNotesState(
              message: 'No notes found',
              onAction: () {
                actionCalled = true;
              },
              actionLabel: 'Create Note',
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
            body: EmptyNotesState(
              message: 'No notes found',
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
    });
  });
}
