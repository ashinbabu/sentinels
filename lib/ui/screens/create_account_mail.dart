import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/services/authentication_api.dart';
import 'package:busco/ui/shared/wave_clip_path.dart';
import 'package:busco/ui/widgets/common.dart';
import 'package:busco/utils/colors.dart';
import 'package:busco/utils/helper_functions.dart';
import 'package:provider/provider.dart';

class CreateAccountWithEmailScreen extends StatefulWidget {
  @override
  _CreateAccountWithEmailScreenState createState() =>
      _CreateAccountWithEmailScreenState();
}

class _CreateAccountWithEmailScreenState
    extends State<CreateAccountWithEmailScreen> {
  final double sidePadding = 30;
  late bool showPassword;
  late bool showConfirmPassword;

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');

  @override
  void initState() {
    showPassword = false;
    showConfirmPassword = false;
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
          SingleChildScrollView(
            child: Container(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    './assets/images/Login-extra-art.png',
                    width: 120,
                  ),
                ],
              ),
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
          Column(
            children: [
              SizedBox(
                height: size.height * 0.12,
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
          //Second Widget layer
          SingleChildScrollView(
            child: Container(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  //Enter name text field
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: sidePadding),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000)),
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sidePadding,
                          vertical: 20,
                        ),
                        hintText: 'Name',
                        hintStyle: GoogleFonts.montserrat(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                          vertical: 20,
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
                          vertical: 20,
                        ),
                        hintText: 'Password',
                        hintStyle: GoogleFonts.montserrat(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Password Confirmation Text Field
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: sidePadding),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000)),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: !showConfirmPassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          onTap: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              showConfirmPassword
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
                          vertical: 20,
                        ),
                        hintText: 'Confirm Password',
                        hintStyle: GoogleFonts.montserrat(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  //Yellow Button with CONTINUE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sidePadding),
                    child: ElevatedButton(
                      onPressed: _handleRegisterContinue,
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
          ),
          SafeArea(child: LoadinBar(show: authProvider.isAnyApiRunning)),
        ],
      ),
    );
  }

  _handleRegisterContinue() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    if (nameController.text.isEmpty) {
      showTextSnackBar(context, 'Name can\'t be empty');
      return;
    }
    if (emailController.text.isEmpty) {
      showTextSnackBar(context, 'Email can\'t be empty');
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
    if (confirmPasswordController.text.isEmpty) {
      showTextSnackBar(context, 'Confirm password');
      return;
    }

    if (confirmPasswordController.text.length < 6) {
      showTextSnackBar(context, 'Password too short');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showTextSnackBar(context, 'Passwords don\'t match');
      return;
    }

    authProvider.clearError();
    authProvider.anApiStarted();
    bool success = await AuthenticationApi.registerUserRequest(
      authProvider,
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPass: confirmPasswordController.text,
    );
    authProvider.anApiStopped();
    if (success) {
      showTextSnackBar(
          context, 'Success. Please verify your email before logging in');
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      showTextSnackBar(context, authProvider.errorMessage);
    }
  }
}
