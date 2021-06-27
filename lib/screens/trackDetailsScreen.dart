import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/track.dart';
import '../widgets/trackDetailsWidgets/stackedMapButton.dart';
import '../widgets/tracksScrrenWidgets/trackDetailsCard.dart';

class TrackDetailsScreen extends StatelessWidget {
  static const routeName = '/trackDetailsScreen';

  final Track track;

  TrackDetailsScreen({
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
            SizedBox(
              height: 20,
            ),
            TrackDetailsCard(
              track: track,
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
