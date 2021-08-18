import 'package:flutter/foundation.dart';

/// currently not used anywhere
///
/// it was initially used to show the stats of the enviroCar
/// which can also be found on the website
/// later it was removed as there was no need of them
class EnvirocarStats {
  int users;
  int tracks;
  int measurements;

  EnvirocarStats({
    @required this.users,
    @required this.tracks,
    @required this.measurements,
  });
}
