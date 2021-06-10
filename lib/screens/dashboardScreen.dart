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
                  iconDate: Icons.bluetooth,
                ),
                DashboardIconButton(
                  routeName: BluetoothDevicesScreen.routeName,
                  iconDate: Icons.phone_android_sharp,
                ),
                DashboardIconButton(
                  routeName: BluetoothDevicesScreen.routeName,
                  iconDate: Icons.car_repair,
                ),
                DashboardIconButton(
                  routeName: MapScreen.routeName,
                  iconDate: Icons.gps_fixed,
                ),
              ],
            ),
            DashboardCard(
              iconData: Icons.bluetooth,
              title: 'OBD Link MX+ 509',
              subtitle: '00:04:3E',
            ),
            DashboardCard(
              iconData: Icons.car_repair,
              title: 'ALPHA ROMEO 509',
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
