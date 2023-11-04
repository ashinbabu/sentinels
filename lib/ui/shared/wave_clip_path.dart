import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  var radius = 50.0;
  final Size deviceSize;
  CustomClipPath(this.deviceSize);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, deviceSize.height * 0.32);
    path.quadraticBezierTo(deviceSize.width / 4, deviceSize.height / 10,
        deviceSize.width * 2 / 3, deviceSize.height * 0.28);
    path.quadraticBezierTo(7 / 8 * deviceSize.width, deviceSize.height * 0.38,
        deviceSize.width, deviceSize.height * 0.4);
    path.lineTo(deviceSize.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TrinagleCut extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(size);

    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.height / 2, size.height / 2);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
