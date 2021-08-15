import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart' as dio;

import '../providers/authProvider.dart';
import '../providers/tracksProvider.dart';
import '../exceptionHandling/appException.dart';
import '../exceptionHandling/result.dart';
import '../exceptionHandling/errorHandler.dart';

class TracksServices {
  Future<Result> getTracksFromServer({
    @required AuthProvider authProvider,
    @required TracksProvider tracksProvider,
  }) async {
    final String username = authProvider.getUser.getUsername;

    final String uri =
        'https://envirocar.org/api/stable/users/$username/tracks';

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

  Future<Result> getTrackFromID({@required String trackID}) async {
    final String uri = 'https://envirocar.org/api/stable/tracks/$trackID';

    try {
      final dio.Response response = await dio.Dio().get(
        uri,
      );

      return Result.success(response.data);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }
}
