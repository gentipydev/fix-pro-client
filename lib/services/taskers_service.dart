import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:logger/logger.dart';

class TaskersService {
  Logger logger = Logger();

  final FakeData fakeData = FakeData();

  // Fetch all taskers from FakeData
  Future<List<Tasker>> fetchTaskers() async {
    await Future.delayed(const Duration(seconds: 2));
    return fakeData.fakeTaskers;
  }

  // Fetch favorite taskers from FakeData
  Future<List<Tasker>> fetchFavoriteTaskers() async {
    await Future.delayed(const Duration(seconds: 2));
    return fakeData.fakeTaskers.where((tasker) => tasker.isFavorite).toList();
  }

  // Delete a tasker by ID
  void deleteTasker(String taskerId) {
    fakeData.fakeTaskers.removeWhere((tasker) => tasker.id == taskerId);
  }

  // Update tasker's favorite status
  void updateTaskerFavoriteStatus(String taskerId, bool isFavorite) {
    try {
      Tasker tasker = fakeData.fakeTaskers.firstWhere(
        (tasker) => tasker.id == taskerId,
        orElse: () => throw Exception('Tasker not found'),
      );
      tasker.isFavorite = isFavorite;
    } catch (e) {
      logger.e("Error updating tasker favorite status: $e");
    }
  }
}
