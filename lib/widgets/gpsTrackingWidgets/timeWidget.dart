import 'package:flutter/material.dart';

import '../../constants.dart';

class TimeWidget extends StatelessWidget {
  final String duration;
  final Function function;

  const TimeWidget({this.duration, this.function});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          duration,
          style: const TextStyle(
              color: kWhiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 24
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          'time'.toUpperCase(),
          style: const TextStyle(
              color: kWhiteColor
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () => function(),
          child: ClipOval(
            child: Material(
              color: kErrorColor,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.stop,
                  color: kWhiteColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}