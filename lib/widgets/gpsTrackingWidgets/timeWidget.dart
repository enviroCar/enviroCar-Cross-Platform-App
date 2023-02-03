import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../animations/blinkAnimation.dart';
import '../../providers/gpsTrackProvider.dart';

class TimeWidget extends StatelessWidget {
  final String duration;
  final Function function;

  const TimeWidget({required this.duration, required this.function});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<GpsTrackProvider>(
          builder: (context, gpsTrackProvider, child) {
            final bool blinkTimeWidget = gpsTrackProvider.isTrackingPaused;

            final Widget timeTextWidget = Text(
              duration,
              style: const TextStyle(
                color: kWhiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            );

            if (blinkTimeWidget) {
              return BlinkAnimation(
                child: timeTextWidget,
              );
            } else {
              return timeTextWidget;
            }
          },
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          'time'.toUpperCase(),
          style: const TextStyle(
            color: kWhiteColor,
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
