import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../providers/authProvider.dart';
import '../models/userStats.dart';
import '../providers/userStatsProvider.dart';
import '../models/envirocarStats.dart';

class StatsServices {
  final baseUri = 'https://envirocar.org/api/stable';

  // Fetches user stats
  Future<void> getUserStats({
    @required AuthProvider authProvider,
    @required UserStatsProvider userStatsProvider,
  }) async {
    final Uri uri = Uri.parse(
        '$baseUri/users/${authProvider.getUser.getUsername}/userStatistic');

    final http.Response response = await http.get(
      uri,
      headers: {
        'X-User': authProvider.getUser.getUsername,
        'X-Token': authProvider.getUser.getPassword,
      },
    );

    userStatsProvider.setUserStats =
        UserStats.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // Fetches general enviroCar stats
  Future<EnvirocarStats> getEnvirocarStats() async {
    final Uri uri = Uri.parse(baseUri);

    final http.Response response = await http.get(
      uri,
    );

    final dynamic responseBody = jsonDecode(response.body)['counts'];

    final int users = responseBody['users'] as int;
    final int tracks = responseBody['tracks'] as int;
    final int measurements = responseBody['measurements'] as int;

    return EnvirocarStats(
      users: users,
      tracks: tracks,
      measurements: measurements,
    );
  }
}
