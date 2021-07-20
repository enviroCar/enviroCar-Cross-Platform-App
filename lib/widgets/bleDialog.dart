import 'package:flutter/material.dart';

import '../constants.dart';

class BLEDialog extends StatelessWidget {
  final Function toggleBluetooth;

  const BLEDialog({@required this.toggleBluetooth});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Turn on Bluetooth?'),
      actions: [
        //cancel button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: kSpringColor,
            ),
          ),
        ),

        //delete
        TextButton(
          onPressed: () {
            toggleBluetooth();
            Navigator.pop(context);
          },
          child: const Text(
            'Yes',
            style: TextStyle(
              color: kSpringColor,
            ),
          ),
        ),
      ],
    );
  }
}
