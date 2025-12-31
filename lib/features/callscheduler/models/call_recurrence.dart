import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_recurrence.freezed.dart';
part 'call_recurrence.g.dart';

/// Recurrence pattern for scheduled calls
enum RecurrenceType {
  @JsonValue('none')
  none,
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('biweekly')
  biweekly,
  @JsonValue('monthly')
  monthly;

  String get displayName {
    switch (this) {
      case RecurrenceType.none:
        return 'Does not repeat';
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.biweekly:
        return 'Every 2 weeks';
      case RecurrenceType.monthly:
        return 'Monthly';
    }
  }
}

/// Recurrence configuration for calls
@freezed
abstract class CallRecurrence with _$CallRecurrence {
  const factory CallRecurrence({
    required RecurrenceType type,
    DateTime? endDate,
    int? occurrences,
  }) = _CallRecurrence;

  factory CallRecurrence.fromJson(Map<String, dynamic> json) =>
      _$CallRecurrenceFromJson(json);
}
