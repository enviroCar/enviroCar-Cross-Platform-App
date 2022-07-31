import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/track.dart';
import '../models/localTrackModel.dart';
import '../models/pointProperties.dart';
import '../services/tracksServices.dart';

class TracksProvider with ChangeNotifier {
  List<Track> _tracks;
  List<LocalTrackModel> uploadedTracksList;
  bool uploadedTrackListSet = false;

  // Converts JSON tracks data from server to list
  // and notifies widgets once done
  void setTracks(Map<String, dynamic> json) {
    if (json['tracks'] != null) {
      final List<Track> tracks = [];
      json['tracks'].forEach((v) {
        tracks.add(Track.fromJson(v as Map<String, dynamic>));
      });

      _tracks = tracks;

      notifyListeners();
    }
    setTrackData();
  }

  /// function to fetch [track] with [track.id] from the server and add them to [uploadedTracksList]
  Future setTrackData() async {
    final List<LocalTrackModel> list = [];
    List<Track> validTracks = [];
    for (final Track track in _tracks) {
      final LocalTrackModel trackModel =
          await TracksServices().getTrackWithId(track.id);
      if (trackModel != null && trackModel.properties != null) {
        list.add(trackModel);
        validTracks.add(track);
      }
    }

    _tracks = validTracks;
    uploadedTracksList = list;
    uploadedTrackListSet = true;
    notifyListeners();
  }

  /// function to export the track data as csv
  // ignore: avoid_positional_boolean_parameters
  Future exportTrack(int index, bool altitudeData) async {
    final LocalTrackModel localTrackModel = uploadedTracksList[index];
    final List<PointProperties> properties =
        localTrackModel.getProperties.values.toList();

    await TracksServices().createExcel(
      trackName: localTrackModel.getTrackId,
      properties: properties,
      altitudeData: altitudeData,
    );
  }

  // Provides tracks data to widgets
  List<Track> getTracks() {
    return _tracks;
  }

  // Removes tracks when user logs out
  void removeTracks() {
    _tracks = [];
  }

  /// function to get the status of fetching of tracks with id
  bool get getListSetStatus => uploadedTrackListSet;

  /// function to get [uploadedTracksList]
  List<LocalTrackModel> getTracksWithId() {
    return [...uploadedTracksList];
  }
}
