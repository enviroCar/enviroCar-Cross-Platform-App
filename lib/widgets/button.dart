import 'package:flutter/material.dart';

/// Used in
/// 1. Create Fueling Screen
/// 2. Create Car Screen
/// 3. Dashboard Screen
/// 4. Report Issue Screen

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
    return GestureDetector(
      child: Container(
        height: 45,
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
    );
  }
}
