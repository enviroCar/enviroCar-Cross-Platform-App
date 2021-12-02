import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/localTrackModel.dart';

mixin LocalTracks {
  /// function to add [track] to the hive box
  static void saveTrack(LocalTrackModel localTrackModel) {
    final tracksBox = Hive.box<LocalTrackModel>(localTracksTableName);
    tracksBox.add(localTrackModel);
  }

  /// function to return list of local tracks
  static List<LocalTrackModel> getLocalTracks() {
    final tracksBox = Hive.box<LocalTrackModel>(localTracksTableName);
    final List<LocalTrackModel> list = [];
    final int size = tracksBox.length;
    for (var i = 0; i < size; i++) {
      list.add(tracksBox.getAt(i));
    }
    return list;
  }

  /// function to delete track
  static void deleteTrack(int index) {
    final tracksBox = Hive.box<LocalTrackModel>(localTracksTableName);
    tracksBox.deleteAt(index);
  }

  /// function to get [track] at index [index]
  static LocalTrackModel getTrackAtIndex(int index) {
    final tracksBox = Hive.box<LocalTrackModel>(localTracksTableName);
    return tracksBox.getAt(index);
  }
}
