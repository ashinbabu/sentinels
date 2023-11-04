import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _rememberPassword = true;
  bool _loginState = false;
  String _authToken = '';
  int _userId = 0;

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

  set rememberPassword(bool remember) {
    _rememberPassword = remember;
    notifyListeners();
  }

  bool get rememberPassword => _rememberPassword;

  setAuthToken(String token, userId) async {
    _authToken = token;
    _userId = userId;
    _loginState = true;
    notifyListeners();
    if (_rememberPassword) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool saved = await prefs.setString('token', token);
      await prefs.setInt('userId', userId);
      //TODO Remove and properly handle
      if (saved) {
        print('Token saved to shared preferance');
      }
    } else {
      print('Token not saved - remeber password false');
    }
  }

  removeAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    _loginState = false;
    notifyListeners();
  }

  bool get loginState => _loginState;

  String get authToken => _authToken;

  int get userId => _userId;

  //To handle error from api to show on Toast
  String _errorMessage = '';

  set errorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  clearError() {
    _errorMessage = '';
    notifyListeners();
  }

}
