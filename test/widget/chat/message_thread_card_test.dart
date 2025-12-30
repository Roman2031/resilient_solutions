import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/chat/models/message_thread.dart';
import 'package:kindomcall/features/chat/widgets/message_thread_card.dart';

void main() {
  group('MessageThreadCard Widget', () {
    testWidgets('should display thread display name', (WidgetTester tester) async {
      final thread = MessageThread(
        id: 1,
        subject: 'Test Conversation',
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
        ],
        lastMessage: 'Hello there!',
        lastMessageAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Conversation'), findsOneWidget);
    });

    testWidgets('should display last message', (WidgetTester tester) async {
      final thread = MessageThread(
        id: 1,
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
        ],
        lastMessage: 'This is the last message',
        lastMessageAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('This is the last message'), findsOneWidget);
    });

    testWidgets('should display unread count badge when hasUnread',
        (WidgetTester tester) async {
      final thread = MessageThread(
        id: 1,
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
        ],
        lastMessage: 'Test message',
        lastMessageAt: DateTime.now(),
        unreadCount: 5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should not display unread count badge when no unread messages',
        (WidgetTester tester) async {
      final thread = MessageThread(
        id: 1,
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
        ],
        lastMessage: 'Test message',
        lastMessageAt: DateTime.now(),
        unreadCount: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () {},
            ),
          ),
        ),
      );

      // Check that there's no unread badge container
      expect(find.text('0'), findsNothing);
    });

    testWidgets('should show group icon for group chats',
        (WidgetTester tester) async {
      final thread = MessageThread(
        id: 1,
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
          ThreadParticipant(id: 2, name: 'Jane Smith'),
          ThreadParticipant(id: 3, name: 'Bob Johnson'),
        ],
        lastMessage: 'Group message',
        lastMessageAt: DateTime.now(),
        isGroupChat: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.group), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped',
        (WidgetTester tester) async {
      bool tapped = false;
      final thread = MessageThread(
        id: 1,
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
        ],
        lastMessage: 'Test message',
        lastMessageAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('should display time as "Just now" for very recent messages',
        (WidgetTester tester) async {
      final thread = MessageThread(
        id: 1,
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
        ],
        lastMessage: 'Recent message',
        lastMessageAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('should display time in minutes for recent messages',
        (WidgetTester tester) async {
      final thread = MessageThread(
        id: 1,
        participants: [
          ThreadParticipant(id: 1, name: 'John Doe'),
        ],
        lastMessage: 'Recent message',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageThreadCard(
              thread: thread,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('30m ago'), findsOneWidget);
    });
  });
}
