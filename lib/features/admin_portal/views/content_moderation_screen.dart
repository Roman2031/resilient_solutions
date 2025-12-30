import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../providers/moderation_provider.dart';
import '../widgets/admin_confirmation_dialog.dart';

/// Content Moderation Screen
/// Handles flagged content and moderation queue
class ContentModerationScreen extends ConsumerWidget {
  const ContentModerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.canModerate) {
      return const UnauthorizedScreen(
        message: 'Moderation access required',
      );
    }

    final flaggedAsync = ref.watch(flaggedContentProvider(status: 'pending'));

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Content Moderation'),
      ),
      body: flaggedAsync.when(
        data: (flagged) => flagged.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 64.sp, color: Colors.green),
                    Gap(16.h),
                    Text(
                      'No pending content to review',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: flagged.length,
                itemBuilder: (context, index) {
                  final content = flagged[index];
                  return Card(
                    color: const Color(0xff023C7B),
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: Colors.orange,
                                size: 20.sp,
                              ),
                              Gap(8.w),
                              Text(
                                content.contentType.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Gap(8.h),
                          Text(
                            content.content,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(8.h),
                          Text(
                            'Reason: ${content.reason}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            'Reported by: ${content.reporterName}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white54,
                            ),
                          ),
                          Gap(12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.check, color: Colors.green),
                                label: const Text(
                                  'Approve',
                                  style: TextStyle(color: Colors.green),
                                ),
                                onPressed: () async {
                                  final moderation = ref.read(contentModerationProvider.notifier);
                                  await moderation.approveContent(content.id);
                                  
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Content approved')),
                                    );
                                  }
                                },
                              ),
                              Gap(8.w),
                              TextButton.icon(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AdminConfirmationDialog(
                                      title: 'Remove Content',
                                      message: 'Are you sure you want to remove this content?',
                                      confirmText: 'Remove',
                                      isDangerous: true,
                                      requireReason: true,
                                      onConfirm: () {},
                                      onConfirmWithReason: (reason) async {
                                        final moderation = ref.read(contentModerationProvider.notifier);
                                        await moderation.removeContent(
                                          contentId: content.id,
                                          reason: reason,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
