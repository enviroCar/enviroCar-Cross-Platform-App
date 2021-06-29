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
    return Container(
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
                        color: kWhiteColor,
                      ),
                      children: [
                        TextSpan(
                          text: track.begin.toUtc().toString().replaceFirst('.000Z', ''),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: PopupMenuButton(
                    enabled: true,
                    child: Icon(
                      Icons.more_vert_outlined,
                      color: kWhiteColor,
                    ),
                    onSelected: (int index) {
                      if (index == 0) {
                        Navigator.of(context).pushNamed(
                          TrackDetailsScreen.routeName,
                          arguments: track,
                        );
                      }
                      else if (index == 1) {
                        // TODO: function to delete track
                        debugPrint('delete track tapped');
                      }
                      else if (index == 2) {
                        // TODO: function to upload track as open data
                        debugPrint('upload as open data tapped');
                      }
                      else if (index == 3) {
                        // TODO: function to export track
                        debugPrint('export track tapped');
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          'Show Details',
                        ),
                        value: 0,
                      ),
                      PopupMenuItem(
                        child: Text(
                          'Delete Track',
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text(
                          'Upload Track as Open Data',
                        ),
                        value: 2,
                      ),
                      PopupMenuItem(
                        child: Text(
                          'Export Track',
                        ),
                        value: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                TrackDetailsScreen.routeName,
                arguments: track,
              );
            },
            // TODO: replace the placeholder map image with map widget
            child: Container(
              child: Image.asset(
                'assets/images/map_placeholder.png',
                fit: BoxFit.cover,
                height: deviceHeight * 0.2,
                width: double.infinity,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                TrackDetailsScreen.routeName,
                arguments: track,
              );
            },
            child: Container(
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
                      // SizedBox(
                      //   height: deviceHeight * 0.02,
                      // ),
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
                      // SizedBox(
                      //   height: deviceHeight * 0.02,
                      // ),
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
    );
  }
}
