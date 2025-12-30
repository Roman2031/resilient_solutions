import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_thread.freezed.dart';
part 'message_thread.g.dart';

/// Message Thread Model
/// Represents a conversation thread with participants
@freezed
class MessageThread with _$MessageThread {
  const MessageThread._();

  const factory MessageThread({
    required int id,
    String? subject,
    required List<ThreadParticipant> participants,
    required String lastMessage,
    @JsonKey(name: 'last_message_at') required DateTime lastMessageAt,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @JsonKey(name: 'is_group_chat') @Default(false) bool isGroupChat,
  }) = _MessageThread;

  factory MessageThread.fromJson(Map<String, dynamic> json) =>
      _$MessageThreadFromJson(json);

  /// Check if thread has unread messages
  bool get hasUnread => unreadCount > 0;

  /// Get display name for the thread
  String get displayName {
    if (subject != null && subject!.isNotEmpty) return subject!;
    return participants.map((p) => p.name).join(', ');
  }
}

/// Thread Participant Model
/// Represents a user participating in a message thread
@freezed
class ThreadParticipant with _$ThreadParticipant {
  const factory ThreadParticipant({
    required int id,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @JsonKey(name: 'last_seen') DateTime? lastSeen,
  }) = _ThreadParticipant;

  factory ThreadParticipant.fromJson(Map<String, dynamic> json) =>
      _$ThreadParticipantFromJson(json);
}
