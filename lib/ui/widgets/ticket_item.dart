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
      color: Colors.blueGrey,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      
      height: 100,
     child: Card(
      elevation: 10,
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [const Icon(Icons.ac_unit,color: Colors.blueAccent,),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [  
          Text('Source:${widget.ticket.source}'),
          Text('Destination:${widget.ticket.destination}')
         ],),
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Fare:${widget.ticket.fare}')],
         )
         ],),
       ),
     )
    );
  }
}