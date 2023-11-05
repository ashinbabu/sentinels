import 'package:busco/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TicketProvider with ChangeNotifier{
  List<Ticket> _tickets = [];

  List<Ticket> get getTickets=> _tickets;

  set setTickets(List<Ticket> tickets){
    _tickets = tickets;
    notifyListeners();
  }

}