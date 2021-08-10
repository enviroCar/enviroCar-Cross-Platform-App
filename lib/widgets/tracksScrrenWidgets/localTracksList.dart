import 'package:flutter/material.dart';

import 'noTracksWidget.dart';

class LocalTracksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: NoTracksWidget(
        title: 'no local tracks',
        subTitle: 'You have 0 local tracks',
        iconData: Icons.map
      ),
    );
  }
}
