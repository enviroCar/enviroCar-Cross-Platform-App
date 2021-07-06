import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/trackDetailsWidgets/carDetailsCard.dart';
import '../widgets/trackDetailsWidgets/stackedMapButton.dart';
import '../widgets/tracksScrrenWidgets/trackCard.dart';
import '../models/track.dart';

class TrackDetailsScreen extends StatelessWidget {
  static const routeName = '/trackDetailsScreen';

  final Track track;

  const TrackDetailsScreen({
    @required this.track,
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
            StackedMapButton(),
            const SizedBox(
              height: 20,
            ),
            TrackCard(track: track),
            const SizedBox(
              height: 20,
            ),
            CarDetailsCard(),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
