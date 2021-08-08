import 'package:flutter/material.dart';

import '../constants.dart';
import '../globals.dart';

void displaySnackBar(String trackId) {
  final snackBar = SnackBar(
    content: Text(
      'Track $trackId deleted successfully!',
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 15
      ),
    ),
    backgroundColor: kSpringColor,
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
  scaffoldMessengerState.currentState.showSnackBar(snackBar);
}