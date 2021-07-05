import 'package:flutter/material.dart';

import '../../globals.dart';

// General button used throughout the app
class Button extends StatelessWidget {
  final String title;
  final Color color;
  final Function onTap;

  Button({
    @required this.title,
    @required this.color,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: deviceHeight * 0.06,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
