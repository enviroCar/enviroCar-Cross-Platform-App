import 'package:flutter/material.dart';

import '../../constants.dart';

class DetailsIcon extends StatelessWidget {
  final String title;
  final String data;
  final IconData iconData;

  const DetailsIcon({this.title, this.data, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          data, // TODO: change this to speed or distance
          style: const TextStyle(
              color: kWhiteColor,
              fontWeight: FontWeight.w600
          ),
        ),
        Text(
          title,
          style: const TextStyle(
              color: kWhiteColor
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(4)),
              color: kWhiteColor
          ),
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Icon(
            iconData,
            size: 18,
            color: kSpringColor,
          ),
        ),
      ],
    );
  }
}