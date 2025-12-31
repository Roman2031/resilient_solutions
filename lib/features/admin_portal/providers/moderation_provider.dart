import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../data/models/admin_models.dart';
import '../data/models/analytics_models.dart';
import '../data/repositories/admin_portal_repository.dart';

part 'moderation_provider.g.dart';

/// Flagged Content Provider
@riverpod
Future<List<FlaggedContent>> flaggedContent(
  Ref ref, {
  String? status,
  String? contentType,
}) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.canModerate) {
    throw Exception('Moderation access required');
  }
  
  return await repository.getFlaggedContent(
    status: status,
    contentType: contentType,
  );
}

/// Moderation History Provider
@riverpod
Future<List<AuditLog>> moderationHistory(Ref ref) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.canModerate) {
    throw Exception('Moderation access required');
  }
  
  return await repository.getModerationHistory();
}

/// Content Moderation Actions Provider
@riverpod
class ContentModeration extends _$ContentModeration {
  @override
  FutureOr<void> build() async {
    // Initialize if needed
  }

  /// Approve content
  Future<void> approveContent(int contentId) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.approveContent(contentId);
      
      // Invalidate to refresh flagged content list
      ref.invalidate(flaggedContentProvider);
      ref.invalidate(moderationHistoryProvider);
    });
  }

  /// Remove content
  Future<void> removeContent({
    required int contentId,
    required String reason,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.removeContent(
        contentId: contentId,
        reason: reason,
      );
      
      // Invalidate to refresh lists
      ref.invalidate(flaggedContentProvider);
      ref.invalidate(moderationHistoryProvider);
    });
  }
}
