import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/track.dart';
import '../../constants.dart';
import '../../screens/trackDetailsScreen.dart';

class TrackCard extends StatelessWidget {
  final Track track;

  TrackCard({@required this.track});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          TrackDetailsScreen.routeName,
          arguments: track,
        );
      },
      child: Container(
        width: deviceWidth * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kSpringColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(deviceWidth * 0.018), topRight: Radius.circular(deviceWidth * 0.018)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Track ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: kWhiteColor
                        ),
                        children: [
                          TextSpan(
                            text: track.begin.toUtc().toString().replaceFirst('.000Z', ''),
                          ),
                        ]
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Icon(
                      Icons.more_vert_outlined,
                      color: kWhiteColor,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Image.asset(
                'assets/images/map_placeholder.png',
                width: double.infinity,
                height: deviceHeight * 0.2,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Row(
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
                        style: TextStyle(
                          color: kSpringColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
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
                        track.length.toStringAsFixed(2) + 'km',
                        style: TextStyle(
                          color: kSpringColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
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
            ),
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[350],
              blurRadius: 3.0,
              spreadRadius: 1.0,
              offset: Offset(-2, 2),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }
}
