import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/auth/auth_repository.dart';
import '../models/message_thread.dart';
import '../providers/messages_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/message_bubble.dart';
import '../widgets/messages_list_skeleton.dart';

/// Message Thread Screen
/// Displays messages in a conversation and allows sending new messages
class MessageThreadScreen extends ConsumerStatefulWidget {
  final MessageThread thread;

  const MessageThreadScreen({
    super.key,
    required this.thread,
  });

  @override
  ConsumerState<MessageThreadScreen> createState() =>
      _MessageThreadScreenState();
}

class _MessageThreadScreenState extends ConsumerState<MessageThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();

    // Mark as read
    Future.microtask(() {
      ref.read(messageActionsProvider.notifier).markAsRead(widget.thread.id);
    });

    // Start polling for new messages (every 5 seconds)
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      ref.refresh(threadMessagesProvider(widget.thread.id));
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync =
        ref.watch(threadMessagesProvider(widget.thread.id));
    final authState = ref.watch(authRepositoryProvider);

    // Get current user ID
    String? currentUserId;
    authState.whenData((state) {
      if (state is AuthenticatedState) {
        currentUserId = state.userInfo['sub'] as String?;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.thread.displayName,
              style: TextStyle(fontSize: 16.sp),
            ),
            if (widget.thread.participants.isNotEmpty)
              Text(
                widget.thread.participants
                    .map((p) => p.name)
                    .join(', '),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showThreadInfo(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                // Scroll to bottom after build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.w),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = currentUserId != null &&
                        message.senderId.toString() == currentUserId;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                      onLongPress: () => _showMessageOptions(message, isMe),
                    );
                  },
                );
              },
              loading: () => const MessagesListSkeleton(),
              error: (error, stack) => ErrorView(
                error: error,
                onRetry: () =>
                    ref.refresh(threadMessagesProvider(widget.thread.id)),
              ),
            ),
          ),

          // Message input
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () => _showEmojiPicker(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();

    if (content.isEmpty) return;

    try {
      await ref.read(messageActionsProvider.notifier).sendMessage(
            threadId: widget.thread.id,
            content: content,
          );

      _messageController.clear();

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _showMessageOptions(dynamic message, bool isMe) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  // TODO: Implement copy
                  Navigator.pop(context);
                },
              ),
              if (isMe)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteMessage(message.id);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteMessage(int messageId) async {
    try {
      await ref.read(messageActionsProvider.notifier).deleteMessage(
            messageId,
            widget.thread.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete message: $e')),
        );
      }
    }
  }

  void _showThreadInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Conversation Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject: ${widget.thread.subject ?? 'No subject'}'),
              SizedBox(height: 8.h),
              const Text('Participants:'),
              ...widget.thread.participants.map((p) => Text('• ${p.name}')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEmojiPicker() {
    // TODO: Implement emoji picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emoji picker coming soon!')),
    );
  }
}
