import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';

part 'notes_providers.g.dart';

/// Provider for all notes across all calls
/// Aggregates notes from all circles the user is a member of
@riverpod
Future<List<Note>> allNotes(AllNotesRef ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  
  // Get all circles
  final circles = await repository.getCircles();
  
  // Get calls for each circle, then notes for each call
  final List<Note> allNotes = [];
  for (final circle in circles) {
    try {
      final calls = await repository.getCircleCalls(circle.id);
      for (final call in calls) {
        try {
          final notes = await repository.getCallNotes(call.id);
          allNotes.addAll(notes);
        } catch (e) {
          print('Failed to fetch notes for call ${call.id}: $e');
        }
      }
    } catch (e) {
      print('Failed to fetch calls for circle ${circle.id}: $e');
    }
  }
  
  // Sort by creation date (newest first)
  allNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  
  return allNotes;
}

/// Notifier for note operations (CRUD)
@riverpod
class NoteActionsNotifier extends _$NoteActionsNotifier {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Create a new note
  Future<Note> createNote({
    required int callId,
    required String content,
    bool isPrivate = false,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      final newNote = await repository.createNote(
        callId: callId,
        content: content,
        isPrivate: isPrivate,
      );

      // Invalidate notes providers to refetch
      ref.invalidate(allNotesProvider);

      return newNote;
    }).then((result) {
      state = result;
      return result.when(
        data: (note) => note as Note,
        loading: () => throw Exception('Note creation in progress'),
        error: (error, stack) => throw error,
      );
    });
  }

  /// Update an existing note
  Future<Note> updateNote({
    required int noteId,
    required String content,
    bool? isPrivate,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      final updatedNote = await repository.updateNote(
        noteId: noteId,
        content: content,
        isPrivate: isPrivate,
      );

      // Invalidate notes providers to refetch
      ref.invalidate(allNotesProvider);

      return updatedNote;
    }).then((result) {
      state = result;
      return result.when(
        data: (note) => note as Note,
        loading: () => throw Exception('Note update in progress'),
        error: (error, stack) => throw error,
      );
    });
  }

  /// Delete a note
  Future<void> deleteNote(int noteId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      await repository.deleteNote(noteId);

      // Invalidate notes providers to refetch
      ref.invalidate(allNotesProvider);
    });
  }
}

/// Provider for notes by call ID
@riverpod
Future<List<Note>> notesByCall(NotesByCallRef ref, int callId) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getCallNotes(callId);
}

/// Provider for searching notes
/// Caches all notes to avoid unnecessary API calls during search
@riverpod
Future<List<Note>> searchNotes(SearchNotesRef ref, String query) async {
  // Watch the base notes provider to get cached data
  final allNotes = await ref.watch(allNotesProvider.future);
  
  if (query.isEmpty) {
    return allNotes;
  }
  
  // Perform search on cached data
  final lowerQuery = query.toLowerCase();
  return allNotes.where((note) {
    return note.content.toLowerCase().contains(lowerQuery);
  }).toList();
}
