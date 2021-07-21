import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import '../../globals.dart';
import '../../models/track.dart';
import '../../constants.dart';
import '../../screens/trackDetailsScreen.dart';

class TrackCard extends StatelessWidget {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  final Track track;

  TrackCard({@required this.track});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _logger.i('Going to track details screen');
        Navigator.of(context).pushNamed(
          TrackDetailsScreen.routeName,
          arguments: track,
        );
      },
      child: Container(
        width: deviceWidth * 0.9,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[350],
              blurRadius: 3.0,
              spreadRadius: 1.0,
              offset: const Offset(-2, 2),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Track ',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.1,
                ),
                Text(
                  track.begin.toUtc().toString().replaceFirst('.000Z', ''),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      track.end
                          .difference(track.begin)
                          .toString()
                          .replaceFirst('.000000', ''),
                      style: const TextStyle(
                        color: kSpringColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    const Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${track.length.toStringAsFixed(2)}km',
                      style: const TextStyle(
                        color: kSpringColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    const Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
