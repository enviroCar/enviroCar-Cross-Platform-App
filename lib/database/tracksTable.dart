class TracksTable {
  static const String tableName = 'Tracks';

  static const String id = 'id';
  static const String trackName = 'trackName';
  static const String modifiedTime = 'modified';
  static const String endTime = 'endTime';
  static const String distance = 'distance';
  static const String duration = 'duration';
  static const String speed = 'speed';
  static const String carId = 'carId';
  static const String trackUploaded = 'trackIsUploaded';

  static const String localTrackCreateTableQuery = '''
      create table $tableName (
        $id integer primary key autoincrement,
        $trackName text not null,
        $modifiedTime text not null,
        $endTime text not null,
        $distance real,
        $duration text not null,
        $speed real,
        $carId integer not null,
        $trackUploaded text)
  ''';

}