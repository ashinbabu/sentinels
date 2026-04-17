import 'package:busco/models/QRCode.dart';
import 'package:flutter/material.dart';

class QRCodeProvider with ChangeNotifier {
  QRCode _qrCode = const QRCode();
  bool _isLoading = false;
  String _error = '';

  set setQRCode(QRCode qrCode) {
    _qrCode = qrCode;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  QRCode get qrCode => _qrCode;
  bool get isLoading => _isLoading;
  String get errorMessage => _error;
}
