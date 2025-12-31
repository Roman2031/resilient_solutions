import 'package:freezed_annotation/freezed_annotation.dart';

part 'buddyboss_models.freezed.dart';
part 'buddyboss_models.g.dart';

/// BuddyBoss Group Model
@freezed
abstract class BBGroup with _$BBGroup {
  const factory BBGroup({
    required int id,
    required String name,
    required String description,
    String? status, // public, private, hidden
    @JsonKey(name: 'creator_id') int? creatorId,
    @JsonKey(name: 'date_created') DateTime? dateCreated,
    @JsonKey(name: 'total_member_count') @Default(0) int totalMemberCount,
    @JsonKey(name: 'last_activity') DateTime? lastActivity,
    String? avatar,
    String? cover,
    @JsonKey(name: 'group_type') String? groupType,
  }) = _BBGroup;

  factory BBGroup.fromJson(Map<String, dynamic> json) =>
      _$BBGroupFromJson(json);
}

/// BuddyBoss Group Member Model
@freezed
abstract class BBGroupMember with _$BBGroupMember {
  const factory BBGroupMember({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'group_id') required int groupId,
    @JsonKey(name: 'is_admin') @Default(false) bool isAdmin,
    @JsonKey(name: 'is_mod') @Default(false) bool isMod,
    @JsonKey(name: 'date_modified') DateTime? dateModified,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_avatar') String? userAvatar,
  }) = _BBGroupMember;

  factory BBGroupMember.fromJson(Map<String, dynamic> json) =>
      _$BBGroupMemberFromJson(json);
}

/// BuddyBoss Activity Model
@freezed
abstract class BBActivity with _$BBActivity {
  const factory BBActivity({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_avatar') String? userAvatar,
    @JsonKey(name: 'component') required String component, // groups, activity, etc
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'primary_item_id') int? primaryItemId,
    @JsonKey(name: 'secondary_item_id') int? secondaryItemId,
    required String content,
    @JsonKey(name: 'date_recorded') required DateTime dateRecorded,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
    @JsonKey(name: 'can_comment') @Default(true) bool canComment,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _BBActivity;

  factory BBActivity.fromJson(Map<String, dynamic> json) =>
      _$BBActivityFromJson(json);
}

/// BuddyBoss Message Model
@freezed
abstract class BBMessage with _$BBMessage {
  const factory BBMessage({
    required int id,
    @JsonKey(name: 'sender_id') required int senderId,
    @JsonKey(name: 'sender_name') String? senderName,
    @JsonKey(name: 'sender_avatar') String? senderAvatar,
    @JsonKey(name: 'thread_id') required int threadId,
    required String subject,
    required String message,
    @JsonKey(name: 'date_sent') required DateTime dateSent,
    @JsonKey(name: 'is_unread') @Default(false) bool isUnread,
  }) = _BBMessage;

  factory BBMessage.fromJson(Map<String, dynamic> json) =>
      _$BBMessageFromJson(json);
}

/// Group Type Model
@freezed
abstract class BBGroupType with _$BBGroupType {
  const factory BBGroupType({
    required int id,
    required String name,
    String? description,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
  }) = _BBGroupType;

  factory BBGroupType.fromJson(Map<String, dynamic> json) =>
      _$BBGroupTypeFromJson(json);
}
