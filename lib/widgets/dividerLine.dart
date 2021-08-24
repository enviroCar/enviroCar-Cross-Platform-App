import 'package:flutter/material.dart';

// Creates a divider line
class DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Divider(
        thickness: 2,
      ),
    );
  }
}
