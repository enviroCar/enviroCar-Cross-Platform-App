import 'package:flutter/material.dart';

import '../../constants.dart';

class StatusIndicatorWidget extends StatelessWidget {
  final String title;
  final IconData iconData;

  const StatusIndicatorWidget({this.title, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Material(
            color: kWhiteColor,
            child: SizedBox(
              height: 35,
              width: 35,
              child: Icon(
                iconData,
                color: kSpringColor,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: const TextStyle(
              color: kWhiteColor,
            ),
          ),
        ),
      ],
    );
  }
}