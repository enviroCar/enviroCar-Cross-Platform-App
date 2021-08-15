import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';
import '../widgets/trackDetailsWidgets/chartWidget.dart';
import '../models/chartData.dart';

class ChartScreen extends StatefulWidget {
  final Map<String, dynamic> track;

  const ChartScreen({@required this.track});

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  ChartData speedChartData = ChartData();
  ChartData consumptionChartData = ChartData();
  ChartData co2ChartData = ChartData();
  ChartData altitudeChartData = ChartData();
  ChartData gpsAltitudeChartData = ChartData();

  List<double> dists = [];
  double totalDist = 0;
  double distanceInterval;

  void pullDataFromTrack(
      {@required String dataName, @required ChartData chartData}) {
    double data;
    double maxData = 0;

    final List<double> dataList = [];

    final List<dynamic> featuresList =
        widget.track['features'] as List<dynamic>;

    for (final dynamic feature in featuresList) {
      final Map<String, dynamic> dataMap = feature['properties']['phenomenons']
          [dataName] as Map<String, dynamic>;

      if (dataMap == null) {
        continue;
      }

      data = dataMap['value'] as double;

      if (data > maxData) {
        maxData = data;
      }

      dataList.add(data);
    }

    chartData.dataInterval = maxData / 10;

    for (int i = 0; i < min(dists.length, dataList.length); i++) {
      final FlSpot newSpot = FlSpot(
          dists[i] / distanceInterval, dataList[i] / chartData.dataInterval);
      chartData.dataPoints.add(newSpot);
    }
  }

  void pullDistanceData() {
    List<dynamic> prevCoord;

    final List<dynamic> featuresList =
        widget.track['features'] as List<dynamic>;

    for (final dynamic feature in featuresList) {
      if (prevCoord != null) {
        final List<dynamic> currCoord =
            feature['geometry']['coordinates'] as List<dynamic>;
        final double distanceInMeters = Geolocator.distanceBetween(
          double.parse(prevCoord[0].toString()),
          double.parse(prevCoord[1].toString()),
          double.parse(currCoord[0].toString()),
          double.parse(currCoord[1].toString()),
        );

        totalDist += distanceInMeters / 1000;

        dists.add(totalDist);

        prevCoord = currCoord;
      } else {
        prevCoord = feature['geometry']['coordinates'] as List<dynamic>;
      }
    }

    distanceInterval = totalDist / 20;
  }

  @override
  void initState() {
    super.initState();

    pullDistanceData();
    pullDataFromTrack(
      dataName: 'Speed',
      chartData: speedChartData,
    );
    pullDataFromTrack(
      dataName: 'Consumption',
      chartData: consumptionChartData,
    );
    pullDataFromTrack(
      dataName: 'CO2',
      chartData: co2ChartData,
    );
    pullDataFromTrack(
      dataName: 'Altitude',
      chartData: altitudeChartData,
    );
    pullDataFromTrack(
      dataName: 'GPS Altitude',
      chartData: gpsAltitudeChartData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        // enviroCar logo
        title: const Text('Track Statistics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (speedChartData.dataPoints.isNotEmpty)
              ChartWidget(
                chartTitle: 'Speed',
                xInterval: distanceInterval,
                chartData: speedChartData,
              ),
            if (consumptionChartData.dataPoints.isNotEmpty)
              ChartWidget(
                chartTitle: 'Consumption',
                xInterval: distanceInterval,
                chartData: consumptionChartData,
              ),
            if (co2ChartData.dataPoints.isNotEmpty)
              ChartWidget(
                chartTitle: 'CO2',
                xInterval: distanceInterval,
                chartData: co2ChartData,
              ),
            if (altitudeChartData.dataPoints.isNotEmpty)
              ChartWidget(
                chartTitle: 'Altitude',
                xInterval: distanceInterval,
                chartData: altitudeChartData,
              ),
            if (gpsAltitudeChartData.dataPoints.isNotEmpty)
              ChartWidget(
                chartTitle: 'GPS Altitude',
                xInterval: distanceInterval,
                chartData: gpsAltitudeChartData,
              ),
          ],
        ),
      ),
    );
  }
}
