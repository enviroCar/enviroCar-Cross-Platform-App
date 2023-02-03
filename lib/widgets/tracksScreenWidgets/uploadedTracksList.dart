import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'noLocalTracks.dart';
import '../../constants.dart';
import '../../models/track.dart';
import '../../providers/authProvider.dart';
import '../../services/tracksServices.dart';
import '../../providers/tracksProvider.dart';
import '../../exceptionHandling/result.dart';
import '../../widgets/tracksScreenWidgets/uploadedTrackCard.dart';

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

    return Consumer<TracksProvider>(
      builder: (_, tracksProvider, child) {
        final List<Track> tracksList = tracksProvider.getTracks();
        if (tracksList == null) {
          TracksServices()
              .getTracksFromServer(
            authProvider: _authProvider,
            tracksProvider: _tracksProvider,
          )
              .then(
            (Result result) {
              if (result.status == ResultStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: kErrorColor,
                    content: Text(
                      result.exception!.getErrorMessage()!,
                    ),
                  ),
                );
              }
            },
          );

          return const CircularProgressIndicator();
        } else if (tracksList.isEmpty) {
          return const NoTracksWidget(
            title: 'no tracks uploaded',
            subTitle: 'You have 0 uploaded tracks',
            iconData: Icons.location_history_rounded,
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tracksList.length,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: UploadedTrackCard(
                  track: tracksList[i],
                  index: i,
                ),
              );
            },
          );
        }
      },
    );
  }
}
