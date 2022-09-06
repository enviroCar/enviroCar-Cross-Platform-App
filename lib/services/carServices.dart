import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import '../providers/authProvider.dart';
import '../providers/carsProvider.dart';
import '../exceptionHandling/result.dart';
import '../exceptionHandling/errorHandler.dart';
import '../exceptionHandling/appException.dart';

class CarServices {
  // Not used anywhere because the cars don't get stored in the user's account
  // unless a track is created with that car
  Future<Result> getCars({@required BuildContext context}) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final CarsProvider carsProvider =
        Provider.of<CarsProvider>(context, listen: false);

    final String username = authProvider.getUser.getUsername;
    final String token = authProvider.getUser.getPassword;

    final String uri =
        'https://envirocar.org/api/stable/users/$username/sensors';

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

      final List<dynamic> carsData = response.data['sensors'] as List<dynamic>;

      carsProvider.setCarsList = carsData;

      return Result.success(response.data);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }

  Future<Result> uploadCarToServer({
    @required BuildContext context,
    @required Car car,
  }) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final String username = authProvider.getUser.getUsername;
    final String token = authProvider.getUser.getPassword;

    final String uri =
        'https://envirocar.org/api/stable/users/$username/sensors';

    try {
      final dio.Response response = await dio.Dio().post(
        uri,
        options: dio.Options(
          headers: {
            'X-User': username,
            'X-Token': token,
          },
        ),
        data: car.toJson(),
      );

      // Get the uploaded car's ID from headers and store it as the result's value
      final String locationLink = response.headers['location'][0];
      final List<String> locationList = locationLink.split('/');
      final String carID = locationList.last;

      return Result.success(carID);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }
}
