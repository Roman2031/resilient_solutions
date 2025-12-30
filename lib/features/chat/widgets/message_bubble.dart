import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../wordpress/data/models/buddyboss_models.dart';

/// Message Bubble
/// Displays an individual message in a conversation
class MessageBubble extends StatelessWidget {
  final BBMessage message;
  final bool isMe;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              _buildAvatar(),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe && message.senderName != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h, left: 12.w),
                      child: Text(
                        message.senderName!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                        bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      _formatTime(message.dateSent),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isMe) ...[
              SizedBox(width: 8.w),
              _buildAvatar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (message.senderAvatar != null) {
      return CircleAvatar(
        radius: 16.r,
        backgroundImage: NetworkImage(message.senderAvatar!),
      );
    }

    return CircleAvatar(
      radius: 16.r,
      child: Text(
        message.senderName?.isNotEmpty == true
            ? message.senderName![0].toUpperCase()
            : '?',
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24 && dateTime.day == now.day) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('h:mm a').format(dateTime)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE h:mm a').format(dateTime);
    } else {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }
}
