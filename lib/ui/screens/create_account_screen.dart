import 'dart:convert';

import 'package:busco/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/services/authentication_api.dart';
import 'package:busco/ui/shared/wave_clip_path.dart';
import 'package:busco/utils/colors.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:busco/utils/helper_functions.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final double sidePadding = 20;

  bool _checking = true;

 

  String prettyPrint(Map json) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }

  

  
  Future<void> _logOut() async {
   
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                './assets/images/Login-extra-art.png',
                width: 120,
              ),
            ),
            //FIrst Background Layer
            ClipPath(
              clipper: CustomClipPath(size),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Color(PRIMARY_COLOR),
              ),
            ),
            //Second layer Create account
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
                  child: Text(
                    'Create Account',
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
            //Widget Layer
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Continue wit google button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
                  child: ElevatedButton(
                    onPressed: (){

                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      )),
                      elevation: MaterialStateProperty.all(10),
                      backgroundColor:
                          MaterialStateProperty.all(Color(PRIMARY_COLOR)),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Text(
                          'CONTINUE WITH GOOGLE',
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Continue with email button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/signup/email'),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.email,
                                color: Color(PRIMARY_COLOR),
                              ),
                            ),
                            Text(
                              'CONTINUE WITH EMAIL',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Color(PRIMARY_COLOR),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.email,
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(color: Color(PRIMARY_COLOR)),
                      )),
                      elevation: MaterialStateProperty.all(10),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                //Facebook and G plus Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap:(){

                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(TEXT_COLOR), width: 2),
                        ),
                        child: ImageIcon(
                          AssetImage(
                            './assets/images/login-fb.png',
                          ),
                          color: Color(TEXT_COLOR),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap:(){},
                      child: Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(TEXT_COLOR), width: 2),
                        ),
                        child: ImageIcon(
                          AssetImage(
                            './assets/images/login-google.png',
                          ),
                          color: Color(TEXT_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already  have an Account? ',
                      style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(fontSize: 18, color: Colors.black54)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'SignIn',
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 18, color: Color(PRIMARY_COLOR))),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            )
          ],
        ));
  }
}
