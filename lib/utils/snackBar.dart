import 'package:flutter/material.dart';

import '../globals.dart';

/// function to display snack bar
void displaySnackBar(String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
  scaffoldMessengerState.currentState?.showSnackBar(snackBar);
}
