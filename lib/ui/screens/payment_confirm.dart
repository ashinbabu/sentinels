import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/services/authentication_api.dart';
import 'package:busco/ui/shared/wave_clip_path.dart';
import 'package:busco/ui/widgets/common.dart';
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

 
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            //SignIn Layer
            SingleChildScrollView(
              child:   Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: (){
                          showTextSnackBar(context, 'Payment Successful');
                        Navigator.pushNamed(context, '/tickets');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          child: Center(
                            child: Text(
                              'Goto Payment Gateway',
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
                    
                       ),
           
           
          ],
        ),
      ),
    );
  }

  _handleContinue() async {
   
    }




}
