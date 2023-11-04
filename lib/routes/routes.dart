import 'package:busco/ui/screens/create_account_mail.dart';
import 'package:busco/ui/screens/create_account_screen.dart';
import 'package:busco/ui/screens/home_screen.dart';
import 'package:busco/ui/screens/login.dart';
import 'package:busco/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';


final namedRoutes = {
  '/': (context) => SplashScreen(),
  '/signup': (context) => CreateAccountScreen(),
  '/signup/email': (context) => CreateAccountWithEmailScreen(),
   '/login': (context) => LoginScreen(),
   '/home': (context) => HomeScreen(),
  };
