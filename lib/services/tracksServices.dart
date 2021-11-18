import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../models/feature.dart';
import '../utils/dateUtil.dart';
import '../models/geometry.dart';
import '../models/phenomenons.dart';
import 'secureStorageServices.dart';
import '../models/localTrackModel.dart';
import '../models/pointProperties.dart';
import '../providers/authProvider.dart';
import '../exceptionHandling/result.dart';
import '../providers/tracksProvider.dart';
import '../exceptionHandling/appException.dart';
import '../exceptionHandling/errorHandler.dart';

class TracksServices {
  /// function to get all the tracks uploaded by the currently signed in user
  Future<Result> getTracksFromServer({
    @required AuthProvider authProvider,
    @required TracksProvider tracksProvider,
  }) async {
    final String uri =
        'https://envirocar.org/api/stable/users/${authProvider.getUser.getUsername}/tracks';

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

  /// function to get track with specific id from the server
  Future<LocalTrackModel> getTrackWithId(String id) async {
    final User user = await SecureStorageServices().getUserFromSecureStorage();
    final String uri =
        'https://envirocar.org/api/stable/users/${user.getUsername}/tracks/$id';

    try {
      final dio.Response response = await dio.Dio().get(
        uri,
        options: dio.Options(
          headers: {
            'X-User': user.getUsername,
            'X-Token': user.getPassword,
          },
        ),
      );

      final Duration duration =
          formatDate(response.data['properties']['end'] as String).difference(
              formatDate(response.data['properties']['begin'] as String));

      final double time = duration.inHours +
          duration.inMinutes / 60 +
          duration.inSeconds / 3600;

      final Map<int, PointProperties> properties = {};
      final List feature = response.data['features'] as List<dynamic>;
      for (var i = 0; i < feature.length; i++) {
        final PointProperties pointProperties = PointProperties(
          latitude: feature[i]['geometry']['coordinates'][0] as double,
          longitude: feature[i]['geometry']['coordinates'][1] as double,
          time:
              formatDate(feature[i]['properties']['time'] as String).toString(),
          consumption: feature[i]['properties']['phenomenons']['Consumption']
              ['value'] as double,
          co2:
              feature[i]['properties']['phenomenons']['CO2']['value'] as double,
          speed: feature[i]['properties']['phenomenons']['Speed']['value']
              as double,
          maf:
              feature[i]['properties']['phenomenons']['MAF']['value'] as double,
        );
        properties[i + 1] = pointProperties;
      }

      final LocalTrackModel localTrackModel = LocalTrackModel(
        trackId: response.data['properties']['id'] as String,
        trackName: response.data['properties']['name'] as String,
        startTime: formatDate(response.data['properties']['begin'] as String),
        endTime: formatDate(response.data['properties']['end'] as String),
        duration: duration.toString().replaceFirst('.000000', ''),
        distance: response.data['properties']['length'] as double,
        speed: response.data['properties']['length'] / time as double,
        selectedCarId:
            response.data['properties']['sensor']['properties']['id'] as String,
        isTrackUploaded: true,
        properties: properties,
      );

      return localTrackModel;
    } catch (e) {
      handleException(e);
      return null;
    }
  }

  /// function to send a post request with track data to the server
  Future<Result> postTrack(
      {@required AuthProvider authProvider,
      @required LocalTrackModel localTrackModel}) async {
    final String uri =
        'https://envirocar.org/api/stable/users/${authProvider.getUser.getUsername}/tracks';

    try {
      final Map<String, String> properties = {
        'sensor': localTrackModel.getCarId,
        'name': localTrackModel.getTrackName,
        'description': 'my track description' // todo: track description
      };

      final Map<int, PointProperties> pointProperties =
          localTrackModel.getProperties;

      final List<Map<String, dynamic>> featureObject = [];

      pointProperties.forEach((int key, PointProperties properties) {
        final Geometry geometry = Geometry(
            type: 'Point',
            latitude: properties.latitude,
            longitude: properties.longitude);

        final Phenomenons phenomenons = Phenomenons(
            consumption: properties.consumption,
            co2: properties.co2,
            speed: properties.speed,
            maf: properties.maf);

        final Feature feature = Feature(
            type: 'Feature',
            geometry: geometry,
            time: properties.time,
            phenomenons: phenomenons,
            sensorId: localTrackModel.getCarId);

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
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }
}
