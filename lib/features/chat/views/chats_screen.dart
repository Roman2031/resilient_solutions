import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/messages_provider.dart';
import '../widgets/empty_messages_state.dart';
import '../widgets/error_view.dart';
import '../widgets/message_thread_card.dart';
import '../widgets/message_threads_skeleton.dart';
import 'message_thread_screen.dart';

/// Chats Screen
/// Displays all message threads with BuddyBoss integration
class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showUnreadOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final threadsAsync = ref.watch(messageThreadsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewMessageDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: EdgeInsets.all(16.w),
            child: FilterChip(
              label: const Text('Unread Only'),
              selected: _showUnreadOnly,
              onSelected: (selected) {
                setState(() => _showUnreadOnly = selected);
              },
            ),
          ),

          // Message threads list
          Expanded(
            child: threadsAsync.when(
              data: (threads) {
                var filteredThreads = threads;

                if (_showUnreadOnly) {
                  filteredThreads =
                      threads.where((t) => t.unreadCount > 0).toList();
                }

                if (filteredThreads.isEmpty) {
                  return EmptyMessagesState(
                    onStartChat: _showNewMessageDialog,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.refresh(messageThreadsProvider.future);
                  },
                  child: ListView.builder(
                    itemCount: filteredThreads.length,
                    itemBuilder: (context, index) {
                      final thread = filteredThreads[index];
                      return MessageThreadCard(
                        thread: thread,
                        onTap: () => _openThread(thread),
                      );
                    },
                  ),
                );
              },
              loading: () => const MessageThreadsSkeleton(),
              error: (error, stack) => ErrorView(
                error: error,
                onRetry: () => ref.refresh(messageThreadsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openThread(thread) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageThreadScreen(thread: thread),
      ),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _MessageSearchDelegate(ref),
    );
  }

  void _showNewMessageDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New message feature coming soon!'),
      ),
    );
  }
}

/// Search delegate for searching messages
class _MessageSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  _MessageSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final threadsAsync = ref.watch(messageThreadsProvider);

    return threadsAsync.when(
      data: (threads) {
        final filteredThreads = threads.where((thread) {
          final lowerQuery = query.toLowerCase();
          return thread.displayName.toLowerCase().contains(lowerQuery) ||
              thread.lastMessage.toLowerCase().contains(lowerQuery);
        }).toList();

        if (filteredThreads.isEmpty) {
          return const Center(
            child: Text('No conversations found'),
          );
        }

        return ListView.builder(
          itemCount: filteredThreads.length,
          itemBuilder: (context, index) {
            final thread = filteredThreads[index];
            return MessageThreadCard(
              thread: thread,
              onTap: () {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageThreadScreen(thread: thread),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const MessageThreadsSkeleton(),
      error: (error, stack) => ErrorView(
        error: error,
        onRetry: () => ref.refresh(messageThreadsProvider),
      ),
    );
  }
}
