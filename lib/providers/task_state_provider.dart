import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  String? _searchedAddress;    
  bool _searchFromCurrentPosition = true;

  TaskState get taskState => _taskState;
  bool get isLocationSelected => _isLocationSelected;
  LatLng? get currentSearchLocation => _currentSearchLocation;
  String? get searchedAddress => _searchedAddress;
  bool get searchFromCurrentPosition => _searchFromCurrentPosition;

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

  // Reset task to initial state
  void resetTask() {
    _taskState = TaskState.initial;
    _isLocationSelected = false;
    notifyListeners();
  }
}
