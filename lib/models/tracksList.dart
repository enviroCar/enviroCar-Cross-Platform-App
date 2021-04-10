import '../models/track.dart';

class TracksList {
  List<Track> tracksList = [];

  TracksList({this.tracksList});

  TracksList.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['tracks'];

    if (list != null) {
      Track track;
      for (int i = 0; i < list.length; i++) {
        track = Track.fromJson(json['tracks'][i]);

        tracksList.add(track);
      }
    }
  }
}
