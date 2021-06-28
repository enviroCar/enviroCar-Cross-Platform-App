import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../globals.dart';

class StackedMapButton extends StatelessWidget {
  final double buttonDiameter = 55;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (deviceHeight * 0.3) + (buttonDiameter) / 2,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/images/map_placeholder.png',
              fit: BoxFit.cover,
              height: deviceHeight * 0.3,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: (deviceHeight * 0.3) - (buttonDiameter) / 2,
            right: (30) / 2,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: kSpringColor,
                  shape: BoxShape.circle,
                ),
                height: buttonDiameter,
                width: buttonDiameter,
                child: Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
