import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/call_service/data/models/call_service_models.dart';

void main() {
  group('Note Model', () {
    test('should create Note with all fields', () {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'This is a test note',
        isPrivate: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 2),
      );

      expect(note.id, 1);
      expect(note.callId, 100);
      expect(note.userId, 50);
      expect(note.content, 'This is a test note');
      expect(note.isPrivate, true);
    });

    test('should default isPrivate to false', () {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Public note',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.isPrivate, false);
    });

    test('should create Note from JSON', () {
      final json = {
        'id': 1,
        'call_id': 100,
        'user_id': 50,
        'content': 'Test note from JSON',
        'is_private': true,
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-02T00:00:00.000Z',
      };

      final note = Note.fromJson(json);

      expect(note.id, 1);
      expect(note.callId, 100);
      expect(note.userId, 50);
      expect(note.content, 'Test note from JSON');
      expect(note.isPrivate, true);
    });

    test('should create Note from JSON with default isPrivate', () {
      final json = {
        'id': 1,
        'call_id': 100,
        'user_id': 50,
        'content': 'Test note',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
      };

      final note = Note.fromJson(json);

      expect(note.isPrivate, false);
    });

    test('should convert Note to JSON', () {
      final now = DateTime(2025, 1, 1);
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note for JSON',
        isPrivate: true,
        createdAt: now,
        updatedAt: now,
      );

      final json = note.toJson();

      expect(json['id'], 1);
      expect(json['call_id'], 100);
      expect(json['user_id'], 50);
      expect(json['content'], 'Test note for JSON');
      expect(json['is_private'], true);
    });

    test('should support equality comparison', () {
      final now = DateTime(2025, 1, 1);
      final note1 = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        isPrivate: false,
        createdAt: now,
        updatedAt: now,
      );
      final note2 = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        isPrivate: false,
        createdAt: now,
        updatedAt: now,
      );

      expect(note1, equals(note2));
    });

    test('should support copyWith', () {
      final now = DateTime(2025, 1, 1);
      final original = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Original content',
        isPrivate: false,
        createdAt: now,
        updatedAt: now,
      );

      final updated = original.copyWith(
        content: 'Updated content',
        isPrivate: true,
      );

      expect(updated.content, 'Updated content');
      expect(updated.isPrivate, true);
      expect(updated.id, 1); // unchanged
      expect(updated.callId, 100); // unchanged
    });

    test('should handle long content', () {
      final longContent = 'A' * 1000;
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: longContent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.content.length, 1000);
    });

    test('should handle special characters in content', () {
      final specialContent = 'Special chars: @#\$%^&*()_+-=[]{}|;:\\\'",.<>?/\\`~';
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: specialContent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.content, specialContent);
    });

    test('should handle multiline content', () {
      final multilineContent = '''Line 1
Line 2
Line 3''';
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: multilineContent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.content, multilineContent);
      expect(note.content.split('\n').length, 3);
    });
  });

  group('Note Privacy', () {
    test('private note should have isPrivate true', () {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Private note',
        isPrivate: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.isPrivate, true);
    });

    test('public note should have isPrivate false', () {
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Public note',
        isPrivate: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.isPrivate, false);
    });
  });

  group('Note Timestamps', () {
    test('should track created and updated timestamps', () {
      final created = DateTime(2025, 1, 1);
      final updated = DateTime(2025, 1, 2);
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Test note',
        createdAt: created,
        updatedAt: updated,
      );

      expect(note.createdAt, created);
      expect(note.updatedAt, updated);
      expect(note.updatedAt.isAfter(note.createdAt), true);
    });

    test('should allow created and updated to be the same', () {
      final timestamp = DateTime(2025, 1, 1);
      final note = Note(
        id: 1,
        callId: 100,
        userId: 50,
        content: 'Just created',
        createdAt: timestamp,
        updatedAt: timestamp,
      );

      expect(note.createdAt, timestamp);
      expect(note.updatedAt, timestamp);
    });
  });
}
