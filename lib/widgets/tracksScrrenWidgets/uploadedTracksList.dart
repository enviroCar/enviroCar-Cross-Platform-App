import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/track.dart';
import '../../providers/authProvider.dart';
import '../../providers/tracksProvider.dart';
import '../../services/tracksServices.dart';
import '../../widgets/tracksScrrenWidgets/trackCard.dart';

class UploadedTracksList extends StatefulWidget {
  @override
  _UploadedTracksListState createState() => _UploadedTracksListState();
}

class _UploadedTracksListState extends State<UploadedTracksList> {
  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final TracksProvider _tracksProvider =
        Provider.of<TracksProvider>(context, listen: false);

    return FutureBuilder(
      future: _tracksProvider.getTracks().isEmpty
          ? TracksServices().getTracks(
              authProvider: _authProvider,
              tracksProvider: _tracksProvider,
            )
          : null,
      builder: (_, snapShot) {
        if (snapShot.connectionState == ConnectionState.done ||
            _tracksProvider.getTracks().isNotEmpty) {
          return Consumer<TracksProvider>(
            builder: (_, tracksProvider, child) {
              final List<Track> tracksList = tracksProvider.getTracks();
              if (tracksList.isEmpty) {
                return const Center(
                  child: Text('No Tracks'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tracksList.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TrackCard(
                      track: tracksList[i],
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
