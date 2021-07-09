import 'package:flutter/foundation.dart';

import '../models/track.dart';

class TracksProvider with ChangeNotifier {
  List<Track> _tracks = [];

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
  }

  // Provides tracks data to widgets
  List<Track> getTracks() {
    return _tracks;
  }

  // Removes tracks when user logs out
  void removeTracks() {
    _tracks = [];
  }
}
