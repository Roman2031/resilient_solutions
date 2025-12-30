import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/admin_portal/data/models/admin_models.dart';

void main() {
  group('AdminUser Model', () {
    test('should create AdminUser from JSON', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'roles': ['admin', 'facilitator'],
        'status': 'active',
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final user = AdminUser.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.roles, ['admin', 'facilitator']);
      expect(user.status, 'active');
    });

    test('should serialize AdminUser to JSON', () {
      final user = AdminUser(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        roles: ['admin'],
        status: 'active',
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['roles'], ['admin']);
      expect(json['status'], 'active');
    });
  });

  group('AdminDashboardStats Model', () {
    test('should create AdminDashboardStats from JSON', () {
      final json = {
        'total_users': 100,
        'active_users': 80,
        'total_circles': 20,
        'active_circles': 15,
        'upcoming_calls': 5,
        'total_courses': 10,
        'total_messages': 500,
        'user_growth': {
          'new_users_today': 2,
          'new_users_this_week': 10,
          'new_users_this_month': 30,
          'growth_percentage': 5.5,
        },
        'system_health': {
          'status': 'healthy',
          'cpu_usage': 45.0,
          'memory_usage': 60.0,
          'disk_usage': 70.0,
          'error_count': 0,
          'last_checked': '2024-01-01T00:00:00Z',
        },
        'storage_stats': {
          'total_storage': 100.0,
          'used_storage': 50.0,
          'storage_unit': 'GB',
        },
      };

      final stats = AdminDashboardStats.fromJson(json);

      expect(stats.totalUsers, 100);
      expect(stats.activeUsers, 80);
      expect(stats.totalCircles, 20);
      expect(stats.userGrowth.newUsersToday, 2);
      expect(stats.systemHealth.status, 'healthy');
      expect(stats.storageStats.totalStorage, 100.0);
    });
  });

  group('SystemHealth Model', () {
    test('should indicate healthy status', () {
      final health = SystemHealth(
        status: 'healthy',
        cpuUsage: 45.0,
        memoryUsage: 60.0,
        diskUsage: 70.0,
        errorCount: 0,
        lastChecked: DateTime.now(),
      );

      expect(health.status, 'healthy');
      expect(health.errorCount, 0);
    });

    test('should indicate critical status with errors', () {
      final health = SystemHealth(
        status: 'critical',
        cpuUsage: 95.0,
        memoryUsage: 90.0,
        diskUsage: 85.0,
        errorCount: 10,
        lastChecked: DateTime.now(),
      );

      expect(health.status, 'critical');
      expect(health.errorCount, 10);
      expect(health.cpuUsage, greaterThan(80.0));
    });
  });

  group('PaginatedUsers Model', () {
    test('should create PaginatedUsers from JSON', () {
      final json = {
        'users': [
          {
            'id': 1,
            'name': 'User 1',
            'email': 'user1@example.com',
            'roles': ['learner'],
            'status': 'active',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
        ],
        'total': 100,
        'page': 1,
        'per_page': 20,
        'total_pages': 5,
      };

      final paginated = PaginatedUsers.fromJson(json);

      expect(paginated.users.length, 1);
      expect(paginated.total, 100);
      expect(paginated.page, 1);
      expect(paginated.perPage, 20);
      expect(paginated.totalPages, 5);
    });
  });
}
