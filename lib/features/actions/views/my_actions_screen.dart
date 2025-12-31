import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/actions_provider.dart';
import '../widgets/action_item_card.dart';
import '../widgets/actions_list_skeleton.dart';
import '../widgets/empty_actions_state.dart';
import '../widgets/action_filter_chips.dart';
import '../widgets/edit_action_dialog.dart';
import '../../call_service/data/models/call_service_models.dart';

/// Temporary StateNotifier that exposes the methods used in this screen.
/// Replace this with the actual notifier/provider implementation from
/// providers/actions_provider.dart when available.
class ActionActionsNotifier {
  final Ref ref;
  ActionActionsNotifier(this.ref);

  Future<void> deleteAction(dynamic id) async {
    // TODO: implement deletion logic via repository or existing providers.
  }

  Future<void> markComplete(dynamic id) async {
    // TODO: implement mark-complete logic via repository or existing providers.
  }

  Future<void> updateAction({
    required dynamic actionId,
    required String title,
    required String description,
    required DateTime? dueDate,
    required String priority,
    required String status,
  }) async {
    // TODO: implement update logic via repository or existing providers.
  }
}

final actionActionsNotifierProvider =
    Provider<ActionActionsNotifier>(
  (ref) => ActionActionsNotifier(ref),
);

class MyActionsScreen extends ConsumerStatefulWidget {
  const MyActionsScreen({super.key});

  @override
  ConsumerState<MyActionsScreen> createState() => _MyActionsScreenState();
}

class _MyActionsScreenState extends ConsumerState<MyActionsScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  Future<void> _handleDelete(ActionItem action) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff023C7B),
        title: const Text(
          'Delete Action Item',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${action.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(actionActionsNotifierProvider)
            .deleteAction(action.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Action item deleted'),
              backgroundColor: Color(0xff4CAF50),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting action: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleComplete(ActionItem action) async {
    try {
      await ref
          .read(actionActionsNotifierProvider)
          .markComplete(action.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Action marked as completed'),
            backgroundColor: Color(0xff4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating action: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleEdit(ActionItem action) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditActionDialog(action: action),
    );

    if (result != null) {
      try {
        await ref.read(actionActionsNotifierProvider).updateAction(
              actionId: action.id,
              title: result['title'],
              description: result['description'],
              dueDate: result['dueDate'],
              priority: result['priority'],
              status: result['status'],
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Action item updated'),
              backgroundColor: Color(0xff4CAF50),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating action: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionsAsync = _searchQuery.isNotEmpty
        ? ref.watch(searchActionsProvider(_searchQuery))
        : ref.watch(filteredActionsProvider(_selectedFilter));

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset("assets/pngs/logo.png", height: 50.h),
        ),
      ),
      body: Column(
        children: [
          Gap(24.h),
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff023C7B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.r),
                bottomRight: Radius.circular(32.r),
              ),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 39.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff0082DF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.r),
                      bottomRight: Radius.circular(32.r),
                    ),
                  ),
                  child: Text(
                    "MY ACTION ITEMS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(20.h),
                // Search bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Color(0xff0082DF),
                      ),
                      hintText: "Search actions...",
                      hintStyle: const TextStyle(color: Color(0xffA6A6A6)),
                      fillColor: const Color(0xffFFFFFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Gap(16.h),
                // Filter chips
                ActionFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                      _searchQuery = '';
                    });
                  },
                ),
                Gap(16.h),
              ],
            ),
          ),
          // Actions list
          Expanded(
            child: actionsAsync.when(
              data: (actions) {
                if (actions.isEmpty) {
                  return EmptyActionsState(
                    message: _searchQuery.isNotEmpty
                        ? 'No actions found for "$_searchQuery"'
                        : _selectedFilter != 'all'
                            ? 'No ${_selectedFilter.replaceAll('_', ' ')} actions'
                            : 'No action items yet',
                    subtitle: _searchQuery.isEmpty && _selectedFilter == 'all'
                        ? 'Action items will appear here when created'
                        : null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(myActionsProvider);
                  },
                  color: const Color(0xff0082DF),
                  backgroundColor: const Color(0xff023C7B),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    itemCount: actions.length,
                    itemBuilder: (context, index) {
                      final action = actions[index];
                      return ActionItemCard(
                        action: action,
                        onTap: () => _handleEdit(action),
                        onDelete: () => _handleDelete(action),
                        onComplete: () => _handleComplete(action),
                      );
                    },
                  ),
                );
              },
              loading: () => const ActionsListSkeleton(),
              error: (error, stack) => Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: Colors.red,
                      ),
                      Gap(16.h),
                      Text(
                        'Error loading actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(8.h),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(24.h),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(myActionsProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0082DF),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
