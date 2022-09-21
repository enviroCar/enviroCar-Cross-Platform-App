import 'package:dio/dio.dart' as dio;
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../models/fueling.dart';
import '../providers/authProvider.dart';
import '../exceptionHandling/result.dart';
import '../hiveDB/fuelingsCollection.dart';
import '../providers/fuelingsProvider.dart';
import '../exceptionHandling/errorHandler.dart';
import '../exceptionHandling/appException.dart';

class FuelingServices {
  Future<Result> getFuelingsFromServer({@required BuildContext context}) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final FuelingsProvider fuelingsProvider =
        Provider.of<FuelingsProvider>(context, listen: false);

    final String username = authProvider.getUser.getUsername;
    final String token = authProvider.getUser.getPassword;

    final String uri =
        'https://envirocar.org/api/stable/users/$username/fuelings';

    try {
      final dio.Response response = await dio.Dio().get(
        uri,
        options: dio.Options(
          headers: {
            'X-User': username,
            'X-Token': token,
          },
        ),
      );

      // save the data fetched to Hive to remove any data difference between the two
      for (final dynamic fuelingMap in response.data['fuelings']) {
        fuelingMap['username'] = username;
        FuelingsCollection().addFuelingToHive(fueling: fuelingMap);
      }

      // set the data to provider
      fuelingsProvider.setFuelingsList =
          response.data['fuelings'] as List<dynamic>;

      return Result.success(response.data);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }

  Future<Result> uploadFuelingToServer({
    @required BuildContext context,
    @required Fueling fueling,
  }) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final String username = authProvider.getUser.getUsername;
    final String token = authProvider.getUser.getPassword;

    final String uri =
        'https://envirocar.org/api/stable/users/$username/fuelings';

    try {
      final dio.Response response = await dio.Dio().post(
        uri,
        options: dio.Options(
          headers: {
            'X-User': username,
            'X-Token': token,
          },
        ),
        data: fueling.toJson(),
      );

      final String locationLink = response.headers['location'][0];
      final List<String> locationList = locationLink.split('/');
      final String fuelingID = locationList.last;

      return Result.success(fuelingID);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }
}
