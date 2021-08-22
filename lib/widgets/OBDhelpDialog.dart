import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class OBDHelpDialog extends StatefulWidget {
  @override
  _OBDHelpDialogState createState() => _OBDHelpDialogState();
}

class _OBDHelpDialogState extends State<OBDHelpDialog> {
  int index = 0;
  List<Widget> dialogScreens = [
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Locate DLC (Diagnostic Link Connector)',
          style: TextStyle(
            fontSize: 20,
            color: kSpringColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Image.asset('assets/images/findobddesgin.png'),
        const SizedBox(height: 10),
        const Text(
            'This is somewhat triangular shaped 16-pin connector that is commonly located underneath the left hand side of the dash near the steering column. If you have trouble locating DLC, refer owner manual.'),
        GestureDetector(
          onTap: () async {
            if (await canLaunch('https://wikiobd.co.uk')) {
              launch('https://wikiobd.co.uk');
            } else {
              throw 'Cannot Launch';
            }
          },
          child: const Text(
            'www.wikiobd.co.uk',
            style: TextStyle(
              color: kSpringColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plug OBD into cars OBD Port',
          style: TextStyle(
            color: kSpringColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Image.asset('assets/images/obdport.png'),
        const Text(
            'Plug OBD Bluetooth into car\'s OBD port and turn the ignition on'),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connect enviroCar app to OBD Bluetooth',
          style: TextStyle(
            color: kSpringColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Text('1. Select'),
        Image.asset('assets/images/noobdselected.jpeg'),
        const Text(
            '2. Turn on Bluetooth\n3. Connect to Bluetooth signals with names similar to: OBDII, VLink, ELM327 etc.\n4. All set! Start recording track'),
      ],
    ),
  ];

  void nextDialog() {
    setState(() {
      index += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'OBD Help',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: dialogScreens[index],
      ),
      actions: [
        //cancel button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Color(0xFFd71f1f)),
          ),
        ),

        //delete
        if (index < 2)
          TextButton(
            onPressed: () {
              nextDialog();
            },
            child: const Text(
              'Next',
              style: TextStyle(color: Color(0xFFd71f1f)),
            ),
          )
        else
          Container(),
      ],
    );
  }
}
