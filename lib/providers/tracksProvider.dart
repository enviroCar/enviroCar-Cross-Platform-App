import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/track.dart';
import '../models/localTrackModel.dart';
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

  Future setTrackData() async {
    final List<LocalTrackModel> list = [];
    for (final Track track in _tracks) {
      final LocalTrackModel trackModel = await TracksServices().getTrackWithId(track.id);
      list.add(trackModel);
    }
    uploadedTracksList = list;
    uploadedTrackListSet = true;
    notifyListeners();
  }

  // Provides tracks data to widgets
  List<Track> getTracks() {
    return _tracks;
  }

  // Removes tracks when user logs out
  void removeTracks() {
    _tracks = [];
  }

  bool get getListSetStatus => uploadedTrackListSet;

  List<LocalTrackModel> getTracksWithId() {
    return [...uploadedTracksList];
  }
}
