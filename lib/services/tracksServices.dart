import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as dio;

import '../models/feature.dart';
import '../models/geometry.dart';
import '../models/phenomenons.dart';
import '../models/localTrackModel.dart';
import '../models/pointProperties.dart';
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
    final String uri = 'https://envirocar.org/api/stable/users/${authProvider.getUser.getUsername}/tracks';

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

  Future<Result> postTrack({
    @required AuthProvider authProvider,
    @required LocalTrackModel localTrackModel
  }) async {
    final String uri = 'https://envirocar.org/api/stable/users/${authProvider.getUser.getUsername}/tracks';

    try {
      final Map<String, String> properties = {
        'sensor' : "51c96afce4b0fd063432096f", // todo: change this hardcoded value 'localTrackModel.getCarId'
        'name': localTrackModel.getTrackName,
        'description': 'my track description' // todo: track description
      };

      final Map<int, PointProperties> pointProperties = localTrackModel.getProperties;

      final List<Map<String, dynamic>> featureObject = [];

      pointProperties.forEach((int key, PointProperties properties) {
        final Geometry geometry = Geometry(
            type: 'Point',
            latitude: properties.latitude,
            longitude: properties.longitude
        );

        final Phenomenons phenomenons = Phenomenons(
            consumption: properties.consumption,
            co2: properties.co2,
            speed: properties.speed,
            maf: properties.maf
        );

        final Feature feature = Feature(
            type: 'Feature',
            geometry: geometry,
            time: properties.time,
            phenomenons: phenomenons,
            sensorId: "51c96afce4b0fd063432096f" // todo: change this hardcoded value 'localTrackModel.getCarId'
        );

        featureObject.add(feature.toJSON());
      });

      final Map<String, dynamic> track = {
        'type': 'FeatureCollection',
        'properties': properties,
        'features': featureObject
      };

      final dio.Response response = await dio.Dio().post(
        uri,
        data: json.encode(track),
        options: dio.Options(
          headers: {
            'X-User': authProvider.getUser.getUsername,
            'X-Token': authProvider.getUser.getPassword,
          },
        ),
      );

      return Result.success(response.data);

    } catch(e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }
}
