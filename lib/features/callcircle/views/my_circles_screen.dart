import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../common/widgets/empty_state.dart';
import '../../common/widgets/error_view.dart';
import '../providers/circles_provider.dart';
import '../widgets/circle_card.dart';

class MyCirclesScreen extends ConsumerStatefulWidget {
  const MyCirclesScreen({super.key});

  @override
  ConsumerState<MyCirclesScreen> createState() => _MyCirclesScreenState();
}

class _MyCirclesScreenState extends ConsumerState<MyCirclesScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circlesAsync = ref.watch(myCirclesProvider);

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('My Circles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create circle
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Gap(16.h),
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search circles...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xff023C7B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Gap(16.h),
          // Circles list
          Expanded(
            child: circlesAsync.when(
              data: (circles) {
                var filteredCircles = circles;
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  filteredCircles = circles
                      .where((c) =>
                          c.name.toLowerCase().contains(query) ||
                          c.description.toLowerCase().contains(query))
                      .toList();
                }

                if (filteredCircles.isEmpty) {
                  return EmptyState(
                    title: _searchQuery.isNotEmpty
                        ? 'No Results Found'
                        : 'No Circles Yet',
                    message: _searchQuery.isNotEmpty
                        ? 'Try adjusting your search'
                        : 'Join or create a circle to get started',
                    icon: Icons.group_outlined,
                    actionText: _searchQuery.isEmpty ? 'Create Circle' : null,
                    onAction: _searchQuery.isEmpty
                        ? () {
                            // TODO: Navigate to create circle
                          }
                        : null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.refresh(myCirclesProvider.future);
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: filteredCircles.length,
                    separatorBuilder: (_, __) => Gap(12.h),
                    itemBuilder: (context, index) {
                      final circle = filteredCircles[index];
                      return CircleCard(
                        circle: circle,
                        onTap: () {
                          // TODO: Navigate to circle details
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              error: (error, stack) => ErrorView(
                error: error,
                onRetry: () => ref.invalidate(myCirclesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
