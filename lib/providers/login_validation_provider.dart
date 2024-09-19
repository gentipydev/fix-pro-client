import 'package:flutter/material.dart';

class LoginValidationProvider with ChangeNotifier {
  bool _emailValid = false;
  bool _passwordValid = false;

  bool get isEmailValid => _emailValid;
  bool get isPasswordValid => _passwordValid;

  void updateEmailValid(bool isValid) {
    _emailValid = isValid;
    notifyListeners();
  }

  void updatePasswordValid(bool isValid) {
    _passwordValid = isValid;
    notifyListeners();
  }

  bool get isFormValid => _emailValid && _passwordValid;
}