import '../logging/app_logger.dart';

// Firebase imports - uncomment when Firebase is configured
// import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics service for tracking user behavior and app usage
/// 
/// Integrates with Firebase Analytics for production monitoring
/// All events are logged for debugging
/// 
/// To enable Firebase Analytics:
/// 1. Add Firebase configuration files to your project
/// 2. Set FIREBASE_ENABLED=true in environment
/// 3. Rebuild the app
class AnalyticsService {
  // Firebase enabled flag - set via environment variable
  static const bool _firebaseEnabled = bool.fromEnvironment(
    'FIREBASE_ENABLED',
    defaultValue: false,
  );

  // Firebase Analytics instance (null if not enabled)
  // Uncomment when Firebase is configured
  // static final FirebaseAnalytics? _analytics = 
  //     _firebaseEnabled ? FirebaseAnalytics.instance : null;

  /// Log a custom event
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      AppLogger.userAction('Analytics Event: $name', params: parameters);
      
      // Send to Firebase if enabled
      if (_firebaseEnabled) {
        // Uncomment when Firebase is configured
        // await _analytics?.logEvent(
        //   name: name,
        //   parameters: parameters,
        // );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to log analytics event: $name', e, stackTrace);
    }
  }

  /// Log screen view
  static Future<void> logScreenView(String screenName) async {
    try {
      AppLogger.debug('Screen View: $screenName');
      
      // Send to Firebase if enabled
      if (_firebaseEnabled) {
        // Uncomment when Firebase is configured
        // await _analytics?.logScreenView(screenName: screenName);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to log screen view: $screenName', e, stackTrace);
    }
  }

  /// Set user ID
  static Future<void> setUserId(String userId) async {
    try {
      AppLogger.info('Set User ID: $userId');
      
      // Send to Firebase if enabled
      if (_firebaseEnabled) {
        // Uncomment when Firebase is configured
        // await _analytics?.setUserId(id: userId);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to set user ID', e, stackTrace);
    }
  }

  /// Set user property
  static Future<void> setUserProperty(String name, String value) async {
    try {
      AppLogger.debug('Set User Property: $name = $value');
      
      // Send to Firebase if enabled
      if (_firebaseEnabled) {
        // Uncomment when Firebase is configured
        // await _analytics?.setUserProperty(name: name, value: value);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to set user property: $name', e, stackTrace);
    }
  }

  // Custom events for the app

  /// Log login event
  static Future<void> logLogin(String method) async {
    await logEvent(name: 'login', parameters: {'method': method});
  }

  /// Log logout event
  static Future<void> logLogout() async {
    await logEvent(name: 'logout');
  }

  /// Log sign up event
  static Future<void> logSignUp(String method) async {
    await logEvent(name: 'sign_up', parameters: {'method': method});
  }

  /// Log circle created
  static Future<void> logCircleCreated(String circleId, {String? circleType}) async {
    await logEvent(
      name: 'circle_created',
      parameters: {
        'circle_id': circleId,
        if (circleType != null) 'circle_type': circleType,
      },
    );
  }

  /// Log circle joined
  static Future<void> logCircleJoined(String circleId) async {
    await logEvent(name: 'circle_joined', parameters: {'circle_id': circleId});
  }

  /// Log call scheduled
  static Future<void> logCallScheduled(String callId, String circleId) async {
    await logEvent(
      name: 'call_scheduled',
      parameters: {
        'call_id': callId,
        'circle_id': circleId,
      },
    );
  }

  /// Log course enrolled
  static Future<void> logCourseEnrolled(String courseId, String courseTitle) async {
    await logEvent(
      name: 'course_enrolled',
      parameters: {
        'course_id': courseId,
        'course_title': courseTitle,
      },
    );
  }

  /// Log course completed
  static Future<void> logCourseCompleted(String courseId, String courseTitle) async {
    await logEvent(
      name: 'course_completed',
      parameters: {
        'course_id': courseId,
        'course_title': courseTitle,
      },
    );
  }

  /// Log lesson started
  static Future<void> logLessonStarted(String lessonId, String courseId) async {
    await logEvent(
      name: 'lesson_started',
      parameters: {
        'lesson_id': lessonId,
        'course_id': courseId,
      },
    );
  }

  /// Log lesson completed
  static Future<void> logLessonCompleted(String lessonId, String courseId) async {
    await logEvent(
      name: 'lesson_completed',
      parameters: {
        'lesson_id': lessonId,
        'course_id': courseId,
      },
    );
  }

  /// Log quiz started
  static Future<void> logQuizStarted(String quizId, String courseId) async {
    await logEvent(
      name: 'quiz_started',
      parameters: {
        'quiz_id': quizId,
        'course_id': courseId,
      },
    );
  }

  /// Log quiz completed
  static Future<void> logQuizCompleted(String quizId, String courseId, double score) async {
    await logEvent(
      name: 'quiz_completed',
      parameters: {
        'quiz_id': quizId,
        'course_id': courseId,
        'score': score,
      },
    );
  }

  /// Log message sent
  static Future<void> logMessageSent(String conversationType) async {
    await logEvent(
      name: 'message_sent',
      parameters: {'conversation_type': conversationType},
    );
  }

  /// Log note created
  static Future<void> logNoteCreated(String noteType) async {
    await logEvent(name: 'note_created', parameters: {'note_type': noteType});
  }

  /// Log action item created
  static Future<void> logActionItemCreated() async {
    await logEvent(name: 'action_item_created');
  }

  /// Log action item completed
  static Future<void> logActionItemCompleted() async {
    await logEvent(name: 'action_item_completed');
  }

  /// Log search performed
  static Future<void> logSearch(String searchTerm, String searchType) async {
    await logEvent(
      name: 'search',
      parameters: {
        'search_term': searchTerm,
        'search_type': searchType,
      },
    );
  }

  /// Log share action
  static Future<void> logShare(String contentType, String contentId) async {
    await logEvent(
      name: 'share',
      parameters: {
        'content_type': contentType,
        'content_id': contentId,
      },
    );
  }

  /// Log error
  static Future<void> logError(String errorType, String errorMessage) async {
    await logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
      },
    );
  }
}
