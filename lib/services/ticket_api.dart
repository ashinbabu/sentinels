import 'dart:convert';

import 'package:busco/models/ticket.dart';
import 'package:busco/providers/tickets_provider.dart';
import 'package:http/http.dart' as http;
import 'package:busco/utils/constants.dart';
class TicketApi{
  static final baseURL = baseUrl;
   static Future<bool> getTickets(TicketProvider ticketProvider,
      {required user_id}) async {
    bool success = false;
    List<Ticket> _tickets = [];
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get-tickets'));

    request.fields.addAll({
      'user_id':user_id
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);
        body['data'].forEach((ticket)=>{
          _tickets.add(Ticket(id: ticket['id'],source: ticket['source'],destination: ticket['destination'],fare: ticket['fare']))
        });
      ticketProvider.setTickets = _tickets;
      } else {
        
      }
      return success;
      }
static createTicket(
      TicketProvider ticketProvider,
      userId,
      source,
      destination,
      fare,
      busid,
      seatno,
      busname
     ) async {
    bool success = false;

    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}create-ticket'));
    request.fields.addAll({
      
      'userId': '$userId',
      'source': '$source',
      'destination': '$destination',
      'fare': '$fare',
      'bus_id':'$busid',
      'seat_no':'$seatno',
      'bus_name':'$busname',
    });
  
  

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();

      var body = json.decode(responseString);
      print(body);
    
    return success;
  }

}
}