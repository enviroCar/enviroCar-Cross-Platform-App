import 'package:flutter/material.dart';

class BLEDialog extends StatelessWidget {
  final Function toggleBluetooth;

  BLEDialog({this.toggleBluetooth});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Turn on Bluetooth?'),
      actions: [
        //cancel button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 223, 165),
            ),
          ),
        ),

        //delete
        TextButton(
          onPressed: () {
            toggleBluetooth();
            Navigator.pop(context);
          },
          child: Text(
            'Yes',
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 223, 165),
            ),
          ),
        ),
      ],
    );
  }
}
