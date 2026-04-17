import 'package:busco/models/QRCode.dart';
import 'package:busco/providers/qr_code_provider.dart';
import 'package:busco/services/api_client.dart';
import 'package:busco/utils/constants.dart';

class QrApi {
  static final baseURL = baseUrl;

  static Future<bool> getQRDetails(QRCodeProvider qrCodeProvider,
      {required String qr_code}) async {
    bool success = false;
    qrCodeProvider.isLoading = true;
    qrCodeProvider.clearError();
    final response =
        await ApiClient.get('get-qr-details/', query: {'qr_code': qr_code});

    if (response.success) {
      final dynamic data = response.body['data'];
      if (data is List && data.isNotEmpty && data.first is Map) {
        final qrCode = QRCode.fromMap(Map<String, dynamic>.from(data.first));
        qrCodeProvider.setQRCode = qrCode;
        success = true;
      } else if (data is Map) {
        final qrCode = QRCode.fromMap(Map<String, dynamic>.from(data));
       qrCodeProvider.setQRCode = qrCode;
        success = true;
      } else {
        qrCodeProvider.error = 'Invalid QR response';
      }
    } else {
      qrCodeProvider.error = response.error ?? 'Failed to fetch QR details';
    }
    qrCodeProvider.isLoading = false;
    return success;
  }
}


}
