class Ticket {
  final String id;
  final String source;
  final String destination;
  final num fare;
  final String busId;
  final String busName;
  final String seatNo;
  final String tripId;
  final DateTime? createdAt;

  const Ticket({
    this.id = '',
    this.source = '',
    this.destination = '',
    this.fare = 0,
    this.busId = '',
    this.busName = '',
    this.seatNo = '',
    this.tripId = '',
    this.createdAt,
  });

  factory Ticket.fromMap(Map<String, dynamic> map) {
    final created = map['created_at'] ?? map['createdAt'];
    return Ticket(
      id: (map['id'] ?? map['_id'] ?? '').toString(),
      source: (map['source'] ?? '').toString(),
      destination: (map['destination'] ?? '').toString(),
      fare: (map['fare'] is num)
          ? map['fare'] as num
          : num.tryParse((map['fare'] ?? '').toString()) ?? 0,
      busId: (map['bus_id'] ?? map['busId'] ?? '').toString(),
      busName: (map['bus_name'] ?? map['busName'] ?? '').toString(),
      seatNo: (map['seat_no'] ?? map['seatNo'] ?? '').toString(),
      tripId: (map['trip_id'] ?? map['tripId'] ?? '').toString(),
      createdAt: created == null ? null : DateTime.tryParse(created.toString()),
    );
  }
}
