import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/task_group.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/models/user.dart';
import 'package:fit_pro_client/services/tasks_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class TasksProvider with ChangeNotifier {
  Logger logger = Logger();
  final TasksService _tasksService = TasksService();

  List<Task> _currentTasks = [];
  List<Task> _pastTasks = [];

  List<Task> get currentTasks => _currentTasks;
  List<Task> get pastTasks => _pastTasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int get acceptedTaskCount {
    return _currentTasks.where((task) => task.status == TaskStatus.accepted).length;
  }

  TasksProvider() {
    fetchTasks();
  }

  /// Fetch both current and past tasks from the service
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentTasks = await _tasksService.fetchCurrentTasks();
      _pastTasks = await _tasksService.fetchPastTasks();
    } catch (error) {
      logger.e("Failed to fetch tasks: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Remove a task by its ID
  void removeTask(String taskId) {
    _tasksService.deleteTask(taskId);

    // Remove from the current list
    _currentTasks.removeWhere((task) => task.id == taskId);
    
    // Notify listeners about the update
    notifyListeners();
    
    logger.d("Task with id $taskId removed.");
  }

  /// Update the status of a task and refresh task lists
  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    try {
      _tasksService.updateTaskStatus(taskId, newStatus);

      // Refresh tasks after updating status
      fetchTasks();

      logger.d("Task status updated and tasks re-fetched.");
    } catch (e) {
      logger.e("Error updating task status: $e");
    }
  }

  void createTask({
    required User client,
    required Tasker tasker,
    required LatLng userLocation,
    required LatLng taskerLocation,
    required DateTime date,
    required TimeOfDay time,
    required TaskGroup taskWorkGroup,
    TaskStatus status = TaskStatus.accepted,
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
  }) {
    _tasksService.createTask(
      client: client,
      tasker: tasker,
      userLocation: userLocation,
      taskerLocation: taskerLocation,
      date: date,
      time: time,
      taskWorkGroup: taskWorkGroup,
      status: status,
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
    );

    // Re-fetch tasks to reflect the new task
    fetchTasks();

  }
}
