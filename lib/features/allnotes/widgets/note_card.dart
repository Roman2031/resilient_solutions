import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../call_service/data/models/call_service_models.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final String? callTitle;
  final String? circleName;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const NoteCard({
    super.key,
    required this.note,
    this.callTitle,
    this.circleName,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: const Color(0xff023C7B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap ?? onEdit,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with privacy indicator and menu
              Row(
                children: [
                  // Privacy badge
                  if (note.isPrivate)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffFF9800).withOpacity(0.2),
                        border: Border.all(color: const Color(0xffFF9800)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 12.sp,
                            color: const Color(0xffFF9800),
                          ),
                          Gap(4.w),
                          Text(
                            'PRIVATE',
                            style: TextStyle(
                              color: const Color(0xffFF9800),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Actions menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: const Color(0xff012B5E),
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) {
                        onEdit!();
                      } else if (value == 'delete' && onDelete != null) {
                        onDelete!();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, color: Colors.white),
                            Gap(8.w),
                            const Text('Edit', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, color: Colors.red),
                            Gap(8.w),
                            const Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(8.h),
              // Call/Circle info
              if (callTitle != null || circleName != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 14.sp,
                      color: const Color(0xff0082DF),
                    ),
                    Gap(4.w),
                    Expanded(
                      child: Text(
                        callTitle ?? 'Unknown Call',
                        style: TextStyle(
                          color: const Color(0xff0082DF),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (circleName != null) ...[
                  Gap(4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        size: 14.sp,
                        color: Colors.white70,
                      ),
                      Gap(4.w),
                      Expanded(
                        child: Text(
                          circleName!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(12.h),
              ],
              // Note content
              Text(
                note.content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(12.h),
              // Footer with timestamp
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12.sp,
                    color: Colors.white70,
                  ),
                  Gap(4.w),
                  Text(
                    DateFormat('MMM dd, yyyy · hh:mm a').format(note.createdAt),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.sp,
                    ),
                  ),
                  if (note.updatedAt != note.createdAt) ...[
                    Gap(8.w),
                    Text(
                      '(edited)',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
