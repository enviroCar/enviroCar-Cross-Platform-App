import 'package:flutter/material.dart';

import '../widgets/statsWidget.dart';
import './bluetoothDevicesScreen.dart';
import '../widgets/dashboardWidgets/dashboardIconButton.dart';
import '../widgets/dashboardWidgets/dashboardCard.dart';
import '../constants.dart';
import './mapScreen.dart';
import '../globals.dart';
import './carScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StatsWidget(),
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
                        fontSize: deviceHeight * 0.02,
                      ),
                    ),
                  ),
                  height: deviceHeight * 0.05,
                  width: deviceWidth * 0.5,
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
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            DashboardCard(
              assetName: 'assets/icons/bluetooth.svg',
              title: 'OBD-II V9',
              subtitle: 'ELM327',
              routeName: BluetoothDevicesScreen.routeName,
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            DashboardCard(
              assetName: 'assets/icons/car.svg',
              title: 'ALPHA ROMEO',
              subtitle: '2000, 1600cm',
              routeName: CarScreen.routeName,
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            GestureDetector(
              child: Container(
                child: Center(
                  child: Text(
                    'Start Track',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceHeight * 0.02,
                    ),
                  ),
                ),
                height: deviceHeight * 0.065,
                width: deviceWidth * 0.4,
                decoration: BoxDecoration(
                  color: kSpringColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
