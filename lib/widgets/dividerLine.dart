import 'package:flutter/material.dart';

// Creates a divider line
class DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Divider(
        thickness: 2,
      ),
    );
  }
}
