import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../providers/authProvider.dart';

class TracksServices {
  Stream<http.Response> getTracks({@required AuthProvider authProvider}) {
    final String uri = 'https://envirocar.org/api/stable/tracks';

    Stream<http.Response> resStream = http.get(
      Uri.parse(uri),
      headers: {
        'X-User': authProvider.getUser.getUsername,
        'X-Token': authProvider.getUser.getPassword,
      },
    ).asStream();

    return resStream;
  }
}
