import 'package:flutter/material.dart';

import '../models/track.dart';
import '../database/carsTable.dart';
import '../database/databaseHelper.dart';
import '../database/tracksTable.dart';
import '../models/properties.dart';
import '../models/sensor.dart';

class LocalTracksProvider extends ChangeNotifier {
  List<Track> _tracksList;

  LocalTracksProvider() {
    setLocalTracks();
  }

  Future setLocalTracks() async {
    final List<Map<String, dynamic>> records = await DatabaseHelper.instance.readAllValues(tableName: TracksTable.tableName);
    for (final Map<String, dynamic> data in records) {
      final Track _track = await encodeToTrack(data);
      _tracksList.add(_track);
      notifyListeners();
    }
  }

  Future<Track> encodeToTrack(Map<String, dynamic> trackData) async {
    final Track track = Track();
    track.id = trackData['id'] as String;
    track.length = 5.0; // TODO: change this to actual distance
    track.begin = trackData['modified'] as DateTime;
    track.end = trackData['endTime'] as DateTime;

    final Sensor sensor = Sensor();
    final readResult = await DatabaseHelper.instance.readValue(tableName: CarsTable.tableName, id: trackData['carId'] as String);
    final Map<String, dynamic> carData = readResult.first;

    sensor.type = "car";
    sensor.properties = Properties.fromJson(carData);

    track.sensor = sensor;

    return track;
  }

  void addLocalTrack(Track track) {
    _tracksList.add(track);
    notifyListeners();
  }

  void deleteLocalTrack(Track track) {
    _tracksList.removeWhere((Track trackItem) => track.id == trackItem.id);
    notifyListeners();
  }

  void decodeTrack(Map<String, dynamic> localTrackData) {
    DatabaseHelper.instance.insertValue(tableName: TracksTable.tableName, data: localTrackData);
  }

  List<Track> get getLocalTracks => [..._tracksList];

}