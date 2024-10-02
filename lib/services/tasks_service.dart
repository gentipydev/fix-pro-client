import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/task_group.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/models/user.dart';
import 'package:fit_pro_client/services/dio_client.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class TasksService {
  Logger logger = Logger();
  final DioClient dioClient = DioClient(); 
  final FakeData fakeData = FakeData();

  // Get the current tasks data from FakeData
  List<Task> currentTasksData = [];

  // Get the past tasks data from FakeData
  List<Task> get _pastTasksData => fakeData.fakeTasks;

  // Fetch the current tasks with a delay to simulate network call
  Future<List<Task>> fetchCurrentTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Uncomment the following when your backend is ready
    // try {
    //   final response = await dioClient.dio.get('/tasks/current');
    //   List data = response.data;
    //   return data.map((task) => Task.fromJson(task)).toList();
    // } catch (e) {
    //   logger.e("Error fetching current tasks: $e");
    //   rethrow;
    // }

    return currentTasksData;
  }

  // Fetch the past tasks with a delay to simulate network call
  Future<List<Task>> fetchPastTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Uncomment the following when your backend is ready
    // try {
    //   final response = await dioClient.dio.get('/tasks/past');
    //   List data = response.data;
    //   return data.map((task) => Task.fromJson(task)).toList();
    // } catch (e) {
    //   logger.e("Error fetching past tasks: $e");
    //   rethrow;
    // }

    return _pastTasksData;
  }

  Task createTask({
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
    Task newTask = Task(
      client: client,
      tasker: tasker,
      userLocation: userLocation,
      taskerLocation: taskerLocation,
      polylineCoordinates: [],
      bounds: null,
      taskWorkGroup: taskWorkGroup,
      date: date,
      time: time,
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

    currentTasksData.add(newTask);
    logger.d("Task created: $newTask");

    // Uncomment the following when your backend is ready
    // try {
    //   final response = await dioClient.dio.post('/tasks', data: newTask.toJson());
    //   final createdTask = Task.fromJson(response.data);
    //   currentTasksData.add(createdTask);
    //   logger.d("Task successfully created on the server: $createdTask");
    // } catch (e) {
    //   logger.e("Error creating task on the server: $e");
    // }

    return newTask;
  }

  // Delete task by ID
  void deleteTask(String taskId) {
    currentTasksData.removeWhere((task) => task.id == taskId);
    logger.d("Task with ID: $taskId deleted.");

    // Uncomment the following when your backend is ready
    // try {
    //   await dioClient.dio.delete('/tasks/$taskId');
    //   logger.d("Task successfully deleted from the server");
    // } catch (e) {
    //   logger.e("Error deleting task from the server: $e");
    // }
  }

  // Update task status by task ID
  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    try {
      Task task = currentTasksData.firstWhere((task) => task.id == taskId);
      task.status = newStatus;
      logger.d("Task $taskId status updated to $newStatus");

      // Uncomment the following when your backend is ready
      // try {
      //   await dioClient.dio.put('/tasks/$taskId/status', data: {'status': newStatus.toString()});
      //   logger.d("Task status successfully updated on the server");
      // } catch (e) {
      //   logger.e("Error updating task status on the server: $e");
      // }

    } catch (e) {
      logger.e("Error updating task: $e");
    }
  }
}
