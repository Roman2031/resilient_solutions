import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../providers/notes_providers.dart';
import '../widgets/note_card.dart';
import '../widgets/notes_list_skeleton.dart';
import '../widgets/empty_notes_state.dart';
import '../widgets/note_search_bar.dart';
import '../widgets/edit_note_dialog.dart';
import '../../call_service/data/models/call_service_models.dart';

class AllNotesScreen extends ConsumerStatefulWidget {
  const AllNotesScreen({super.key});

  @override
  ConsumerState<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends ConsumerState<AllNotesScreen> {
  String _searchQuery = '';

  Future<void> _handleDelete(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff023C7B),
        title: const Text(
          'Delete Note',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this note?',
          style: TextStyle(color: Colors.white70),
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
            .read(noteActionsProvider.notifier)
            .deleteNote(note.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note deleted'),
              backgroundColor: Color(0xff4CAF50),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting note: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleEdit(Note note) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditNoteDialog(note: note),
    );

    if (result != null) {
      try {
        await ref.read(noteActionsProvider.notifier).updateNote(
              noteId: note.id,
              content: result['content'],
              isPrivate: result['isPrivate'],
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note updated'),
              backgroundColor: Color(0xff4CAF50),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating note: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = _searchQuery.isNotEmpty
        ? ref.watch(searchNotesProvider(_searchQuery))
        : ref.watch(allNotesProvider);

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
                    "NOTES",
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
                  child: NoteSearchBar(
                    onSearchChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                  ),
                ),
                Gap(20.h),
              ],
            ),
          ),
          // Notes list
          Expanded(
            child: notesAsync.when(
              data: (notes) {
                if (notes.isEmpty) {
                  return EmptyNotesState(
                    message: _searchQuery.isNotEmpty
                        ? 'No notes found for "$_searchQuery"'
                        : 'No notes yet',
                    subtitle: _searchQuery.isEmpty
                        ? 'Notes from your call circles will appear here'
                        : null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(allNotesProvider);
                  },
                  color: const Color(0xff0082DF),
                  backgroundColor: const Color(0xff023C7B),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteCard(
                        note: note,
                        onEdit: () => _handleEdit(note),
                        onDelete: () => _handleDelete(note),
                      );
                    },
                  ),
                );
              },
              loading: () => const NotesListSkeleton(),
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
                        'Error loading notes',
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
                        onPressed: () => ref.invalidate(allNotesProvider),
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
