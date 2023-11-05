import 'package:busco/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TicketProvider with ChangeNotifier{
  List<Ticket> _tickets = [Ticket(id: 1,source: 'Erumely',destination: 'Kottayam',fare: "50"),
  Ticket(id: 2,source: 'Vyttila',destination: 'Edappally',fare: 40),
   Ticket(id: 3,source: 'Vyttila',destination: 'Pathadipalam',fare: 50)];

  List<Ticket> get getTickets=> _tickets;

  set setTickets(List<Ticket> tickets){
    _tickets = tickets;
    notifyListeners();
  }

}