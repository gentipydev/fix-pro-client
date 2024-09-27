import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class TasksService {
  Logger logger = Logger();

  final FakeData fakeData = FakeData();

  // Get the current tasks data from FakeData
  List<Task> get _currentTasksData => [
        Task(
          id: "1",
          client: fakeData.fakeUser,
          tasker: fakeData.fakeTaskers[0],
          userLocation: const LatLng(41.3275, 19.8189),
          taskerLocation: const LatLng(41.3317, 19.8345),
          polylineCoordinates: [
            const LatLng(41.3275, 19.8189),
            const LatLng(41.3317, 19.8345),
          ],
          bounds: LatLngBounds(
            southwest: const LatLng(41.3275, 19.8189),
            northeast: const LatLng(41.3317, 19.8345),
          ),
          taskWorkGroup: fakeData.fakeTaskGroups[0], // Get task group from FakeData
          date: DateTime.parse("2024-10-27"),
          time: const TimeOfDay(hour: 11, minute: 0),
          taskArea: "Rrethrrotullimi i Farkës, Tiranë",
          taskPlaceDistance: 2.7,
          userArea: "Tirane",
          taskTools: ["Hammer", "Screwdriver"],
          paymentMethod: "Cash",
          promoCode: "PROMO2024",
          taskFullAddress: "Tiranë, Rruga George W Bush, Pallati 94107, Hyrja 2",
          taskDetails: "Kam tre tavolina që duhet të montohen",
          taskEvaluation: "Mesatare - Vlerësuar 2-3 orë",
          taskExtraDetails: "Profesionisti duhet të sjellë veglat e veta",
          status: TaskStatus.actual,
        ),
      ];

  // Get the past tasks data from FakeData
  List<Task> get _pastTasksData => [
        Task(
          id: "2",
          client: fakeData.fakeUser,
          tasker: fakeData.fakeTaskers[1],
          userLocation: const LatLng(41.3275, 19.8189),
          taskerLocation: const LatLng(41.3317, 19.8345),
          polylineCoordinates: [
            const LatLng(41.3275, 19.8189),
            const LatLng(41.3317, 19.8345),
          ],
          bounds: LatLngBounds(
            southwest: const LatLng(41.3275, 19.8189),
            northeast: const LatLng(41.3317, 19.8345),
          ),
          taskWorkGroup: fakeData.fakeTaskGroups[1],
          date: DateTime.parse("2024-05-28"),
          time: const TimeOfDay(hour: 16, minute: 0),
          taskArea: "Lagjja Nr.1, Tirane",
          taskPlaceDistance: 1.5,
          userArea: "Durres",
          taskTools: ["Wrench", "Pliers"],
          paymentMethod: "Credit Card",
          promoCode: null,
          taskFullAddress: "Durres, Lagjja Nr.1, Pallati 12, Hyrja 3",
          taskDetails: "Zëvendësimi i rubinetave të vjetra me të reja",
          taskEvaluation: "Shpejtë - Vlerësuar 1-2 orë",
          taskExtraDetails: "Veglat e duhura për rubinetë",
          status: TaskStatus.past,
        ),
        Task(
          id: "3",
          client: fakeData.fakeUser,
          tasker: fakeData.fakeTaskers[2],
          userLocation: const LatLng(41.3275, 19.8189),
          taskerLocation: const LatLng(41.3317, 19.8345),
          polylineCoordinates: [
            const LatLng(41.3275, 19.8189),
            const LatLng(41.3317, 19.8345),
          ],
          bounds: LatLngBounds(
            southwest: const LatLng(41.3275, 19.8189),
            northeast: const LatLng(41.3317, 19.8345),
          ),
          taskWorkGroup: fakeData.fakeTaskGroups[6],
          date: DateTime.parse("2024-06-06"),
          time: const TimeOfDay(hour: 13, minute: 0),
          taskArea: "Fresk, Tirane",
          taskPlaceDistance: 0.8,
          userArea: "Tirane",
          taskTools: ["Shower installation tools"],
          paymentMethod: "Cash",
          promoCode: "SHOWER123",
          taskFullAddress: "Vlore, Rruga Ismail Qemali, Ndërtesa 5, Apartamenti 8",
          taskDetails: "Instalimi i kabinës së dushit me të gjitha aksesorët",
          taskEvaluation: "Normale - Vlerësuar 2-3 orë",
          taskExtraDetails: "Profesionisti duhet të sjellë veglat e veta",
          status: TaskStatus.past,
        ),
        Task(
          id: "4",
          client: fakeData.fakeUser,
          tasker: fakeData.fakeTaskers[3],
          userLocation: const LatLng(41.3275, 19.8189),
          taskerLocation: const LatLng(41.3317, 19.8345),
          polylineCoordinates: [
            const LatLng(41.3275, 19.8189),
            const LatLng(41.3317, 19.8345),
          ],
          bounds: LatLngBounds(
            southwest: const LatLng(41.3275, 19.8189),
            northeast: const LatLng(41.3317, 19.8345),
          ),
          taskWorkGroup: fakeData.fakeTaskGroups[10],
          date: DateTime.parse("2024-06-07"),
          time: const TimeOfDay(hour: 14, minute: 0),
          taskArea: "Rruga George W Bush, Tirane",
          taskPlaceDistance: 3.2,
          userArea: "Tirane",
          taskTools: ["Air conditioning tools"],
          paymentMethod: "Cash",
          promoCode: null,
          taskFullAddress: "Tirane, Rruga George W Bush, Ndërtesa 10, Apartamenti 12",
          taskDetails: "Instalimi i kondicionerit dhe lidhja me sistemin elektrik",
          taskEvaluation: "E gjatë - Vlerësuar 3-4 orë",
          taskExtraDetails: "Profesionisti duhet të sjellë veglat e veta",
          status: TaskStatus.past,
        ),
      ];

  // Fetch the current tasks with a delay to simulate network call
  Future<List<Task>> fetchCurrentTasks() async {
    await Future.delayed(const Duration(seconds: 2));
    return _currentTasksData;
  }

  // Fetch the past tasks with a delay to simulate network call
  Future<List<Task>> fetchPastTasks() async {
    await Future.delayed(const Duration(seconds: 2));
    return _pastTasksData;
  }

  // Delete a task by ID
  void deleteTask(String taskId) {
    _currentTasksData.removeWhere((task) => task.id == taskId);
  }

  // Move a task to the correct list based on its status
  void _moveTaskToCorrectList(Task task, TaskStatus status) {
    if (status == TaskStatus.actual) {
      _currentTasksData.add(task);
    } else if (status == TaskStatus.past) {
      _pastTasksData.add(task);
    }
  }

  // Update a task's status and move it to the correct list
  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    try {
      Task task = _currentTasksData.firstWhere(
        (task) => task.id == taskId,
        orElse: () => throw Exception('Task not found in current tasks'),
      );

      _currentTasksData.remove(task);
      task.status = newStatus;
      _moveTaskToCorrectList(task, newStatus);
      return;
    } catch (e) {
      logger.e("Task not found: $e");
    }
  }
}
