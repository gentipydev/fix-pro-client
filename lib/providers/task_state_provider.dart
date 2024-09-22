import 'package:flutter/foundation.dart';

class TaskStateProvider with ChangeNotifier {
  bool _isAccepted = false;
  bool _showAnimation = false;
  bool _isLocationSelected = false;
  bool _showProfileContainer = false;

  bool get isAccepted => _isAccepted;
  bool get showAnimation => _showAnimation;
  bool get isLocationSelected => _isLocationSelected;
  bool get showProfileContainer => _showProfileContainer;

  void acceptTask() {
    _isAccepted = true;
    notifyListeners();
  }

  void setShowAnimation(bool value) {
    _showAnimation = value;
    notifyListeners();
  }

  void setLocationSelected(bool value) {
    _isLocationSelected = value;
    notifyListeners();
  }

  void setShowProfileContainer(bool value) {
    _showProfileContainer = value;
    notifyListeners();
  }

  void resetTask() {
    _isAccepted = false;
    _showAnimation = false;
    _isLocationSelected = false;
    _showProfileContainer = false;
    notifyListeners();
  }
}
