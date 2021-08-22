import 'package:flutter/material.dart';

import '../constants.dart';

class IconBadge extends StatelessWidget {
  final IconData iconData;
  final bool checked;

  // ignore: avoid_positional_boolean_parameters
  const IconBadge({this.iconData, this.checked});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: kSpringColor.withOpacity(0.8),
          radius: 22,
          child: CircleAvatar(
            backgroundColor: kWhiteColor,
            radius: 20,
            child: Icon(
              iconData,
              color: kGreyColor.withOpacity(0.2),
            ),
          ),
        ),
        Visibility(
          visible: checked,
          child: Positioned(
            top: 28,
            left: 28,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: kSpringColor.withOpacity(0.8),
              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 15,
                  color: kWhiteColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}