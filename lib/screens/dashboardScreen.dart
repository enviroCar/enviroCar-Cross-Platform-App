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
import '../widgets/button.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                height: deviceHeight * 0.05,
                width: deviceWidth * 0.5,
                decoration: BoxDecoration(
                  color: kSpringColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Recording Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceHeight * 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bluetooth, OBD, GPS and Car buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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

          // Bluetooth Card
          const DashboardCard(
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
              final Car selectedCar = carsProvider.getSelectedCar;
              return DashboardCard(
                assetName: 'assets/icons/car.svg',
                title: selectedCar == null
                    ? 'No car selected'
                    : '${selectedCar.manufacturer}, ${selectedCar.model}',
                subtitle: selectedCar == null
                    ? 'Select a car'
                    : '${selectedCar.constructionYear}, ${selectedCar.engineDisplacement}, ${selectedCar.fuelType}',
                routeName: CarScreen.routeName,
              );
            },
          ),
          SizedBox(
            height: deviceHeight * 0.03,
          ),

          // Start Tracks Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Button(
              title: 'Start Track',
              color: kSpringColor,
              onTap: () {},
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
        ],
      ),
    );
  }
}
