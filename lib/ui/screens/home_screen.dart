import 'dart:io';

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
    _initialApiCalls();
    super.initState();
  }

  _initialApiCalls() async {
   
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
                      'Barcode Type:   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
                   
                   
                    
                    
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
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
