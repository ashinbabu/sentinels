import 'package:busco/models/QRCode.dart';
import 'package:flutter/material.dart';

class QRCodeProvider with ChangeNotifier{
QRCode _qrCode = QRCode();

set setQRCode(QRCode qrCode){
_qrCode = qrCode;
notifyListeners();
}

}