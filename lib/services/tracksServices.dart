import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../models/user.dart';
import '../models/feature.dart';
import '../utils/dateUtil.dart';
import '../models/geometry.dart';
import 'secureStorageServices.dart';
import '../models/phenomenons.dart';
import '../models/localTrackModel.dart';
import '../models/pointProperties.dart';
import '../providers/authProvider.dart';
import '../exceptionHandling/result.dart';
import '../providers/tracksProvider.dart';
import '../exceptionHandling/errorHandler.dart';
import '../exceptionHandling/appException.dart';

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
        formatDate(response.data['properties']['begin'] as String),
      );

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
  Future<Result> postTrack({
    @required AuthProvider authProvider,
    @required LocalTrackModel localTrackModel,
  }) async {
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
          longitude: properties.longitude,
        );

        final Phenomenons phenomenons = Phenomenons(
          consumption: properties.consumption,
          co2: properties.co2,
          speed: properties.speed,
          maf: properties.maf,
        );

        final Feature feature = Feature(
          type: 'Feature',
          geometry: geometry,
          time: properties.time,
          phenomenons: phenomenons,
          sensorId: localTrackModel.getCarId,
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
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }

  /// function to create an excel file and export the track data
  Future createExcel({
    @required String trackName,
    @required List<PointProperties> properties,
    bool altitudeData = true,
  }) async {
    // create a workbook with one sheet
    final Workbook workbook = Workbook();
    // use workbook to get one worksheet
    final Worksheet worksheet = workbook.worksheets[0];

    // label the columns for latitude, longitude and altitude
    const String latitudeColumn = 'A';
    const String longitudeColumn = 'B';
    const String altitudeColumn = 'C';

    // from uploaded tracks the altitude value is not fetched (neither uploaded)
    if (altitudeData) {
      worksheet.getRangeByName('${altitudeColumn}1').setText('Altitude');
    }

    worksheet.getRangeByName('${latitudeColumn}1').setText('Latitude');
    worksheet.getRangeByName('${longitudeColumn}1').setText('Longitude');

    // write the data to the worksheet
    int index = 2;
    for (int i = 0; i < properties.length; i++) {
      worksheet
          .getRangeByName('$latitudeColumn$index')
          .setNumber(properties[i].latitude);
      worksheet
          .getRangeByName('$longitudeColumn$index')
          .setNumber(properties[i].longitude);
      if (altitudeData) {
        worksheet
            .getRangeByName('$altitudeColumn$index')
            .setNumber(properties[i].altitude);
      }
      index++;
    }

    // save the workbook
    final List<int> bytes = workbook.saveAsStream();
    // dispose the workbook to release the resources used by it
    workbook.dispose();

    // save the path where excel file is stored
    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/$trackName.xlsx';
    final File file = File(fileName);
    // write data to the file
    await file.writeAsBytes(bytes, flush: true);
    // open the file
    OpenFile.open(fileName);
  }
}
