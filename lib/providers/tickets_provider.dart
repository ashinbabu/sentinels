import 'package:busco/models/ticket.dart';
import 'package:flutter/material.dart';

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];
  bool _isLoading = false;
  String _error = '';
  Ticket? _lastBookedTicket;

  List<Ticket> get getTickets => _tickets;
  bool get isLoading => _isLoading;
  String get errorMessage => _error;
  Ticket? get lastBookedTicket => _lastBookedTicket;

  set setTickets(List<Ticket> tickets) {
    _tickets = tickets;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set error(String message) {
    _error = message;
    notifyListeners();
  }

  set lastBookedTicket(Ticket? ticket) {
    _lastBookedTicket = ticket;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
