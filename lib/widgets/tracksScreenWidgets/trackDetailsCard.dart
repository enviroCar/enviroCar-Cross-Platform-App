import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../constants.dart';
import '../../models/track.dart';
import '../trackDetailsWidgets/trackDetailsTile.dart';

class TrackDetailsCard extends StatelessWidget {
  final Track track;

  const TrackDetailsCard({required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth * 0.9,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350]!,
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: const Offset(-2, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: kSpringColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
            ),
            child: RichText(
              text: TextSpan(
                text: 'Track ',
                style: const TextStyle(
                  color: kWhiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                children: [
                  TextSpan(
                    text: track.begin!
                        .toUtc()
                        .toString()
                        .replaceFirst('.000Z', ''),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Your track with ${track.sensor!.properties!.manufacturer} ${track.sensor!.properties!.model} on ${trackDay(track.begin!.weekday)}',
              style: TextStyle(
                color: kGreyColor.withOpacity(0.8),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      track.end!
                          .difference(track.begin!)
                          .toString()
                          .replaceFirst('.000000', ''),
                      style: const TextStyle(
                        color: kSpringColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: kGreyColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      track.length != null
                          ? '${track.length?.toStringAsFixed(2)} km'
                          : '0 km',
                      style: const TextStyle(
                        color: kSpringColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: kGreyColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: kGreyColor.withOpacity(0.3),
              thickness: 1.2,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TrackDetailsTile(
              title: 'Car',
              details:
                  '${track.sensor!.properties!.manufacturer} - ${track.sensor!.properties!.model} ${track.sensor!.properties!.constructionYear}, ${track.sensor!.properties!.engineDisplacement} cm, ${track.sensor!.properties!.fuelType}',
              iconData: Icons.directions_car,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TrackDetailsTile(
              title: 'Start',
              details:
                  track.begin!.toUtc().toString().replaceFirst('.000Z', ''),
              iconData: Icons.timer_outlined,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TrackDetailsTile(
              title: 'End',
              details: track.end!.toUtc().toString().replaceFirst('.000Z', ''),
              iconData: Icons.timelapse,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TrackDetailsTile(
              title: 'Speed',
              details:
                  '${determineSpeed(track.length!, track.begin!, track.end!).toStringAsFixed(2)} km/hr',
              iconData: Icons.speed_rounded,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: const TrackDetailsTile(
              title: 'Number of stops',
              details: '1 stops',
              iconData: Icons.bus_alert,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  String trackDay(int weekday) {
    String day = 'Sunday';
    if (weekday == 1) {
      day = 'Monday';
    } else if (weekday == 2) {
      day = 'Tuesday';
    } else if (weekday == 3) {
      day = 'Wednesday';
    } else if (weekday == 4) {
      day = 'Thursday';
    } else if (weekday == 5) {
      day = 'Friday';
    } else if (weekday == 6) {
      day = 'Saturday';
    }
    return day;
  }

  double determineSpeed(double distance, DateTime start, DateTime end) {
    final Duration duration = end.difference(start);
    final double timeInHours =
        duration.inHours + duration.inMinutes / 60 + duration.inSeconds / 3600;
    double speed = 0;
    if (distance != null) {
      speed = distance / timeInHours;
    }
    if (speed.isNaN || speed.isInfinite) {
      speed = 0;
    }
    return speed;
  }
}
