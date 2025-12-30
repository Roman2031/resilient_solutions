import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/admin_portal/data/models/analytics_models.dart';

void main() {
  group('UserAnalytics Model', () {
    test('should create UserAnalytics from JSON', () {
      final json = {
        'user_growth': [
          {'date': '2024-01-01T00:00:00Z', 'value': 10.0},
          {'date': '2024-01-02T00:00:00Z', 'value': 15.0},
        ],
        'users_by_role': {
          'learner': 50,
          'facilitator': 10,
          'instructor': 5,
          'admin': 2,
        },
        'users_by_status': {
          'active': 60,
          'inactive': 5,
          'suspended': 2,
        },
        'retention_rate': 85.5,
        'active_users': 60,
        'total_users': 67,
      };

      final analytics = UserAnalytics.fromJson(json);

      expect(analytics.userGrowth.length, 2);
      expect(analytics.usersByRole['learner'], 50);
      expect(analytics.usersByStatus['active'], 60);
      expect(analytics.retentionRate, 85.5);
      expect(analytics.activeUsers, 60);
      expect(analytics.totalUsers, 67);
    });
  });

  group('DataPoint Model', () {
    test('should create DataPoint from JSON', () {
      final json = {
        'date': '2024-01-01T00:00:00Z',
        'value': 42.5,
      };

      final dataPoint = DataPoint.fromJson(json);

      expect(dataPoint.date, DateTime.parse('2024-01-01T00:00:00Z'));
      expect(dataPoint.value, 42.5);
    });

    test('should serialize DataPoint to JSON', () {
      final dataPoint = DataPoint(
        date: DateTime.parse('2024-01-01T00:00:00Z'),
        value: 42.5,
      );

      final json = dataPoint.toJson();

      expect(json['value'], 42.5);
    });
  });

  group('CircleAnalytics Model', () {
    test('should create CircleAnalytics from JSON', () {
      final json = {
        'total_circles': 50,
        'active_circles': 40,
        'average_members': 12.5,
        'circles_by_category': {
          'general': 20,
          'special': 15,
          'study': 15,
        },
        'circle_creation_trend': [
          {'date': '2024-01-01T00:00:00Z', 'value': 5.0},
          {'date': '2024-01-02T00:00:00Z', 'value': 8.0},
        ],
      };

      final analytics = CircleAnalytics.fromJson(json);

      expect(analytics.totalCircles, 50);
      expect(analytics.activeCircles, 40);
      expect(analytics.averageMembers, 12.5);
      expect(analytics.circlesByCategory['general'], 20);
      expect(analytics.circleCreationTrend.length, 2);
    });
  });

  group('LearningAnalytics Model', () {
    test('should create LearningAnalytics from JSON', () {
      final json = {
        'total_enrollments': 200,
        'average_completion_rate': 75.5,
        'popular_courses': [
          {
            'id': 1,
            'name': 'Course 1',
            'enrollment_count': 50,
            'completion_rate': 80.0,
          },
        ],
        'certificates_issued': 100,
        'quiz_score_distribution': {
          '0-50': 10,
          '51-75': 30,
          '76-100': 60,
        },
      };

      final analytics = LearningAnalytics.fromJson(json);

      expect(analytics.totalEnrollments, 200);
      expect(analytics.averageCompletionRate, 75.5);
      expect(analytics.popularCourses.length, 1);
      expect(analytics.certificatesIssued, 100);
      expect(analytics.quizScoreDistribution['76-100'], 60);
    });
  });

  group('PopularCourse Model', () {
    test('should create PopularCourse from JSON', () {
      final json = {
        'id': 1,
        'name': 'Introduction to Flutter',
        'enrollment_count': 150,
        'completion_rate': 82.5,
      };

      final course = PopularCourse.fromJson(json);

      expect(course.id, 1);
      expect(course.name, 'Introduction to Flutter');
      expect(course.enrollmentCount, 150);
      expect(course.completionRate, 82.5);
    });
  });

  group('FlaggedContent Model', () {
    test('should create FlaggedContent from JSON', () {
      final json = {
        'id': 1,
        'content_type': 'message',
        'content_id': 123,
        'content': 'Inappropriate message content',
        'reason': 'Spam',
        'reporter_id': 456,
        'reporter_name': 'Reporter User',
        'status': 'pending',
        'created_at': '2024-01-01T00:00:00Z',
      };

      final flagged = FlaggedContent.fromJson(json);

      expect(flagged.id, 1);
      expect(flagged.contentType, 'message');
      expect(flagged.content, 'Inappropriate message content');
      expect(flagged.reason, 'Spam');
      expect(flagged.status, 'pending');
    });
  });

  group('SystemSettings Model', () {
    test('should create SystemSettings from JSON', () {
      final json = {
        'platform_name': 'Kingdom Call Circle',
        'default_language': 'en',
        'timezone': 'UTC',
        'registration_enabled': true,
        'email_verification_required': true,
        'max_circle_members': 20,
        'session_timeout': 60,
        'max_file_size': 10,
      };

      final settings = SystemSettings.fromJson(json);

      expect(settings.platformName, 'Kingdom Call Circle');
      expect(settings.defaultLanguage, 'en');
      expect(settings.registrationEnabled, true);
      expect(settings.maxCircleMembers, 20);
      expect(settings.sessionTimeout, 60);
    });
  });
}
