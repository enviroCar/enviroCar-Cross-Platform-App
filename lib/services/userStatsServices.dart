import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../providers/authProvider.dart';
import '../models/userStats.dart';
import '../providers/userStatsProvider.dart';

class UserStatsServices {
  final baseUri = 'https://envirocar.org/api/stable/users';

  Future<void> getUserStats({
    @required AuthProvider authProvider,
    @required UserStatsProvider userStatsProvider,
  }) async {
    final Uri uri = Uri.parse(
        baseUri + '/' + authProvider.getUser.getUsername + '/userStatistic');

    http.Response response = await http.get(
      uri,
      headers: {
        'X-User': authProvider.getUser.getUsername,
        'X-Token': authProvider.getUser.getPassword,
      },
    );

    userStatsProvider.setUserStats =
        UserStats.fromJson(jsonDecode(response.body));
  }
}
