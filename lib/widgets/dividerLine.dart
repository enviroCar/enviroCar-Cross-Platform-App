import 'package:flutter/material.dart';

/// Used in
/// 1. Create Fueling Screen
/// 2. Profile Screen
/// 3. Settings Screen
/// 4. Fueling Card Widget

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
