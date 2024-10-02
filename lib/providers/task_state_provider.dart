import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fit_pro_client/models/task_group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskState {
  initial,
  searching,
  profileView,
  accepted,
}

class TaskStateData {
  final TaskState taskState;
  final bool isLocationSelected;
  final LatLng? currentSearchLocation;
  final LatLng? taskerLocation;
  final String? searchedAddress;
  final bool searchFromCurrentPosition;
  final TaskGroup? selectedTaskGroup;
  final int currentTaskerIndex;

  TaskStateData({
    required this.taskState,
    required this.isLocationSelected,
    required this.currentSearchLocation,
    required this.taskerLocation,
    required this.searchedAddress,
    required this.searchFromCurrentPosition,
    required this.selectedTaskGroup,
    required this.currentTaskerIndex,
  });

  // Factory to return initial state
  factory TaskStateData.initial() {
    return TaskStateData(
      taskState: TaskState.initial,
      isLocationSelected: false,
      currentSearchLocation: null,
      taskerLocation: null,
      searchedAddress: null,
      searchFromCurrentPosition: true,
      selectedTaskGroup: null,
      currentTaskerIndex: 0,
    );
  }

  // Copy with method to update state immutably
  TaskStateData copyWith({
    TaskState? taskState,
    bool? isLocationSelected,
    LatLng? currentSearchLocation,
    LatLng? taskerLocation,
    String? searchedAddress,
    bool? searchFromCurrentPosition,
    TaskGroup? selectedTaskGroup,
    int? currentTaskerIndex,
  }) {
    return TaskStateData(
      taskState: taskState ?? this.taskState,
      isLocationSelected: isLocationSelected ?? this.isLocationSelected,
      currentSearchLocation: currentSearchLocation ?? this.currentSearchLocation,
      taskerLocation: taskerLocation ?? this.taskerLocation,
      searchedAddress: searchedAddress ?? this.searchedAddress,
      searchFromCurrentPosition: searchFromCurrentPosition ?? this.searchFromCurrentPosition,
      selectedTaskGroup: selectedTaskGroup ?? this.selectedTaskGroup,
      currentTaskerIndex: currentTaskerIndex ?? this.currentTaskerIndex,
    );
  }
}


class TaskStateNotifier extends StateNotifier<TaskStateData> {
  TaskStateNotifier() : super(TaskStateData.initial());

  // Reset the tasker index
  void resetTaskerIndex() {
    state = state.copyWith(currentTaskerIndex: 0);
  }

  // Increment tasker index and wrap around using modulo
  void incrementTaskerIndex(int maxIndex) {
    final newIndex = (state.currentTaskerIndex + 1) % maxIndex;
    state = state.copyWith(currentTaskerIndex: newIndex);
  }

  // Update task state
  void setTaskState(TaskState taskState) {
    state = state.copyWith(taskState: taskState);
  }

  // Update location selection
  void setLocationSelected(bool value) {
    state = state.copyWith(isLocationSelected: value);
  }

  // Update search details
  void setSearchDetails({
    required bool fromCurrentPosition,
    LatLng? currentPosition,
    String? address,
  }) {
    state = state.copyWith(
      searchFromCurrentPosition: fromCurrentPosition,
      currentSearchLocation: currentPosition,
      searchedAddress: address,
    );
  }

  // Set tasker location
  void setTaskerLocation(LatLng taskerLocation) {
    state = state.copyWith(taskerLocation: taskerLocation);
  }

  // Set selected TaskGroup
  void setSelectedTaskGroup(TaskGroup taskGroup) {
    state = state.copyWith(selectedTaskGroup: taskGroup);
  }

  // Reset task state to initial
  void resetTask() {
    state = TaskStateData.initial();
  }

  // Reject task and reset the state
  void rejectTask() {
    state = state.copyWith(
      taskState: TaskState.initial,
      isLocationSelected: false,
    );
  }
}

final taskStateProvider = StateNotifierProvider<TaskStateNotifier, TaskStateData>(
  (ref) => TaskStateNotifier(),
);


