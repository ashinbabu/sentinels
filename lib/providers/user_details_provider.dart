import 'package:flutter/material.dart';
import 'package:busco/models/user.dart';

class UserDetailsProvider with ChangeNotifier {
  //Any APi running. This is true when any Api under this provider is running
  bool _isAnyApiRunning = false;

  int _apiCount = 0;

  anApiStarted() {
    _isAnyApiRunning = true;
    _apiCount++;
    notifyListeners();
  }

  anApiStopped() {
    if (_apiCount > 1) {
      _apiCount--;
    } else {
      _apiCount = 0;
      _isAnyApiRunning = false;
    }
    notifyListeners();
  }

  isAnyApiRunningClear() async {
    await Future.delayed(Duration.zero);
    _apiCount = 0;
    _isAnyApiRunning = false;
    notifyListeners();
  }

  bool get isAnyApiRunning => _isAnyApiRunning;

  User _userData = User();
  setUserDetails(user) {
    _userData = user;

    notifyListeners();
  }

  User get userDetails => _userData;
}
