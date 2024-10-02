import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/task_group.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/models/user.dart';
import 'package:fit_pro_client/services/tasks_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TasksState {
  final List<Task> currentTasks;
  final List<Task> pastTasks;
  final bool isLoading;
  final String? errorMessage;
  final int acceptedTaskCount;

  TasksState({
    required this.currentTasks,
    required this.pastTasks,
    required this.isLoading,
    this.errorMessage,
    required this.acceptedTaskCount,
  });

  factory TasksState.initial() {
    return TasksState(
      currentTasks: [],
      pastTasks: [],
      isLoading: false,
      errorMessage: null,
      acceptedTaskCount: 0,
    );
  }
}

class TasksNotifier extends StateNotifier<TasksState> {
  final TasksService _tasksService;

  TasksNotifier(this._tasksService) : super(TasksState.initial());

  // Fetch tasks from service
  Future<void> fetchTasks() async {
    state = TasksState(
      currentTasks: state.currentTasks,
      pastTasks: state.pastTasks,
      isLoading: true,
      acceptedTaskCount: state.acceptedTaskCount, // Keep the counter
    );

    try {
      final currentTasks = await _tasksService.fetchCurrentTasks();
      final pastTasks = await _tasksService.fetchPastTasks();

      // Count accepted tasks
      final acceptedTasks = currentTasks.where((task) => task.status == TaskStatus.accepted).length;

      state = TasksState(
        currentTasks: currentTasks,
        pastTasks: pastTasks,
        isLoading: false,
        acceptedTaskCount: acceptedTasks, // Set the counter with the new accepted task count
      );
    } catch (e) {
      state = TasksState(
        currentTasks: [],
        pastTasks: [],
        isLoading: false,
        errorMessage: 'Failed to load tasks',
        acceptedTaskCount: state.acceptedTaskCount, // Keep the previous count
      );
    }
  }

  Task createTask({
    required User client,
    required Tasker tasker,
    required LatLng userLocation,
    required LatLng taskerLocation,
    required DateTime date,
    required TimeOfDay time,
    required TaskGroup taskWorkGroup,
    String? taskerArea,
    String? taskPlaceDistance,
    String? userArea,
    List<String>? taskTools,
    String? paymentMethod,
    String? promoCode,
    String? taskFullAddress,
    String? taskDetails,
    String? taskEvaluation,
    String? taskExtraDetails,
    TaskStatus status = TaskStatus.accepted,
  }) {
    final newTask = _tasksService.createTask(
      client: client,
      tasker: tasker,
      userLocation: userLocation,
      taskerLocation: taskerLocation,
      date: date,
      time: time,
      taskWorkGroup: taskWorkGroup,
      taskerArea: taskerArea,
      taskPlaceDistance: taskPlaceDistance,
      userArea: userArea,
      taskTools: taskTools,
      paymentMethod: paymentMethod,
      promoCode: promoCode,
      taskFullAddress: taskFullAddress,
      taskDetails: taskDetails,
      taskEvaluation: taskEvaluation,
      taskExtraDetails: taskExtraDetails,
      status: status,
    );

    // Increment accepted task count if the task is accepted
    final updatedAcceptedTaskCount = (status == TaskStatus.accepted)
        ? state.acceptedTaskCount + 1
        : state.acceptedTaskCount;

    state = TasksState(
      currentTasks: [...state.currentTasks, newTask],
      pastTasks: state.pastTasks,
      isLoading: false,
      acceptedTaskCount: updatedAcceptedTaskCount,
    );

    return newTask;
  }
}

// Provider for TasksNotifier
final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(TasksService()),
);
