import 'package:flutter/material.dart';

import '../widgets/statsWidget.dart';
import './bluetoothDevicesScreen.dart';
import '../widgets/dashboardWidgets/dashboardIconButton.dart';
import '../widgets/dashboardWidgets/dashboardCard.dart';
import '../constants.dart';
import './mapScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    double _height = _mediaQuery.size.height;
    double _width = _mediaQuery.size.width;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StatsWidget(
              height: _height,
              width: _width,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
              ),
              child: GestureDetector(
                child: Container(
                  child: Center(
                    child: Text(
                      'Recording Settings',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    color: kSpringColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardIconButton(
                  routeName: BluetoothDevicesScreen.routeName,
                  assetName: 'assets/icons/bluetooth.svg',
                ),
                DashboardIconButton(
                  routeName: BluetoothDevicesScreen.routeName,
                  assetName: 'assets/icons/smartphone.svg',
                ),
                DashboardIconButton(
                  routeName: BluetoothDevicesScreen.routeName,
                  assetName: 'assets/icons/car.svg',
                ),
                DashboardIconButton(
                  routeName: MapScreen.routeName,
                  assetName: 'assets/icons/gps.svg',
                ),
              ],
            ),
            DashboardCard(
              height: _height,
              width: _width,
              assetName: 'assets/icons/bluetooth.svg',
              title: 'OBD-II V9',
              subtitle: 'ELM327',
            ),
            DashboardCard(
              height: _height,
              width: _width,
              assetName: 'assets/icons/car.svg',
              title: 'ALPHA ROMEO',
              subtitle: '2000, 1600cm',
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
              ),
              child: GestureDetector(
                child: Container(
                  child: Center(
                    child: Text(
                      'Start Track',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: kSpringColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
