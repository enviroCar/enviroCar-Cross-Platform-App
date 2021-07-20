import 'package:flutter/material.dart';

import '../constants.dart';

/// Used in
/// 1. Create Fueling Screen
/// 2. Log Book Screen
/// 3. Report Issue Screen
/// 4. Settings Screen

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: kSpringColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
