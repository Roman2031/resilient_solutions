import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/chat/models/message_thread.dart';

void main() {
  group('MessageThread Model', () {
    test('should create MessageThread with all fields', () {
      final participants = [
        ThreadParticipant(
          id: 1,
          name: 'John Doe',
          avatarUrl: 'https://example.com/avatar.jpg',
          isOnline: true,
        ),
        ThreadParticipant(
          id: 2,
          name: 'Jane Smith',
          avatarUrl: 'https://example.com/avatar2.jpg',
          isOnline: false,
        ),
      ];

      final thread = MessageThread(
        id: 100,
        subject: 'Test Thread',
        participants: participants,
        lastMessage: 'Hello, world!',
        lastMessageAt: DateTime(2025, 1, 1),
        unreadCount: 5,
        isGroupChat: true,
      );

      expect(thread.id, 100);
      expect(thread.subject, 'Test Thread');
      expect(thread.participants.length, 2);
      expect(thread.lastMessage, 'Hello, world!');
      expect(thread.unreadCount, 5);
      expect(thread.isGroupChat, true);
    });

    test('should default unreadCount to 0', () {
      final thread = MessageThread(
        id: 100,
        participants: [],
        lastMessage: 'Test',
        lastMessageAt: DateTime.now(),
      );

      expect(thread.unreadCount, 0);
      expect(thread.hasUnread, false);
    });

    test('should default isGroupChat to false', () {
      final thread = MessageThread(
        id: 100,
        participants: [],
        lastMessage: 'Test',
        lastMessageAt: DateTime.now(),
      );

      expect(thread.isGroupChat, false);
    });

    test('hasUnread should return true when unreadCount > 0', () {
      final thread = MessageThread(
        id: 100,
        participants: [],
        lastMessage: 'Test',
        lastMessageAt: DateTime.now(),
        unreadCount: 3,
      );

      expect(thread.hasUnread, true);
    });

    test('displayName should return subject when available', () {
      final thread = MessageThread(
        id: 100,
        subject: 'My Conversation',
        participants: [
          ThreadParticipant(id: 1, name: 'John'),
        ],
        lastMessage: 'Test',
        lastMessageAt: DateTime.now(),
      );

      expect(thread.displayName, 'My Conversation');
    });

    test('displayName should return participants names when no subject', () {
      final thread = MessageThread(
        id: 100,
        participants: [
          ThreadParticipant(id: 1, name: 'John'),
          ThreadParticipant(id: 2, name: 'Jane'),
        ],
        lastMessage: 'Test',
        lastMessageAt: DateTime.now(),
      );

      expect(thread.displayName, 'John, Jane');
    });

    test('displayName should handle empty participants list', () {
      final thread = MessageThread(
        id: 100,
        participants: [],
        lastMessage: 'Test',
        lastMessageAt: DateTime.now(),
      );

      expect(thread.displayName, '');
    });
  });

  group('ThreadParticipant Model', () {
    test('should create ThreadParticipant with all fields', () {
      final participant = ThreadParticipant(
        id: 1,
        name: 'John Doe',
        avatarUrl: 'https://example.com/avatar.jpg',
        isOnline: true,
        lastSeen: DateTime(2025, 1, 1),
      );

      expect(participant.id, 1);
      expect(participant.name, 'John Doe');
      expect(participant.avatarUrl, 'https://example.com/avatar.jpg');
      expect(participant.isOnline, true);
      expect(participant.lastSeen, DateTime(2025, 1, 1));
    });

    test('should default isOnline to false', () {
      final participant = ThreadParticipant(
        id: 1,
        name: 'John Doe',
      );

      expect(participant.isOnline, false);
    });

    test('should allow null avatarUrl and lastSeen', () {
      final participant = ThreadParticipant(
        id: 1,
        name: 'John Doe',
      );

      expect(participant.avatarUrl, null);
      expect(participant.lastSeen, null);
    });
  });
}
