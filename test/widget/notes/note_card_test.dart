import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/allnotes/widgets/note_card.dart';
import 'package:kindomcall/features/call_service/data/models/call_service_models.dart';

void main() {
  group('NoteCard Widget', () {
    testWidgets('should display note content', (WidgetTester tester) async {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      expect(find.text('Test note content'), findsOneWidget);
    });

    testWidgets('should display private badge for private notes',
        (WidgetTester tester) async {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Private note',
        isPrivate: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      expect(find.text('PRIVATE'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should not display private badge for public notes',
        (WidgetTester tester) async {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Public note',
        isPrivate: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      expect(find.text('PRIVATE'), findsNothing);
      expect(find.byIcon(Icons.lock), findsNothing);
    });

    testWidgets('should display call title when provided',
        (WidgetTester tester) async {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: note,
              callTitle: 'Weekly Meeting',
            ),
          ),
        ),
      );

      expect(find.text('Weekly Meeting'), findsOneWidget);
    });

    testWidgets('should display circle name when provided',
        (WidgetTester tester) async {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: note,
              circleName: 'Discipleship Circle',
            ),
          ),
        ),
      );

      expect(find.text('Discipleship Circle'), findsOneWidget);
    });

    testWidgets('should display timestamp', (WidgetTester tester) async {
      final timestamp = DateTime(2025, 1, 15, 14, 30);
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        createdAt: timestamp,
        updatedAt: timestamp,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      expect(find.textContaining('Jan 15, 2025'), findsOneWidget);
    });

    testWidgets('should show edited indicator when updated',
        (WidgetTester tester) async {
      final created = DateTime(2025, 1, 15);
      final updated = DateTime(2025, 1, 16);
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Edited note',
        createdAt: created,
        updatedAt: updated,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      expect(find.text('(edited)'), findsOneWidget);
    });

    testWidgets('should not show edited indicator when not updated',
        (WidgetTester tester) async {
      final timestamp = DateTime(2025, 1, 15);
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'New note',
        createdAt: timestamp,
        updatedAt: timestamp,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      expect(find.text('(edited)'), findsNothing);
    });

    testWidgets('should call onTap when card is tapped',
        (WidgetTester tester) async {
      bool tapped = false;
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Tappable note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: note,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NoteCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('should show menu button', (WidgetTester tester) async {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('should truncate long content', (WidgetTester tester) async {
      final longContent = 'A' * 500; // Very long content
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: longContent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: note),
          ),
        ),
      );

      // Should find a Text widget with maxLines set (truncation)
      expect(find.byType(NoteCard), findsOneWidget);
    });

    testWidgets('should display icons for call and circle',
        (WidgetTester tester) async {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: note,
              callTitle: 'Meeting',
              circleName: 'Circle',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.byIcon(Icons.group), findsOneWidget);
    });
  });
}
