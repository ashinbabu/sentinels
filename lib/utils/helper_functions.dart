import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

showTextSnackBar(context, content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      content: Text(
        '$content',
        style: GoogleFonts.montserrat(),
      )));
}

showIconSnackBar(context, content, IconData icon) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$content',
            style: GoogleFonts.montserrat(),
          ),
          Icon(icon, color: Colors.white)
        ],
      )));
}

showToast(message) {
  Fluttertoast.showToast(
      msg: message,
      fontSize: 16,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT);
}
