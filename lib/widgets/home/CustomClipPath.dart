import 'package:flutter/material.dart';

/// flip the wave direction horizontal axis
bool flip;
/// [DiagonalPathClipperTwo], can be used with [ClipPath] widget, and clips the widget diagonally
class CustomClipPath extends CustomClipper<Path> {
  /// reverse the wave direction in vertical axis
  bool reverse;


  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height);

    var secondControlPoint =
    Offset(size.width - (size.width / 7), size.height - 5);
    var secondEndPoint = Offset(size.width, size.height - 90);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}