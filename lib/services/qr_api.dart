import 'dart:convert';

import 'package:busco/models/QRCode.dart';
import 'package:busco/models/ticket.dart';
import 'package:busco/providers/qr_code_provider.dart';
import 'package:busco/providers/tickets_provider.dart';
import 'package:http/http.dart' as http;
import 'package:busco/utils/constants.dart';
class QrApi{
  static final baseURL = baseUrl;
   static Future<bool> getQRDetails(QRCodeProvider qrCodeProvider,
      {required qr_code}) async {
    bool success = false;
    QRCode qrCode;
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get-qr-details'));

    request.fields.addAll({
      'qr_code':qr_code
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);
       var data = body['data'];
       qrCode = data[0];
      qrCodeProvider.setQRCode = qrCode;
      } else {
        
      }
      return success;
      }


}