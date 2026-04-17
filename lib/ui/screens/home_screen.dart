import 'dart:io';

import 'package:busco/models/destinations.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/providers/destination_provider.dart';
import 'package:busco/providers/qr_code_provider.dart';
import 'package:busco/services/qr_api.dart';
import 'package:busco/ui/widgets/scaffold_widgets/app_bar_w_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busco/utils/colors.dart';
import 'package:busco/utils/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime = DateTime.now();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Destinations? _selectedDestination;
  final TextEditingController sourceController = TextEditingController(text: '');
  final TextEditingController seatController = TextEditingController(text: '');
  bool _isProcessingScan = false;
  String _lastScannedCode = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  _getQRDetails(String qrCode) async {
    QRCodeProvider qrCodeProvider = Provider.of(context, listen: false);
    DestinationProvider destinationProvider =
        Provider.of(context, listen: false);
    final success = await QrApi.getQRDetails(qrCodeProvider, qr_code: qrCode);
    if (!mounted) return;
    if (success) {
      final parsed = qrCodeProvider.qrCode;
      sourceController.text = parsed.source;
      seatController.text = parsed.seatNumber;
      destinationProvider.serviceNames = parsed.destinations;
      if (parsed.destinations.isNotEmpty) {
        _selectedDestination = parsed.destinations.first;
      }
    } else {
      showTextSnackBar(context, qrCodeProvider.errorMessage);
    }
  }

 
  Future<bool> _onWillPopScope() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 3)) {
      currentBackPressTime = now;
      showTextSnackBar(context, 'Press back again to Exit');
      return Future.value(false);
    }

    showTextSnackBar(context, 'Exited');

    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    DestinationProvider destinationProvider = Provider.of(context);
    QRCodeProvider qrCodeProvider = Provider.of(context);
    final qrData = qrCodeProvider.qrCode;
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        appBar: AppBarWithSearch(
          isSearchVisible: true,
          isFavVisible: true,
        ),
       
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                   
                     Container(
                        margin: const EdgeInsets.all(20),
                        height: 200,
                        width: 200,
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: qrCodeProvider.isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  result?.code ?? 'Scan a code',
                                ),
                        ),
                      ),
                      if (qrCodeProvider.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            qrCodeProvider.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      TextField(
                      controller: sourceController,
                       enabled: false,
                       keyboardType: TextInputType.text,
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         contentPadding: const EdgeInsets.symmetric(
                           horizontal: 20,
                           vertical: 20,
                         ),
                        hintText: 'Starting Location',
                        hintStyle: GoogleFonts.montserrat(),
                      ),
                    ),
           Container(
                           width: deviceWidth - 30,
                           child: Card(
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10),
                           child: DropdownButtonHideUnderline(
                                 child: DropdownButton<Destinations>(
                                   value: _selectedDestination,
                                   hint: Text('Select the Destination '),
                                   items: destinationProvider.serviceNames
                                       .map((Destinations value) {
                                    return DropdownMenuItem<Destinations>(
                                      value: value,
                                      child: Text(value.serviceName),
                                    );
                                  }).toList(),
                                   onChanged: (destination) {
                                     setState(() {
                                        _selectedDestination = destination;
                                     });
                                   },
                                 ),
                               ),
                             ),
                           )),
                           TextField(
                       controller: seatController,
                       enabled: true,
                       keyboardType: TextInputType.number,
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         contentPadding: const EdgeInsets.symmetric(
                           horizontal: 20,
                           vertical: 20,
                         ),
                         hintText: 'Seat Number',
                         hintStyle: GoogleFonts.montserrat(),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(
                         horizontal: 20,
                         vertical: 20,
                       ),
                       child: Align(
                         alignment: Alignment.centerLeft,
                         child: Text(
                           qrData.fare > 0 ? 'Fare Rs.${qrData.fare}/-' : 'Fare',
                           style: GoogleFonts.montserrat(),
                         ),
                       ),
                     ),
           Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: (){
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        if (result?.code == null || result!.code!.isEmpty) {
                          showTextSnackBar(context, 'Please scan QR code first');
                          return;
                        }
                        if (!qrData.isValid) {
                          showTextSnackBar(context, 'Invalid QR details');
                          return;
                        }
                        if (_selectedDestination == null) {
                          showTextSnackBar(context, 'Please select destination');
                          return;
                        }
                        if (seatController.text.trim().isEmpty) {
                          showTextSnackBar(context, 'Please enter seat number');
                          return;
                        }
                        if (authProvider.userId <= 0) {
                          showTextSnackBar(context, 'Please login again');
                          return;
                        }
                        Navigator.pushNamed(
                          context,
                          '/confirm_payment',
                          arguments: {
                            'source': qrData.source,
                            'destination': _selectedDestination!.serviceName,
                            'fare': qrData.fare,
                            'bus_id': qrData.busId,
                            'bus_name': qrData.busName,
                            'seat_no': seatController.text.trim(),
                            'trip_id': qrData.tripId,
                          },
                        );
                       },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        child: Center(
                          child: Text(
                            'CONTINUE',
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        )),
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor:
                            MaterialStateProperty.all(Color(PRIMARY_COLOR)),
                      ),
                    ),
                  ),
                   
                   
                    
                    
                  ],
                ),
              ),
              
            ],
          ),
        ),
       
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessingScan || scanData.code == null || scanData.code!.isEmpty) {
        return;
      }
      if (_lastScannedCode == scanData.code) return;
      _isProcessingScan = true;
      _lastScannedCode = scanData.code!;
      setState(() {
        result = scanData;
      });
      await _getQRDetails(scanData.code!);
      _isProcessingScan = false;
    });
  }

  @override
  void dispose() {
    sourceController.dispose();
    seatController.dispose();
    controller?.dispose();
    super.dispose();
  }
}
