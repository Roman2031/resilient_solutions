import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/chat/widgets/message_bubble.dart';
import 'package:kindomcall/features/wordpress/data/models/buddyboss_models.dart';

void main() {
  group('MessageBubble Widget', () {
    testWidgets('should display message content', (WidgetTester tester) async {
      final message = BBMessage(
        id: 1,
        senderId: 100,
        threadId: 50,
        subject: 'Test',
        message: 'Hello, this is a test message!',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: false,
            ),
          ),
        ),
      );

      expect(find.text('Hello, this is a test message!'), findsOneWidget);
    });

    testWidgets('should display sender name when not isMe',
        (WidgetTester tester) async {
      final message = BBMessage(
        id: 1,
        senderId: 100,
        senderName: 'John Doe',
        threadId: 50,
        subject: 'Test',
        message: 'Test message',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: false,
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should not display sender name when isMe',
        (WidgetTester tester) async {
      final message = BBMessage(
        id: 1,
        senderId: 100,
        senderName: 'My Name',
        threadId: 50,
        subject: 'Test',
        message: 'Test message',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: true,
            ),
          ),
        ),
      );

      expect(find.text('My Name'), findsNothing);
    });

    testWidgets('should use primary color for sent messages (isMe=true)',
        (WidgetTester tester) async {
      final message = BBMessage(
        id: 1,
        senderId: 100,
        threadId: 50,
        subject: 'Test',
        message: 'Test message',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: true,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MessageBubble),
          matching: find.byType(Container),
        ).at(1), // Second container is the message bubble
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);
    });

    testWidgets('should call onLongPress when bubble is long pressed',
        (WidgetTester tester) async {
      bool longPressed = false;
      final message = BBMessage(
        id: 1,
        senderId: 100,
        threadId: 50,
        subject: 'Test',
        message: 'Test message',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: false,
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(GestureDetector));
      await tester.pump();

      expect(longPressed, true);
    });

    testWidgets('should display "Just now" for very recent messages',
        (WidgetTester tester) async {
      final message = BBMessage(
        id: 1,
        senderId: 100,
        threadId: 50,
        subject: 'Test',
        message: 'Test message',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: false,
            ),
          ),
        ),
      );

      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('should align to right when isMe is true',
        (WidgetTester tester) async {
      final message = BBMessage(
        id: 1,
        senderId: 100,
        threadId: 50,
        subject: 'Test',
        message: 'Test message',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: true,
            ),
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.end);
    });

    testWidgets('should align to left when isMe is false',
        (WidgetTester tester) async {
      final message = BBMessage(
        id: 1,
        senderId: 100,
        threadId: 50,
        subject: 'Test',
        message: 'Test message',
        dateSent: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: message,
              isMe: false,
            ),
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.start);
    });
  });
}
