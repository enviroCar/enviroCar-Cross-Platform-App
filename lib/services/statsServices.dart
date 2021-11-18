import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/userStats.dart';
import '../providers/authProvider.dart';
import '../exceptionHandling/result.dart';
import '../providers/userStatsProvider.dart';
import '../exceptionHandling/errorHandler.dart';
import '../exceptionHandling/appException.dart';

class StatsServices {
  final baseUri = 'https://envirocar.org/api/stable';

  // Fetches user stats
  Future<Result> getUserStats({@required BuildContext context}) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final UserStatsProvider userStatsProvider =
        Provider.of<UserStatsProvider>(context, listen: false);

    try {
      final dio.Response response = await dio.Dio().get(
        '$baseUri/users/${authProvider.getUser.getUsername}/userStatistic',
        options: dio.Options(
          headers: {
            'X-User': authProvider.getUser.getUsername,
            'X-Token': authProvider.getUser.getPassword,
          },
        ),
      );

      userStatsProvider.setUserStats =
          UserStats.fromJson(response.data as Map<String, dynamic>);

      return Result.success(response.data);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }
}
