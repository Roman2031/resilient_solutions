import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/message_thread.dart';

/// Message Thread Card
/// Displays a preview of a message thread in the list
class MessageThreadCard extends StatelessWidget {
  final MessageThread thread;
  final VoidCallback onTap;

  const MessageThreadCard({
    super.key,
    required this.thread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListTile(
        onTap: onTap,
        leading: _buildAvatar(),
        title: Text(
          thread.displayName,
          style: TextStyle(
            fontWeight: thread.hasUnread ? FontWeight.bold : FontWeight.normal,
            fontSize: 16.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          thread.lastMessage,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(thread.lastMessageAt),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ),
            if (thread.hasUnread) ...[
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  thread.unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (thread.participants.isEmpty) {
      return CircleAvatar(
        radius: 24.r,
        child: Icon(Icons.person),
      );
    }

    if (thread.isGroupChat) {
      // Show group icon for group chats
      return CircleAvatar(
        radius: 24.r,
        child: Icon(Icons.group),
      );
    }

    // Show single participant avatar
    final participant = thread.participants.first;
    if (participant.avatarUrl != null) {
      return CircleAvatar(
        radius: 24.r,
        backgroundImage: NetworkImage(participant.avatarUrl!),
      );
    }

    return CircleAvatar(
      radius: 24.r,
      child: Text(
        participant.name.isNotEmpty ? participant.name[0].toUpperCase() : '?',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
