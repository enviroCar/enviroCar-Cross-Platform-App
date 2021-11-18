import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/enums.dart';
import '../models/track.dart';
import '../widgets/tracksScreenWidgets/trackDetailsCard.dart';
import '../widgets/trackDetailsWidgets/stackedMapButton.dart';

class TrackDetailsScreen extends StatelessWidget {
  static const routeName = '/trackDetailsScreen';

  final Track track;
  final TrackType trackType;
  final int index;

  const TrackDetailsScreen({
    @required this.track,
    @required this.trackType,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        // enviroCar logo
        title: Image.asset(
          'assets/images/img_envirocar_logo_white.png',
          scale: 10,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StackedMapButton(
              trackType: trackType,
              index: index,
            ),
            const SizedBox(
              height: 20,
            ),
            TrackDetailsCard(
              track: track,
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
