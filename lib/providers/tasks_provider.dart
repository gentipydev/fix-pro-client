import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/services/tasks_service.dart';
import 'package:flutter/material.dart';
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

  TasksProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentTasks = await _tasksService.fetchCurrentTasks();
      _pastTasks = await _tasksService.fetchPastTasks();
    } catch (error) {
      logger.e(error);
    }

    _isLoading = false;
    notifyListeners();
  }

  void removeTask(String taskId) {
    _tasksService.deleteTask(taskId);
    _currentTasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    try {
      _tasksService.updateTaskStatus(taskId, newStatus);

      // Re-fetch tasks after update to sync with the service
      fetchTasks();

      logger.d("Task status updated and tasks re-fetched.");
    } catch (e) {
      logger.e("Error updating task status: $e");
    }
  }
}
