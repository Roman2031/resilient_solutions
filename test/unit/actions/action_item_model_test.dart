import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/call_service/data/models/call_service_models.dart';

void main() {
  group('ActionItem Model', () {
    test('should create ActionItem with all fields', () {
      final actionItem = ActionItem(
        id: 1,
        circleId: 100,
        callId: 200,
        assignedTo: 50,
        title: 'Complete documentation',
        description: 'Write comprehensive documentation for the API',
        dueDate: DateTime(2025, 12, 31),
        status: 'pending',
        priority: 'high',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(actionItem.id, 1);
      expect(actionItem.title, 'Complete documentation');
      expect(actionItem.status, 'pending');
      expect(actionItem.priority, 'high');
    });

    test('should create ActionItem with minimal fields', () {
      final now = DateTime.now();
      final actionItem = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Simple task',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      expect(actionItem.id, 1);
      expect(actionItem.circleId, null);
      expect(actionItem.callId, null);
      expect(actionItem.description, null);
      expect(actionItem.dueDate, null);
      expect(actionItem.priority, null);
    });

    test('should create ActionItem from JSON', () {
      final json = {
        'id': 1,
        'circle_id': 100,
        'call_id': 200,
        'assigned_to': 50,
        'title': 'Test task',
        'description': 'Test description',
        'due_date': '2025-12-31T23:59:59.000Z',
        'status': 'in_progress',
        'priority': 'medium',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
      };

      final actionItem = ActionItem.fromJson(json);

      expect(actionItem.id, 1);
      expect(actionItem.circleId, 100);
      expect(actionItem.callId, 200);
      expect(actionItem.assignedTo, 50);
      expect(actionItem.title, 'Test task');
      expect(actionItem.status, 'in_progress');
      expect(actionItem.priority, 'medium');
    });

    test('should convert ActionItem to JSON', () {
      final now = DateTime(2025, 1, 1);
      final actionItem = ActionItem(
        id: 1,
        circleId: 100,
        callId: 200,
        assignedTo: 50,
        title: 'Test task',
        description: 'Test description',
        dueDate: DateTime(2025, 12, 31),
        status: 'pending',
        priority: 'high',
        createdAt: now,
        updatedAt: now,
      );

      final json = actionItem.toJson();

      expect(json['id'], 1);
      expect(json['circle_id'], 100);
      expect(json['call_id'], 200);
      expect(json['assigned_to'], 50);
      expect(json['title'], 'Test task');
      expect(json['status'], 'pending');
      expect(json['priority'], 'high');
    });

    test('should support equality comparison', () {
      final now = DateTime(2025, 1, 1);
      final actionItem1 = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test task',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );
      final actionItem2 = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test task',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      expect(actionItem1, equals(actionItem2));
    });

    test('should support copyWith', () {
      final now = DateTime(2025, 1, 1);
      final original = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Original title',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      final updated = original.copyWith(
        title: 'Updated title',
        status: 'completed',
      );

      expect(updated.title, 'Updated title');
      expect(updated.status, 'completed');
      expect(updated.id, 1); // unchanged
      expect(updated.assignedTo, 50); // unchanged
    });

    test('should handle null values in JSON', () {
      final json = {
        'id': 1,
        'assigned_to': 50,
        'title': 'Test task',
        'status': 'pending',
        'created_at': '2025-01-01T00:00:00.000Z',
        'updated_at': '2025-01-01T00:00:00.000Z',
      };

      final actionItem = ActionItem.fromJson(json);

      expect(actionItem.circleId, null);
      expect(actionItem.callId, null);
      expect(actionItem.description, null);
      expect(actionItem.dueDate, null);
      expect(actionItem.priority, null);
    });
  });

  group('ActionItem Status', () {
    test('should validate status values', () {
      final statuses = ['pending', 'in_progress', 'completed', 'cancelled'];

      for (var status in statuses) {
        final actionItem = ActionItem(
          id: 1,
          assignedTo: 50,
          title: 'Test',
          status: status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(actionItem.status, status);
      }
    });
  });

  group('ActionItem Priority', () {
    test('should validate priority values', () {
      final priorities = ['low', 'medium', 'high'];

      for (var priority in priorities) {
        final actionItem = ActionItem(
          id: 1,
          assignedTo: 50,
          title: 'Test',
          status: 'pending',
          priority: priority,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        expect(actionItem.priority, priority);
      }
    });

    test('should allow null priority', () {
      final actionItem = ActionItem(
        id: 1,
        assignedTo: 50,
        title: 'Test',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(actionItem.priority, null);
    });
  });
}
