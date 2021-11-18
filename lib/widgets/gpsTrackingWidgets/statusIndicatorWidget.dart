import 'package:flutter/material.dart';

import '../../constants.dart';

class StatusIndicatorWidget extends StatelessWidget {
  final String title;
  final Icon icon;
  final Color backgroundColor;

  const StatusIndicatorWidget({
    @required this.title,
    @required this.icon,
    this.backgroundColor = kWhiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Material(
            color: backgroundColor,
            child: SizedBox(
              height: 35,
              width: 35,
              child: icon,
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
