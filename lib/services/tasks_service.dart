import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/models/task_group.dart';
import 'package:logger/logger.dart';

class TasksService {
  Logger logger = Logger();

  final List<Task> _currentTasksData = [
    Task(
      id: "1",
      title: "Montim Tavoline",
      date: DateTime.parse("2024-08-27"),
      time: "11:00 am",
      location: "Tirane",
      clientName: "Arben Gashi",
      clientImage: "assets/images/client3.png",
      status: TaskStatus.actual,
      clientPhoneNumber: "+355696443833",
      taskArea: "Rrethrrotullimi i Farkës, Tiranë",
      taskPlaceDistance: 2.7,
      taskWorkGroup: TaskGroup(
        id: '4',
        title: "Montim Mobiliesh",
        description: "Montim mobiliesh te ndryshme",
        feePerHour: 2000,
        isActive: false,
      ),
      taskDetails: "Kam tre tavolina që duhet të montohen",
      taskTimeEvaluation: "Mesatare - Vlerësuar 2-3 orë (p.sh. për montimin e nje set-i mobiliesh)",
      taskTools: "Profesionisti duhet të sjellë veglat e veta",
      taskFullAddress: "Tiranë, Rruga George W Bush, Pallati 94107, Hyrja 2",
    ),
  ];

  final List<Task> _pastTasksData = [
    Task(
      id: "2",
      title: "Ndryshim Rubinetash",
      date: DateTime.parse("2024-05-28"),
      time: "4:00 pm",
      location: "Durres",
      clientName: "Besim B.",
      clientImage: "assets/images/client3.png",
      status: TaskStatus.past,
      clientPhoneNumber: "+355692223344",
      taskArea: "Lagjja Nr.1, Durres",
      taskPlaceDistance: 1.5,
      taskWorkGroup: TaskGroup(
        id: '5',
        title: "Ndryshim Rubinetash",
        description: "Zëvendësim rubinetash të banjos dhe kuzhinës",
        feePerHour: 1500,
        isActive: false,
      ),
      taskDetails: "Zëvendësimi i rubinetave të vjetra me të reja",
      taskTimeEvaluation: "Shpejtë - Vlerësuar 1-2 orë",
      taskTools: "Veglat e duhura për rubinetë",
      taskFullAddress: "Durres, Lagjja Nr.1, Pallati 12, Hyrja 3",
    ),
    Task(
      id: "3",
      title: "Instalim Dushi",
      date: DateTime.parse("2024-06-06"),
      time: "1:00 pm",
      location: "Vlore",
      clientName: "Eva L.",
      clientImage: "assets/images/client4.png",
      status: TaskStatus.past,
      clientPhoneNumber: "+355693334455",
      taskArea: "Skela, Vlore",
      taskPlaceDistance: 0.8,
      taskWorkGroup: TaskGroup(
        id: '6',
        title: "Instalim Paj. Sanitare",
        description: "Instalim i dushit dhe pajisjeve të tjera sanitare",
        feePerHour: 2200,
        isActive: false,
      ),
      taskDetails: "Instalimi i kabinës së dushit me të gjitha aksesorët",
      taskTimeEvaluation: "Normale - Vlerësuar 2-3 orë",
      taskTools: "Vegla montimi për kabinën e dushit",
      taskFullAddress: "Vlore, Rruga Ismail Qemali, Ndërtesa 5, Apartamenti 8",
    ),
    Task(
      id: "4",
      title: "Instalim Kondicioneri",
      date: DateTime.parse("2024-06-07"),
      time: "2:00 pm",
      location: "Korce",
      clientName: "Altin R.",
      clientImage: "assets/images/client6.png",
      status: TaskStatus.past,
      clientPhoneNumber: "+355694445566",
      taskArea: "Rruga e Çlirimit, Korce",
      taskPlaceDistance: 3.2,
      taskWorkGroup: TaskGroup(
        id: '7',
        title: "Instalim Paj. Elektrike",
        description: "Instalim dhe konfigurim i kondicionerit",
        feePerHour: 2500,
        isActive: false,
      ),
      taskDetails: "Instalimi i kondicionerit dhe lidhja me sistemin elektrik",
      taskTimeEvaluation: "E gjatë - Vlerësuar 3-4 orë",
      taskTools: "Vegla dhe pajisje për instalimin e kondicionerit",
      taskFullAddress: "Korce, Rruga e Çlirimit, Ndërtesa 10, Apartamenti 12",
    ),
  ];



  Future<List<Task>> fetchCurrentTasks() async {
    await Future.delayed(const Duration(seconds: 2));
    return _currentTasksData;
  }

  Future<List<Task>> fetchPastTasks() async {
    await Future.delayed(const Duration(seconds: 2));
    return _pastTasksData;
  }

  void deleteTask(String taskId) {
    _currentTasksData.removeWhere((task) => task.id == taskId);
  }

  void _moveTaskToCorrectList(Task task, TaskStatus status) {
  if (status == TaskStatus.actual) {
      _currentTasksData.add(task);
    } else if (status == TaskStatus.past) {
      _pastTasksData.add(task);
    }
  }

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
      // Handle the case where the task was not found in current tasks
    }
  }
}

