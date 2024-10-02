import 'package:fit_pro_client/models/tasker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_pro_client/services/taskers_service.dart';

class TaskersState {
  final List<Tasker> favoriteTaskers;
  final List<Tasker> allTaskers;
  final bool isLoading;
  final String? errorMessage;

  TaskersState({
    required this.favoriteTaskers,
    required this.allTaskers,
    required this.isLoading,
    this.errorMessage,
  });

  factory TaskersState.initial() {
    return TaskersState(
      favoriteTaskers: [],
      allTaskers: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  TaskersState copyWith({
    List<Tasker>? favoriteTaskers,
    List<Tasker>? allTaskers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskersState(
      favoriteTaskers: favoriteTaskers ?? this.favoriteTaskers,
      allTaskers: allTaskers ?? this.allTaskers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


class TaskersNotifier extends StateNotifier<TaskersState> {
  final TaskersService _taskersService;

  TaskersNotifier(this._taskersService) : super(TaskersState.initial());

  // Fetch taskers from the service
  Future<void> fetchTaskers() async {
    state = state.copyWith(isLoading: true);

    try {
      final allTaskers = await _taskersService.fetchTaskers();
      final favoriteTaskers = await _taskersService.fetchFavoriteTaskers();

      // Use copyWith to update the state
      state = state.copyWith(
        allTaskers: allTaskers,
        favoriteTaskers: favoriteTaskers,
        isLoading: false,
        errorMessage: null, // Clear any previous errors
      );
    } catch (e) {
      // Set the errorMessage and set isLoading to false
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch taskers: $e',
      );
    }
  }

  // Update tasker's favorite status
  void updateTaskerFavoriteStatus(String taskerId, bool isFavorite) async {
    try {
      _taskersService.updateTaskerFavoriteStatus(taskerId, isFavorite);
      
      await fetchTaskers();  // Re-fetch taskers to reflect the updated favorite status
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update tasker favorite status: $e',
      );
    }
  }

  // Delete a tasker by ID
  void deleteTasker(String taskerId) async {
    try {
      _taskersService.deleteTasker(taskerId);
      
      // Re-fetch taskers to reflect the deletion
      await fetchTaskers();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete tasker: $e',
      );
    }
  }
}

final taskersProvider = StateNotifierProvider<TaskersNotifier, TaskersState>(
  (ref) => TaskersNotifier(TaskersService()),
);
