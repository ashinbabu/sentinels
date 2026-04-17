import 'package:busco/models/ticket.dart';
import 'package:busco/providers/tickets_provider.dart';
import 'package:busco/services/api_client.dart';
import 'package:busco/utils/constants.dart';

class TicketApi {
  static final baseURL = baseUrl;

  static Future<bool> getTickets(TicketProvider ticketProvider,
      {required int user_id, String authToken = ''}) async {
    bool success = false;
    ticketProvider.isLoading = true;
    ticketProvider.clearError();
    final response = await ApiClient.postForm(
      'get-tickets',
      authToken: authToken,
      fields: {'user_id': user_id},
    );

    if (response.success) {
      final dynamic data = response.body['data'];
      final tickets = data is List
          ? data
              .whereType<Map>()
              .map((ticket) => Ticket.fromMap(Map<String, dynamic>.from(ticket)))
              .toList()
          : <Ticket>[];
      ticketProvider.setTickets = tickets;
      success = true;
    } else {
      ticketProvider.error = response.error ?? 'Unable to fetch tickets';
    }
    ticketProvider.isLoading = false;
    return success;
  }

  static Future<bool> createTicket(
      TicketProvider ticketProvider,
      int userId,
      String source,
      String destination,
      num fare,
      String busid,
      String seatno,
      String busname, {
      String tripId = '',
      String authToken = '',
    }) async {
    bool success = false;
    ticketProvider.isLoading = true;
    ticketProvider.clearError();

    final response = await ApiClient.postForm(
      'create-ticket',
      authToken: authToken,
      fields: {
        'userId': userId,
        'source': source,
        'destination': destination,
        'fare': fare,
        'bus_id': busid,
        'seat_no': seatno,
        'bus_name': busname,
        if (tripId.isNotEmpty) 'trip_id': tripId,
      },
    );

    if (response.success) {
      final dynamic ticketData = response.body['data'];
      if (ticketData is Map) {
        final booked = Ticket.fromMap(Map<String, dynamic>.from(ticketData));
        ticketProvider.lastBookedTicket = booked;
      } else {
        ticketProvider.lastBookedTicket = Ticket(
          source: source,
          destination: destination,
          fare: fare,
          busId: busid,
          seatNo: seatno,
          busName: busname,
          tripId: tripId,
        );
      }
      success = true;
    } else {
      ticketProvider.error = response.error ?? 'Unable to book ticket';
    }
    ticketProvider.isLoading = false;
    return success;
  }
}
