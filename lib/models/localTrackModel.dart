class LocalTrackModel {
  int id;
  String trackName;
  DateTime modifiedTime;
  DateTime endTime;
  double distance;
  String duration;
  double speed;
  int selectedCarId;
  String isTrackUploaded;

  LocalTrackModel({
    this.id,
    this.trackName,
    this.modifiedTime,
    this.endTime,
    this.distance,
    this.duration,
    this.speed,
    this.selectedCarId,
    this.isTrackUploaded
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> trackData = <String, dynamic>{};
    trackData['id'] = id;
    trackData['trackName'] = trackName;
    trackData['modified'] = modifiedTime;
    trackData['endTime'] = endTime;
    trackData['distance'] = distance;
    trackData['duration'] = duration;
    trackData['speed'] = speed;
    trackData['carId'] = selectedCarId;
    trackData['trackIsUploaded'] = isTrackUploaded;
    return trackData;
  }
}