import 'package:busco/providers/authentication_provider.dart';
import 'package:busco/providers/user_details_provider.dart';
import 'package:busco/routes/routes.dart';
import 'package:busco/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserDetailsProvider()),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BusCo',
        theme: themeData,
        initialRoute: '/',
        routes: namedRoutes,
        onUnknownRoute: (route) => MaterialPageRoute(
            builder: (context) => const Scaffold(
                body: SafeArea(child: Center(child: Text('Not Found'))))),
      ),
    );
  }
}
