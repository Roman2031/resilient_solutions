import 'package:freezed_annotation/freezed_annotation.dart';
import '../../call_service/data/models/call_service_models.dart';

part 'circle_details.freezed.dart';
part 'circle_details.g.dart';

/// Extended circle details with related data
@freezed
class CircleDetails with _$CircleDetails {
  const factory CircleDetails({
    required Circle circle,
    required List<CircleMember> members,
    required List<Call> upcomingCalls,
    required List<Call> pastCalls,
    @Default([]) List<Note> recentNotes,
    @Default([]) List<ActionItem> activeActions,
  }) = _CircleDetails;

  factory CircleDetails.fromJson(Map<String, dynamic> json) =>
      _$CircleDetailsFromJson(json);
}

/// Call details with all related information
@freezed
class CallDetails with _$CallDetails {
  const factory CallDetails({
    required Call call,
    required List<Note> notes,
    required List<ActionItem> actions,
    required List<CircleMember> participants,
  }) = _CallDetails;

  factory CallDetails.fromJson(Map<String, dynamic> json) =>
      _$CallDetailsFromJson(json);
}
