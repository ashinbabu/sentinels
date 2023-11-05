import 'package:busco/models/destinations.dart';
import 'package:flutter/material.dart';

class DestinationProvider with ChangeNotifier{
   List<Destinations> _destinationNames = [];

  set serviceNames(List<Destinations> names) {
    _destinationNames = names;
    notifyListeners();
  }

  List<Destinations> get serviceNames => _destinationNames;

}