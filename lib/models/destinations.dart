class Destinations {
  final String serviceId;
  final String serviceName;

  Destinations({
    required this.serviceId,
    required this.serviceName,
  });

  factory Destinations.fromMap(Map<String, dynamic> map) {
    return Destinations(
      serviceId: (map['service_id'] ?? map['id'] ?? '').toString(),
      serviceName:
          (map['service_name'] ?? map['name'] ?? map['destination'] ?? '')
              .toString(),
    );
  }
}
