import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:fit_pro_client/services/dio_client.dart'; // For making HTTP requests
import 'package:logger/logger.dart';

class TaskersService {
  Logger logger = Logger();
  final DioClient dioClient = DioClient();
  final FakeData fakeData = FakeData();

  // Fetch all taskers from FakeData (for now)
  Future<List<Tasker>> fetchTaskers() async {
    await Future.delayed(const Duration(seconds: 2));

    // Uncomment the following when the backend is ready
    // try {
    //   final response = await dioClient.dio.get('/taskers');
    //   List data = response.data;
    //   return data.map((tasker) => Tasker.fromJson(tasker)).toList();
    // } catch (e) {
    //   logger.e("Error fetching taskers: $e");
    //   rethrow;
    // }

    return fakeData.fakeTaskers;
  }

  // Fetch favorite taskers from FakeData (for now)
  Future<List<Tasker>> fetchFavoriteTaskers() async {
    await Future.delayed(const Duration(seconds: 2));

    // Uncomment the following when the backend is ready
    // try {
    //   final response = await dioClient.dio.get('/taskers/favorites');
    //   List data = response.data;
    //   return data.map((tasker) => Tasker.fromJson(tasker)).toList();
    // } catch (e) {
    //   logger.e("Error fetching favorite taskers: $e");
    //   rethrow;
    // }

    return fakeData.fakeTaskers.where((tasker) => tasker.isFavorite).toList();
  }

  void deleteTasker(String taskerId) {
    fakeData.fakeTaskers.removeWhere((tasker) => tasker.id == taskerId);
    logger.d("Tasker with ID: $taskerId deleted.");

    // Uncomment the following when the backend is ready
    // try {
    //   await dioClient.dio.delete('/taskers/$taskerId');
    //   logger.d("Tasker with ID: $taskerId successfully deleted from server.");
    // } catch (e) {
    //   logger.e("Error deleting tasker: $e");
    // }
  }

  // Update tasker's favorite status by ID
  void updateTaskerFavoriteStatus(String taskerId, bool isFavorite) {
    try {
      Tasker tasker = fakeData.fakeTaskers.firstWhere(
        (tasker) => tasker.id == taskerId,
        orElse: () => throw Exception('Tasker not found'),
      );
      tasker.isFavorite = isFavorite;
      logger.d("Tasker $taskerId favorite status updated to $isFavorite");

      // Uncomment the following when the backend is ready
      // try {
      //   await dioClient.dio.put('/taskers/$taskerId/favorite', data: {'isFavorite': isFavorite});
      //   logger.d("Tasker $taskerId favorite status successfully updated on server.");
      // } catch (e) {
      //   logger.e("Error updating tasker favorite status: $e");
      // }

    } catch (e) {
      logger.e("Error updating tasker favorite status: $e");
    }
  }
}
