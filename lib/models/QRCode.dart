import 'package:busco/models/destinations.dart';

class QRCode {
  final String busId;
  final String busName;
  final String seatNumber;
  final String qrCode;
  final String source;
  final String tripId;
  final num fare;
  final List<Destinations> destinations;

  const QRCode({
    this.busId = '',
    this.busName = '',
    this.seatNumber = '',
    this.qrCode = '',
    this.source = '',
    this.tripId = '',
    this.fare = 0,
    this.destinations = const [],
  });

  bool get isValid => qrCode.isNotEmpty && (tripId.isNotEmpty || busId.isNotEmpty);

  factory QRCode.fromMap(Map<String, dynamic> map) {
    final dynamic destinationList =
        map['destinations'] ?? map['destination_options'] ?? [];
    final parsedDestinations = destinationList is List
        ? destinationList
            .whereType<Map>()
            .map((e) => Destinations.fromMap(Map<String, dynamic>.from(e)))
            .toList()
        : <Destinations>[];

    return QRCode(
      busId: (map['bus_id'] ?? map['busId'] ?? '').toString(),
      busName: (map['bus_name'] ?? map['busName'] ?? '').toString(),
      seatNumber: (map['seat_number'] ?? map['seatNo'] ?? '').toString(),
      qrCode: (map['qr_code'] ?? map['qrCode'] ?? '').toString(),
      source: (map['source'] ?? map['starting_location'] ?? '').toString(),
      tripId: (map['trip_id'] ?? map['tripId'] ?? '').toString(),
      fare: (map['fare'] is num)
          ? map['fare'] as num
          : num.tryParse((map['fare'] ?? '').toString()) ?? 0,
      destinations: parsedDestinations,
    );
  }
}
