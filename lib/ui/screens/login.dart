import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/services/authentication_api.dart';
import 'package:busco/ui/shared/wave_clip_path.dart';
import 'package:busco/ui/widgets/common.dart';
import 'package:busco/utils/colors.dart';
import 'package:busco/utils/helper_functions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double sidePadding = 30;
  late bool showPassword;
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  @override
  void initState() {
    showPassword = false;
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
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
          //First Background Layer
          ClipPath(
            clipper: CustomClipPath(size),
            child: Container(
              height: size.height,
              width: size.width,
              color: Color(PRIMARY_COLOR),
            ),
          ),
          //SignIn Layer
          SingleChildScrollView(
            child: Container(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: sidePadding),
                            child: Text(
                              'SignIn',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //Facebook and google plus Icons
                ],
              ),
            ),
          ),
          //Fields and buttons Widget layer
          SingleChildScrollView(
            child: Container(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 190,
                  ),
                  //Email entry text filed
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: sidePadding),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000)),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sidePadding,
                          vertical: 22,
                        ),
                        hintText: 'Email Address',
                        hintStyle: GoogleFonts.montserrat(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Password Entry Text Field
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: sidePadding),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000)),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              showPassword
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                              color: Colors.black54,
                              size: 30,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sidePadding,
                          vertical: 22,
                        ),
                        hintText: 'Password',
                        hintStyle: GoogleFonts.montserrat(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Remember me checkbox
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sidePadding),
                    child: Row(
                      children: [
                        Checkbox(
                          value: authProvider.rememberPassword,
                          onChanged: (value) {
                            authProvider.rememberPassword =
                                !(authProvider.rememberPassword);
                          },
                          fillColor: MaterialStateProperty.all(Colors.black54),
                        ),
                        Text(
                          'Remember Me',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black45, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Yellow Button with CONTINUE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sidePadding),
                    child: ElevatedButton(
                      // onPressed: _handleContinue,
                      onPressed: (){
                        showTextSnackBar(context, 'Login Successful');
                        Navigator.pushReplacementNamed(context, '/home');
      
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
                  SizedBox(
                    height: 20,
                  ),
                  //Forgot Password
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: sidePadding),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18, color: Colors.black54)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(TEXT_COLOR), width: 2),
                            ),
                            child: ImageIcon(
                              AssetImage(
                                './assets/images/login-fb.png',
                              ),
                              color: Color(TEXT_COLOR),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(TEXT_COLOR), width: 2),
                            ),
                            child: InkWell(
                              onTap: () {
                               
                              },
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
                        height: 40,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SafeArea(child: LoadinBar(show: authProvider.isAnyApiRunning)),
        ],
      ),
    );
  }

  _handleContinue() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showTextSnackBar(context, 'Please enter Email and Password');
      return;
    }

    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(emailController.text)) {
      showTextSnackBar(context, 'Email not valid');
      return;
    }

    if (passwordController.text.isEmpty) {
      showTextSnackBar(context, 'Enter a password');
      return;
    }

    authProvider.clearError();
    authProvider.anApiStarted();
    bool success = await AuthenticationApi.loginRequest(
      authProvider,
      email: emailController.text,
      password: passwordController.text,
    );
    authProvider.anApiStopped();

    if (success) {
      showTextSnackBar(context, 'Login Successful');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showTextSnackBar(context, authProvider.errorMessage);
    }
  }
}
