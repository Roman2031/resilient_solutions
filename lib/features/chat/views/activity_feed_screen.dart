import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../wordpress/data/models/buddyboss_models.dart';
import '../providers/activity_provider.dart';
import '../widgets/error_view.dart';

/// Activity Feed Screen
/// Displays BuddyBoss activity feed with social interactions
class ActivityFeedScreen extends ConsumerStatefulWidget {
  const ActivityFeedScreen({super.key});

  @override
  ConsumerState<ActivityFeedScreen> createState() =>
      _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends ConsumerState<ActivityFeedScreen> {
  final TextEditingController _postController = TextEditingController();
  int _currentPage = 1;
  String? _filterType;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activitiesAsync = ref.watch(
      activityFeedProvider(
        page: _currentPage,
        perPage: 20,
        type: _filterType,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterType = value == 'all' ? null : value;
                _currentPage = 1;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Activities'),
              ),
              const PopupMenuItem(
                value: 'activity_update',
                child: Text('Updates Only'),
              ),
              const PopupMenuItem(
                value: 'new_member',
                child: Text('New Members'),
              ),
              const PopupMenuItem(
                value: 'group_created',
                child: Text('Groups Created'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Post creation box
          _buildPostCreationBox(),

          // Activity feed
          Expanded(
            child: activitiesAsync.when(
              data: (activities) {
                if (activities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.feed_outlined,
                          size: 64.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No activities yet',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() => _currentPage = 1);
                    await ref.refresh(
                      activityFeedProvider(
                        page: _currentPage,
                        perPage: 20,
                        type: _filterType,
                      ).future,
                    );
                  },
                  child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return ActivityCard(
                        activity: activity,
                        onDelete: () => _deleteActivity(activity.id),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => ErrorView(
                error: error,
                onRetry: () => ref.refresh(
                  activityFeedProvider(
                    page: _currentPage,
                    perPage: 20,
                    type: _filterType,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCreationBox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _postController,
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.all(12.w),
            ),
            maxLines: 3,
            minLines: 1,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _createPost,
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _createPost() async {
    final content = _postController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    try {
      await ref.read(activityActionsProvider.notifier).createPost(
            content: content,
          );

      _postController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully')),
        );
      }

      // Refresh feed
      setState(() => _currentPage = 1);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }

  Future<void> _deleteActivity(int activityId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(activityActionsProvider.notifier).deleteActivity(
            activityId,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete activity: $e')),
        );
      }
    }
  }
}

/// Activity Card Widget
/// Displays a single activity item
class ActivityCard extends StatelessWidget {
  final BBActivity activity;
  final VoidCallback onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and timestamp
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: activity.userAvatar != null
                      ? NetworkImage(activity.userAvatar!)
                      : null,
                  child: activity.userAvatar == null
                      ? Text(
                          activity.userName?.isNotEmpty == true
                              ? activity.userName![0].toUpperCase()
                              : '?',
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.userName ?? 'Unknown User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        _formatTime(activity.dateRecorded),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: onDelete,
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Activity content
            Text(
              activity.content,
              style: TextStyle(fontSize: 14.sp),
            ),

            SizedBox(height: 12.h),

            // Activity type badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getActivityTypeColor(activity.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                _formatActivityType(activity.type),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: _getActivityTypeColor(activity.type),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Action buttons
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement like
                  },
                  icon: Icon(
                    activity.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 18.sp,
                  ),
                  label: const Text('Like'),
                ),
                if (activity.canComment)
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement comment
                    },
                    icon: Icon(Icons.comment_outlined, size: 18.sp),
                    label: Text('Comment (${activity.commentCount})'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getActivityTypeColor(String type) {
    switch (type) {
      case 'activity_update':
        return Colors.blue;
      case 'new_member':
        return Colors.green;
      case 'group_created':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatActivityType(String type) {
    switch (type) {
      case 'activity_update':
        return 'Update';
      case 'new_member':
        return 'New Member';
      case 'group_created':
        return 'Group Created';
      default:
        return type.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }
}
