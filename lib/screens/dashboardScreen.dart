import 'package:envirocar_app_main/models/enums/bluetoothConnectionStatus.dart';
import 'package:envirocar_app_main/models/enums/locationStatus.dart';
import 'package:envirocar_app_main/providers/bluetoothStatusProvider.dart';
import 'package:envirocar_app_main/providers/locationStatusProvider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/dashboardWidgets/statsWidget.dart';
import './bluetoothDevicesScreen.dart';
import '../widgets/dashboardWidgets/dashboardIconButton.dart';
import '../widgets/dashboardWidgets/dashboardCard.dart';
import '../constants.dart';
import './mapScreen.dart';
import '../globals.dart';
import './carScreen.dart';
import '../providers/carsProvider.dart';
import '../models/car.dart';

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
            // Widget that shows the stats of user
            StatsWidget(),

            // Record Settings Button
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

            // Bluetooth, OBD, GPS and Car buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<BluetoothStatusProvider>(
                  builder: (context, provider, child) {
                    return DashboardIconButton(
                      routeName: BluetoothDevicesScreen.routeName,
                      assetName: 'assets/icons/bluetooth.svg',
                      buttonColor: provider.bluetoothState == BluetoothConnectionStatus.ON ? kSpringColor : kErrorColor,
                    );
                  },
                ),
                DashboardIconButton(
                  routeName: BluetoothDevicesScreen.routeName,
                  assetName: 'assets/icons/smartphone.svg',
                ),
                Consumer<CarsProvider>(
                  builder: (context, provider, child) {
                    return DashboardIconButton(
                      routeName: BluetoothDevicesScreen.routeName,
                      assetName: 'assets/icons/car.svg',
                      buttonColor: provider.getSelectedCar != null ? kSpringColor : kErrorColor,
                    );
                  },
                ),
                Consumer<LocationStatusProvider>(
                  builder: (context, provider, child) {
                    return DashboardIconButton(
                      routeName: MapScreen.routeName,
                      assetName: 'assets/icons/gps.svg',
                      buttonColor: provider.locationState == LocationStatus.enabled ? kSpringColor : kErrorColor,
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),

            // Bluetooth Card
            DashboardCard(
              assetName: 'assets/icons/bluetooth.svg',
              title: 'OBD-II V9',
              subtitle: 'ELM327',
              routeName: BluetoothDevicesScreen.routeName,
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),

            // Car Card
            Consumer<CarsProvider>(
              builder: (_, carsProvider, child) {
                Car selectedCar = carsProvider.getSelectedCar;
                return DashboardCard(
                  assetName: 'assets/icons/car.svg',
                  title: selectedCar == null
                      ? 'No car selected'
                      : '${selectedCar.manufacturer}, ${selectedCar.model}',
                  subtitle: selectedCar == null
                      ? 'Select a car'
                      : '${selectedCar.constructionYear}, ${selectedCar.engineDisplacement}, ${selectedCar.fuelType}',
                  routeName: CarScreen.routeName,
                  iconBackgroundColor: carsProvider.getSelectedCar != null ? kSpringColor : kErrorColor,
                );
              },
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),

            // Start Tracks Button
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
