import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/authProvider.dart';
import '../providers/tracksProvider.dart';

class TracksServices {
  Future<void> getTracks({
    @required AuthProvider authProvider,
    @required TracksProvider tracksProvider,
  }) async {
    const String uri = 'https://envirocar.org/api/stable/tracks';

    final http.Response response = await http.get(
      Uri.parse(uri),
      headers: {
        'X-User': authProvider.getUser.getUsername,
        'X-Token': authProvider.getUser.getPassword,
      },
    );

    tracksProvider.setTracks(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
