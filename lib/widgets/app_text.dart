import 'package:flutter/material.dart';

// class du widget qui possede le text en normal et la police normale pour la plus par des texts dans l'apps
// ignore: must_be_immutable
class AppText extends StatelessWidget {
  AppText({
    Key? key,
    this.size = 14,
    required this.text,
    required this.color,
  }) : super(key: key);
  double size;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Nunito',
          decoration: TextDecoration.none,
          letterSpacing: 0),
    );
  }
}
