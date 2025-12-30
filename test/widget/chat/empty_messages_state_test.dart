import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/chat/widgets/empty_messages_state.dart';

void main() {
  group('EmptyMessagesState Widget', () {
    testWidgets('should display "No conversations yet" message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyMessagesState(
              onStartChat: () {},
            ),
          ),
        ),
      );

      expect(find.text('No conversations yet'), findsOneWidget);
    });

    testWidgets('should display instructional text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyMessagesState(
              onStartChat: () {},
            ),
          ),
        ),
      );

      expect(
        find.text('Start a conversation with your circle members'),
        findsOneWidget,
      );
    });

    testWidgets('should display chat icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyMessagesState(
              onStartChat: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    });

    testWidgets('should display "Start a Chat" button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyMessagesState(
              onStartChat: () {},
            ),
          ),
        ),
      );

      expect(find.text('Start a Chat'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onStartChat when button is tapped',
        (WidgetTester tester) async {
      bool buttonTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyMessagesState(
              onStartChat: () => buttonTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(buttonTapped, true);
    });

    testWidgets('should display add icon in button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyMessagesState(
              onStartChat: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should center all content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyMessagesState(
              onStartChat: () {},
            ),
          ),
        ),
      );

      final center = tester.widget<Center>(find.byType(Center));
      expect(center, isNotNull);
    });
  });
}
