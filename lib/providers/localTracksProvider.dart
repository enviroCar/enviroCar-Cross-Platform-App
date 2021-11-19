import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authProvider.dart';
import '../models/car.dart';
import '../models/track.dart';
import '../utils/snackBar.dart';
import '../models/pointProperties.dart';
import '../models/localTrackModel.dart';
import '../services/tracksServices.dart';
import '../exceptionHandling/result.dart';
import '../hiveDB/localTracksCollection.dart';

class LocalTracksProvider extends ChangeNotifier {
  List<Track> _tracksList;

  factory LocalTracksProvider() => _localTracksProvider;

  LocalTracksProvider._() {
    _tracksList = [];
    setLocalTracks();
  }

  static final LocalTracksProvider _localTracksProvider =
      LocalTracksProvider._();

  /// function to fetch [tracks] from the database and add them in [_tracksList]
  void setLocalTracks() {
    final list = LocalTracks.getLocalTracks();
    for (var i = 0; i < list.length; i++) {
      final Track track = encodeToTrack(list[i]);
      _tracksList.add(track);
      notifyListeners();
    }
  }

  /// function to encode [LocalTrackModel] to [Track]
  Track encodeToTrack(LocalTrackModel trackData) {
    final Track track = Track();
    track.id = trackData.getTrackId;
    track.length = trackData.getDistance;
    track.begin = trackData.getStartTime;
    track.end = trackData.getEndTime;

    final Car sensor = Car();

    sensor.type = "car";
    sensor.properties = trackData.getCarProperties;

    track.sensor = sensor;

    return track;
  }

  /// function to add [localTrack] to the database and save it
  void addLocalTrack(LocalTrackModel localTrackModel) {
    LocalTracks.saveTrack(localTrackModel);
    final Track track = encodeToTrack(localTrackModel);
    _tracksList.add(track);
    notifyListeners();
  }

  /// function to delete [track]
  void deleteLocalTrack(Track track, int index) {
    _tracksList.removeWhere((Track trackItem) => track.id == trackItem.id);
    LocalTracks.deleteTrack(index);
    notifyListeners();
  }

  /// function to get [_tracksList]
  List<Track> get getLocalTracks {
    return [..._tracksList];
  }

  /// function to upload local track to the server
  void uploadTrack(BuildContext context, int index) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final LocalTrackModel localTrackModel = LocalTracks.getTrackAtIndex(index);
    TracksServices()
        .postTrack(
            authProvider: _authProvider, localTrackModel: localTrackModel)
        .then((Result result) {
      if (result.status == ResultStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              result.exception.getErrorMessage(),
            ),
          ),
        );
      } else if (result.status == ResultStatus.success) {
        displaySnackBar(
            '${localTrackModel.getTrackName} uploaded successfully!');
      }
    });
  }

  /// function to export the track data as csv
  Future exportTrack(int index) async {
    final LocalTrackModel localTrackModel = LocalTracks.getTrackAtIndex(index);
    final List<PointProperties> properties =
        localTrackModel.getProperties.values.toList();

    await TracksServices().createExcel(
        trackName: localTrackModel.getTrackId, properties: properties);
  }
}
