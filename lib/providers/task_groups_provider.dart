import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_pro_client/models/task_group.dart';
import 'package:fit_pro_client/services/task_groups_service.dart';

// Define the state class that holds task groups data
class TaskGroupsState {
  final List<TaskGroup> taskGroups;
  final bool isLoading;
  final String? errorMessage;

  TaskGroupsState({
    required this.taskGroups,
    required this.isLoading,
    this.errorMessage,
  });

  // Initial state with no data and loading false
  TaskGroupsState.initial()
      : taskGroups = [],
        isLoading = false,
        errorMessage = null;
}

// StateNotifier to handle the logic
class TaskGroupsNotifier extends StateNotifier<TaskGroupsState> {
  final TaskGroupsService _taskGroupsService;

  TaskGroupsNotifier(this._taskGroupsService) : super(TaskGroupsState.initial());

  // Fetch task groups from the service
  Future<void> loadTaskGroups() async {
    state = TaskGroupsState(
      taskGroups: state.taskGroups,
      isLoading: true,
      errorMessage: null,
    );

    try {
      final taskGroups = await _taskGroupsService.fetchTaskGroups();
      state = TaskGroupsState(
        taskGroups: taskGroups,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = TaskGroupsState(
        taskGroups: [],
        isLoading: false,
        errorMessage: 'Failed to load task groups',
      );
    }
  }
}

// Provider for TaskGroupsNotifier
final taskGroupsProvider = StateNotifierProvider<TaskGroupsNotifier, TaskGroupsState>(
  (ref) => TaskGroupsNotifier(TaskGroupsService()),
);
