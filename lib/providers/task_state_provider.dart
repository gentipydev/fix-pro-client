import 'package:flutter/foundation.dart';

enum TaskState {
  initial,
  searching,
  profileView,
  accepted,
}

class TaskStateProvider with ChangeNotifier {
  TaskState _taskState = TaskState.initial;
  bool _isLocationSelected = false;

  TaskState get taskState => _taskState;
  bool get isLocationSelected => _isLocationSelected;

  // Set the task state based on user actions
  void setTaskState(TaskState state) {
    _taskState = state;
    notifyListeners();
  }

  // Set location selection
  void setLocationSelected(bool value) {
    _isLocationSelected = value;
    notifyListeners();
  }

  // Reset task to initial state
  void resetTask() {
    _taskState = TaskState.initial;
    _isLocationSelected = false;
    notifyListeners();
  }
}
