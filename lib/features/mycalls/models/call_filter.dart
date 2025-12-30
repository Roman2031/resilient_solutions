/// Filter options for call lists
enum CallFilter {
  all,
  upcoming,
  past,
  cancelled;

  String get displayName {
    switch (this) {
      case CallFilter.all:
        return 'All';
      case CallFilter.upcoming:
        return 'Upcoming';
      case CallFilter.past:
        return 'Past';
      case CallFilter.cancelled:
        return 'Cancelled';
    }
  }
}

/// Extension to filter calls based on status and time
extension CallFilterExtension on CallFilter {
  bool matches(String status, DateTime scheduledAt) {
    final now = DateTime.now();
    
    switch (this) {
      case CallFilter.all:
        return true;
      case CallFilter.upcoming:
        return status == 'scheduled' && scheduledAt.isAfter(now);
      case CallFilter.past:
        return status == 'completed' || scheduledAt.isBefore(now);
      case CallFilter.cancelled:
        return status == 'cancelled';
    }
  }
}
