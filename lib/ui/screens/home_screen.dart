import 'dart:io';

import 'package:busco/models/destinations.dart';
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
  TextEditingController nameController = TextEditingController(text:'');
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  _getQRDetails(qr_code) async {
    QRCodeProvider qrCodeProvider = Provider.of(context,listen: false);
   await QrApi.getQRDetails(qrCodeProvider, qr_code: qr_code);
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
          Container(
            height: 100,
            child: Center(
              child: (result != null)
                  ? Text(
                      '${result!.code}')
                  : Text('Scan a code'),
            ),
          ),
          TextField(
                      controller: nameController,
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Destinations>(
                                  // value: _selectedService,
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
                                    print(_selectedDestination);
                                  },
                                ),
                              ),
                            ),
                          )),
                          TextField(
                      controller: nameController,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Fare Rs.30/-',
                        hintStyle: GoogleFonts.montserrat(),
                      ),
                    ),
          Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: (){
                      Navigator.pushNamed(context, '/confirm_payment');
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
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
         _getQRDetails(result!.code);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
