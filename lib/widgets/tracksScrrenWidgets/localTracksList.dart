import 'package:envirocar_app_main/widgets/tracksScrrenWidgets/localTrackCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'trackCard.dart';
import '../../models/track.dart';
import '../../providers/localTracksProvider.dart';

class LocalTracksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalTracksProvider>(
      builder: (context, localTracksProvider, child) {
        final List<Track> trackList = localTracksProvider.getLocalTracks;
        if (trackList.isEmpty) {
          return const Center(
            child: Text('No Tracks Here'),
          );
        }
        else {
          return ListView.builder(
            itemCount: trackList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: LocalTrackCard(
                  track: trackList[index],
                  index: index,
                ),
              );
            });
        }
      }
    );
  }
}
