import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/providers/tickets_provider.dart';
import 'package:busco/services/ticket_api.dart';
import 'package:busco/utils/colors.dart';
import 'package:busco/utils/helper_functions.dart';
import 'package:provider/provider.dart';

class PaymentConfirm extends StatefulWidget {
  @override
  _PaymentConfirmState createState() => _PaymentConfirmState();
}

class _PaymentConfirmState extends State<PaymentConfirm> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _bookTicket(Map<String, dynamic> bookingData) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    if ((bookingData['destination'] ?? '').toString().isEmpty) {
      showTextSnackBar(context, 'Invalid destination');
      return;
    }
    final success = await TicketApi.createTicket(
      ticketProvider,
      authProvider.userId,
      (bookingData['source'] ?? '').toString(),
      (bookingData['destination'] ?? '').toString(),
      (bookingData['fare'] is num)
          ? bookingData['fare'] as num
          : num.tryParse((bookingData['fare'] ?? '').toString()) ?? 0,
      (bookingData['bus_id'] ?? '').toString(),
      (bookingData['seat_no'] ?? '').toString(),
      (bookingData['bus_name'] ?? '').toString(),
      tripId: (bookingData['trip_id'] ?? '').toString(),
      authToken: authProvider.authToken,
    );
    if (!mounted) return;
    if (success) {
      showTextSnackBar(context, 'Payment Successful');
      Navigator.pushReplacementNamed(context, '/tickets');
    } else {
      showTextSnackBar(context, ticketProvider.errorMessage);
      Navigator.pushNamed(context, '/pay_failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final bookingData = routeArgs is Map<String, dynamic>
        ? routeArgs
        : <String, dynamic>{};

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Source: ${bookingData['source'] ?? '-'}'),
                      Text('Destination: ${bookingData['destination'] ?? '-'}'),
                      Text('Bus: ${bookingData['bus_name'] ?? '-'}'),
                      Text('Seat: ${bookingData['seat_no'] ?? '-'}'),
                      Text('Fare: ${bookingData['fare'] ?? '-'}'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: ticketProvider.isLoading
                    ? null
                    : () {
                        _bookTicket(bookingData);
                      },
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Center(
                    child: ticketProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Goto Payment Gateway',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(10),
                  backgroundColor:
                      MaterialStateProperty.all(Color(PRIMARY_COLOR)),
                ),
              ),
            ),
            if (ticketProvider.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  ticketProvider.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
