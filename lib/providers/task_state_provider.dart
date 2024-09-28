import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fit_pro_client/models/task_group.dart';

enum TaskState {
  initial,
  searching,
  profileView,
  accepted,
}

class TaskStateProvider with ChangeNotifier {
  TaskState _taskState = TaskState.initial;
  bool _isLocationSelected = false;
  LatLng? _currentSearchLocation;
  LatLng? _taskerLocation;
  String? _searchedAddress;    
  bool _searchFromCurrentPosition = true;
  TaskGroup? _selectedTaskGroup;

  TaskState get taskState => _taskState;
  bool get isLocationSelected => _isLocationSelected;
  LatLng? get currentSearchLocation => _currentSearchLocation;
  LatLng? get taskerLocation => _taskerLocation;
  String? get searchedAddress => _searchedAddress;
  bool get searchFromCurrentPosition => _searchFromCurrentPosition;
  TaskGroup? get selectedTaskGroup => _selectedTaskGroup;

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

  // Set the search details based on the current search type
  void setSearchDetails({
    required bool fromCurrentPosition,
    LatLng? currentPosition,
    String? address,
  }) {
    _searchFromCurrentPosition = fromCurrentPosition;
    _currentSearchLocation = currentPosition;
    _searchedAddress = address;
    notifyListeners();
  }

  // Set the tasker location
  void setTaskerLocation(LatLng taskerLocation) {
    _taskerLocation = taskerLocation;
    notifyListeners();
  }

  // Set the selected TaskGroup
  void setSelectedTaskGroup(TaskGroup taskGroup) {
    _selectedTaskGroup = taskGroup;
    notifyListeners();
  }

  void resetTask() {
    _taskState = TaskState.initial;
    _isLocationSelected = false;
    _currentSearchLocation = null;
    _taskerLocation = null;
    _searchedAddress = null;
    _searchFromCurrentPosition = true;
    _selectedTaskGroup = null;
    notifyListeners();
  }

  void rejectTask() {
    _taskState = TaskState.initial;
    _isLocationSelected = false;
    notifyListeners();
  }
}
