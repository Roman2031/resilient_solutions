import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../wordpress/data/models/buddyboss_models.dart';
import '../../wordpress/data/repositories/wordpress_repository.dart';
import '../models/message_thread.dart';

part 'messages_provider.g.dart';

/// Provider for fetching all message threads
@riverpod
Future<List<MessageThread>> messageThreads(MessageThreadsRef ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(wordPressRepositoryProvider);
  
  // Get current user ID from auth token
  final userId = authState.userInfo['sub'] as String?;
  final userIdInt = userId != null ? int.tryParse(userId) : null;
  
  // Fetch threads from BuddyBoss
  final threadsData = await repository.getBBMessageThreads(userId: userIdInt);
  
  // Convert raw thread data to MessageThread objects
  final threads = threadsData.map((threadData) {
    // Parse participants
    final participantsData = threadData['recipients'] as List? ?? [];
    final participants = participantsData.map((p) {
      return ThreadParticipant(
        id: p['id'] as int,
        name: p['name'] as String? ?? 'Unknown',
        avatarUrl: p['avatar_url'] as String?,
        isOnline: p['is_online'] as bool? ?? false,
        lastSeen: p['last_seen'] != null 
            ? DateTime.tryParse(p['last_seen'] as String)
            : null,
      );
    }).toList();
    
    return MessageThread(
      id: threadData['id'] as int,
      subject: threadData['subject'] as String?,
      participants: participants,
      lastMessage: threadData['last_message'] as String? ?? '',
      lastMessageAt: DateTime.tryParse(threadData['last_message_at'] as String? ?? '') 
          ?? DateTime.now(),
      unreadCount: threadData['unread_count'] as int? ?? 0,
      isGroupChat: (participants.length > 2),
    );
  }).toList();
  
  // Sort by most recent
  threads.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
  
  return threads;
}

/// Provider for fetching messages in a specific thread
@riverpod
Future<List<BBMessage>> threadMessages(
  ThreadMessagesRef ref,
  int threadId,
) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  
  final messages = await repository.getBBMessages(threadId);
  
  // Sort chronologically (oldest first)
  messages.sort((a, b) => a.dateSent.compareTo(b.dateSent));
  
  return messages;
}

/// Notifier for message actions (CRUD operations)
@riverpod
class MessageActions extends _$MessageActions {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Send a message to an existing thread
  Future<BBMessage> sendMessage({
    required int threadId,
    required String content,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      
      final message = await repository.createBBMessage(
        threadId: threadId,
        message: content,
      );
      
      // Invalidate to refresh
      ref.invalidate(threadMessagesProvider(threadId));
      ref.invalidate(messageThreadsProvider);
      
      return message;
    }).then((result) {
      state = result;
      return result.when(
        data: (message) => message,
        loading: () => throw Exception('Message send in progress'),
        error: (error, stack) => throw error,
      );
    });
  }

  /// Create a new message thread
  Future<Map<String, dynamic>> createThread({
    required List<int> recipientIds,
    required String firstMessage,
    String? subject,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      
      // Create new thread with first message
      final thread = await repository.createBBMessageThread(
        recipientIds: recipientIds,
        message: firstMessage,
        subject: subject,
      );
      
      ref.invalidate(messageThreadsProvider);
      
      return thread;
    }).then((result) {
      state = result;
      return result.when(
        data: (thread) => thread,
        loading: () => throw Exception('Thread creation in progress'),
        error: (error, stack) => throw error,
      );
    });
  }

  /// Update a message
  Future<void> updateMessage({
    required int messageId,
    String? content,
  }) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      
      await repository.updateBBMessage(
        messageId: messageId,
        message: content,
      );
      
      // Invalidate affected threads
      ref.invalidate(messageThreadsProvider);
    }).then((result) {
      state = result;
      if (result.hasError) {
        throw result.error!;
      }
    });
  }

  /// Delete a message
  Future<void> deleteMessage(int messageId, int threadId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      
      await repository.deleteBBMessage(messageId);
      
      ref.invalidate(threadMessagesProvider(threadId));
      ref.invalidate(messageThreadsProvider);
    }).then((result) {
      state = result;
      if (result.hasError) {
        throw result.error!;
      }
    });
  }

  /// Mark a thread as read
  Future<void> markAsRead(int threadId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      
      await repository.markThreadAsRead(threadId);
      
      ref.invalidate(messageThreadsProvider);
    }).then((result) {
      state = result;
      if (result.hasError) {
        throw result.error!;
      }
    });
  }
}
