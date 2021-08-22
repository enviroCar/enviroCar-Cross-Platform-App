import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../constants.dart';

class NoTracksWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData iconData;


  const NoTracksWidget({
    @required this.title,
    @required this.subTitle,
    @required this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight * 0.7,
      width: deviceWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 160,
            color: kSpringColor,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                  color: kSpringColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Text(
              subTitle,
              style: const TextStyle(
                color: kSpringColor,
                fontSize: 14
              ),
            ),
          ),
        ],
      ),
    );
  }
}