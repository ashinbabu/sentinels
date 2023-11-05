import 'package:busco/models/ticket.dart';
import 'package:flutter/material.dart';

class TicketItem extends StatefulWidget {
  final Ticket ticket;
   TicketItem({super.key,required this.ticket});

  @override
  State<TicketItem> createState() => _TicketItemState();
}

class _TicketItemState extends State<TicketItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [const Icon(Icons.note),
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [  
      Text('Source:${widget.ticket.source}'),
      Text('Destination:${widget.ticket.destination}')
     ],),
     Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text('Fare:20')],
     )
     ],)
    );
  }
}