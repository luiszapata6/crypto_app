import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';

class Utils {
  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message, Color? color) {
    final snackBar = SnackBar(content: TextPoppins(text: message), backgroundColor: color ?? Colors.red);

    scaffoldKey.currentState
      ?..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

class CustomColors {
  final black = const Color(0xff121212);
  final darkGrey = const Color((0xff444444));
  final white = const Color(0xffeeeeee);
  final purple = const Color(0xff8E6FF7);
  final grey = const Color(0xff41403E);
}
