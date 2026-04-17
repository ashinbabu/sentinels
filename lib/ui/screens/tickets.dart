import 'package:busco/providers/authentication_provider.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialApiCalls();
    });
  }

  _initialApiCalls() async {
    TicketProvider ticketProvider = Provider.of(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.userId <= 0) {
      ticketProvider.error = 'Please login again';
      return;
    }
    await TicketApi.getTickets(ticketProvider, user_id: authProvider.userId);
  }

  @override
  Widget build(BuildContext context) {
    TicketProvider _ticketProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        actions: [
          IconButton(
            onPressed: _initialApiCalls,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: _ticketProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _ticketProvider.errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _ticketProvider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _ticketProvider.getTickets.isEmpty
                    ? const Center(child: Text('No tickets found'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        itemCount: _ticketProvider.getTickets.length,
                        itemBuilder: (context, index) {
                          final ticketItem = _ticketProvider.getTickets[index];
                          return TicketItem(ticket: ticketItem);
                        },
                      ),
      ),
    );
  }
}
