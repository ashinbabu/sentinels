import 'dart:async';

import 'package:flutter/material.dart';
import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/services/authentication_api.dart';
import 'package:busco/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;

  int splashDuration = 2000;

  @override
  void initState() {
    var token;
    var userId;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    var sharedPrefGet = Future<bool>.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token') ?? '';
      userId = prefs.getInt('userId') ?? 0;

      return true;
    });

    var minTimeElapsed = Future<bool>.delayed(Duration(seconds: 3), () {
      return true;
    });

    Future.delayed(Duration.zero, () async {
      if (await sharedPrefGet && await minTimeElapsed) {
        if (token != '' && token.length > 10) {
          //TODO, some more to find if its a valid token
          authProvider.setAuthToken(token, userId);

          bool success = false;
          // try {
          //   success = await AuthenticationApi.getCurrencies(authProvider);
          // } catch (e) {
          //   print(e.toString());
          // }

         
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/signup');
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
         
            Image.asset(
              './assets/images/Splash.png',
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: LinearProgressIndicator(
                color: Color(PRIMARY_COLOR),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
