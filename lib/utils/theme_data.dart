import 'package:flutter/material.dart';
import 'package:busco/utils/colors.dart';

ThemeData themeData = ThemeData(
  primarySwatch: swatchColor,
  fontFamily: 'Montserrat',
  textTheme: const TextTheme(
      headline1: TextStyle(
          fontSize: 20, color: Color(TEXT_COLOR), fontWeight: FontWeight.w600),
      headline2: TextStyle(
          fontSize: 18, color: Color(TEXT_COLOR), fontWeight: FontWeight.w500),
      headline3: TextStyle(
          fontSize: 15, color: Color(TEXT_COLOR), fontWeight: FontWeight.w500),
      headline4: TextStyle(
          fontSize: 15, color: Color(TEXT_COLOR), fontWeight: FontWeight.w300),
      headline5: TextStyle(
          fontSize: 12, color: Color(TEXT_COLOR), fontWeight: FontWeight.w600),
      headline6: TextStyle(
          fontSize: 12, color: Color(TEXT_COLOR), fontWeight: FontWeight.w300),
      bodyText1: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Color(TEXT_COLOR),
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      )),
);
