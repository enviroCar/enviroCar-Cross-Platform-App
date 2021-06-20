import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../globals.dart';

class StackedMapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (deviceHeight * 0.3) + (deviceHeight * 0.06) / 2,
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
            top: (deviceHeight * 0.3) - (deviceHeight * 0.06) / 2,
            right: (deviceHeight * 0.06) / 2,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: kSpringColor,
                  shape: BoxShape.circle,
                ),
                height: deviceHeight * 0.06,
                width: deviceHeight * 0.06,
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
