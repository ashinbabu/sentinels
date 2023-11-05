import 'package:busco/providers/tickets_provider.dart';
import 'package:busco/services/ticket_api.dart';
import 'package:busco/ui/widgets/ticket_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => __TicketsStateState();
}

class __TicketsStateState extends State<Tickets> {
@override
void initState() {
    // TODO: implement initState
    super.initState();
  }

  _initialApiCalls() async{
    TicketProvider ticketProvider = Provider.of(context,listen: false);
    await TicketApi.getTickets(ticketProvider, user_id: 1);

  }
  @override
  Widget build(BuildContext context) {
    TicketProvider _ticketProvider = Provider.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: _ticketProvider.getTickets.length,
            itemBuilder: (context, index) {
              final ticketItem = _ticketProvider.getTickets[index];
              return TicketItem(ticket: ticketItem);
            }
          ),
      )
            
  );
      
}
}