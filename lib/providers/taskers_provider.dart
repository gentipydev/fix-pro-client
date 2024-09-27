import 'package:flutter/material.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/services/taskers_service.dart';
import 'package:logger/logger.dart';

class TaskersProvider with ChangeNotifier {
  Logger logger = Logger();
  final TaskersService _taskersService = TaskersService();

  List<Tasker> _favoriteTaskers = [];
  List<Tasker> _pastTaskers = [];

  List<Tasker> get favoriteTaskers => _favoriteTaskers;
  List<Tasker> get pastTaskers => _pastTaskers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TaskersProvider() {
    fetchTaskers();
  }

  // Fetch taskers and separate into favorites and past
  Future<void> fetchTaskers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pastTaskers = await _taskersService.fetchTaskers();
      _favoriteTaskers = await _taskersService.fetchFavoriteTaskers();
    } catch (error) {
      logger.e(error);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update favorite status of a tasker
  void updateTaskerFavoriteStatus(String taskerId, bool isFavorite) {
    try {
      _taskersService.updateTaskerFavoriteStatus(taskerId, isFavorite);

      // Re-fetch the taskers to update the lists
      fetchTaskers();

      logger.d("Tasker favorite status updated and lists re-fetched.");
    } catch (e) {
      logger.e("Error updating tasker favorite status: $e");
    }
  }

  // Remove tasker from favorites but keep in the past taskers list
  void removeTaskerFromFavorites(Tasker tasker) {
    try {
      // Update the tasker's favorite status in the service
      _taskersService.updateTaskerFavoriteStatus(tasker.id, false);

      // Remove tasker from the favoriteTaskers list
      _favoriteTaskers.removeWhere((favTasker) => favTasker.id == tasker.id);

      // Ensure the tasker remains in pastTaskers list
      int index = _pastTaskers.indexWhere((pastTasker) => pastTasker.id == tasker.id);
      if (index != -1) {
        _pastTaskers[index].isFavorite = false;
      }

      notifyListeners();

      logger.d("Tasker removed from favorites.");
    } catch (e) {
      logger.e("Error removing tasker from favorites: $e");
    }
  }

  // Remove a tasker from the tasker list entirely
  void removeTasker(String taskerId) {
    _taskersService.deleteTasker(taskerId);
    _pastTaskers.removeWhere((tasker) => tasker.id == taskerId);
    _favoriteTaskers.removeWhere((tasker) => tasker.id == taskerId);
    notifyListeners();
  }
}
