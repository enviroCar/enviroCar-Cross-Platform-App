import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart' as dio;

import '../providers/authProvider.dart';
import '../providers/tracksProvider.dart';
import '../exceptionHandling/appException.dart';
import '../exceptionHandling/result.dart';
import '../exceptionHandling/errorHandler.dart';

class TracksServices {
  Future<Result> getTracks({
    @required AuthProvider authProvider,
    @required TracksProvider tracksProvider,
  }) async {
    const String uri = 'https://envirocar.org/api/stable/tracks';

    try {
      final dio.Response response = await dio.Dio().get(
        uri,
        options: dio.Options(
          headers: {
            'X-User': authProvider.getUser.getUsername,
            'X-Token': authProvider.getUser.getPassword,
          },
        ),
      );

      tracksProvider.setTracks(response.data as Map<String, dynamic>);

      return Result.success(response.data);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }
}
