import '../providers/bluetoothProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import '../widgets/dashboardWidgets/statsWidget.dart';

import './bluetoothDevicesScreen.dart';

import '../providers/bluetoothStatusProvider.dart';
import '../providers/locationStatusProvider.dart';
import '../widgets/dashboardWidgets/dashboardIconButton.dart';
import '../widgets/dashboardWidgets/dashboardCard.dart';
import '../constants.dart';
import './mapScreen.dart';
import '../globals.dart';
import './carScreen.dart';
import '../providers/carsProvider.dart';
import '../models/car.dart';
import '../utils/enums.dart';
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

              Consumer<BluetoothProvider>(
                builder: (context, bluetoothProvider, child) {
                  final bool isConnected = bluetoothProvider.isConnected();
                  return DashboardIconButton(
                    routeName: BluetoothDevicesScreen.routeName,
                    assetName: 'assets/icons/smartphone.svg',
                    buttonColor: isConnected ? kSpringColor : kErrorColor,
                  );
                }
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
          Consumer<BluetoothProvider>(
            builder: (context, bluetoothProvider, child) {
              final bool isConnected = bluetoothProvider.isConnected();
              DiscoveredDevice connectedDevice;
              if (isConnected) {
                connectedDevice = bluetoothProvider.getConnectedDevice;
              }

              return DashboardCard(
                assetName: 'assets/icons/bluetooth.svg',
                title: isConnected ? (connectedDevice.name.trim().isNotEmpty ? connectedDevice.name : 'Unknown Device') : 'No OBD-II adapter selected',
                subtitle: isConnected ? connectedDevice.id : 'Click here to select one',
                routeName: BluetoothDevicesScreen.routeName,
                iconBackgroundColor: isConnected ? kSpringColor : kErrorColor,
              );
            }
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
                iconBackgroundColor: carsProvider.getSelectedCar != null ? kSpringColor : kErrorColor,
              );
            },
          ),
          SizedBox(
            height: deviceHeight * 0.02,
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
