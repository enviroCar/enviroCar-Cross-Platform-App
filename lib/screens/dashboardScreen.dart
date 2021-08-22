import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:logger/logger.dart';
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
import '../utils/enums.dart';
import '../providers/bluetoothStatusProvider.dart';
import '../providers/locationStatusProvider.dart';
import '../providers/bluetoothProvider.dart';
import '../widgets/button.dart';
import '../utils/customAlertDialog.dart';
import './gpsTrackingScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true
    ),
  );

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
                      buttonColor: provider.bluetoothState ==
                          BluetoothConnectionStatus.ON
                          ? kSpringColor
                          : kErrorColor,
                    );
                  }
              ),
              Consumer<BluetoothProvider>(
                  builder: (context, provider, child) {
                    final bool isConnected = provider.isConnected();

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
                    routeName: CarScreen.routeName,
                    assetName: 'assets/icons/car.svg',
                    buttonColor: provider.getSelectedCar != null
                        ? kSpringColor
                        : kErrorColor,
                  );
                },
              ),
              Consumer<LocationStatusProvider>(
                builder: (context, provider, child) {
                  return DashboardIconButton(
                    routeName: MapScreen.routeName,
                    assetName: 'assets/icons/gps.svg',
                    buttonColor: provider.locationState ==
                        LocationStatus.enabled ? kSpringColor : kErrorColor,
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
              BluetoothDevice connectedDevice;
              if (isConnected) {
                connectedDevice = bluetoothProvider.getConnectedDevice;
              }

              return DashboardCard(
                assetName: 'assets/icons/bluetooth.svg',
                title: isConnected ? (connectedDevice.name.isNotEmpty
                    ? connectedDevice.name
                    : 'Unknown Device') : 'No OBD-II adapter selected',
                subtitle: isConnected
                    ? connectedDevice.id.toString()
                    : 'Click here to select one',
                routeName: BluetoothDevicesScreen.routeName,
                iconBackgroundColor: isConnected ? kSpringColor : kErrorColor,
              );
            },
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
                    : '${selectedCar.constructionYear}, ${selectedCar
                    .engineDisplacement}, ${selectedCar.fuelType}',
                routeName: CarScreen.routeName,
                iconBackgroundColor: carsProvider.getSelectedCar != null
                    ? kSpringColor
                    : kErrorColor,
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
              onTap: () {
                final locationProvider = Provider.of<LocationStatusProvider>(context, listen: false);
                final carsProvider = Provider.of<CarsProvider>(context, listen: false);
                final bluetoothProvider = Provider.of<BluetoothProvider>(context, listen: false);

                if (locationProvider.locationState == LocationStatus.enabled &&
                    carsProvider.getSelectedCar != null &&
                    bluetoothProvider.isConnected()) {
                  _logger.i('Going to GPS tracking screen');
                  Navigator.pushNamed(context, GpsTrackingScreen.routeName);
                }
                else {
                  const String title = 'Cannot start GPS tracking';
                  String content = ' ';
                  bool carState = true, locationState = true, bluetoothState = true;
                  if (locationProvider.locationState == LocationStatus.disabled && carsProvider.getSelectedCar == null && !bluetoothProvider.isConnected()) {
                    content = 'Please turn on location, select a car and connect to OBD-II adapter to start recording your track.';
                    locationState = false;
                    carState = false;
                    bluetoothState = false;
                  }
                  else if (carsProvider.getSelectedCar == null && !bluetoothProvider.isConnected()) {
                    content = 'Please select a car and connect to OBD-II adapter to start recording your track.';
                    carState = false;
                    bluetoothState = false;
                  }
                  else if (carsProvider.getSelectedCar == null && locationProvider.locationState == LocationStatus.disabled) {
                    content = 'Please turn on location and select a car to start recording your track.';
                    locationState = false;
                    carState = false;
                  }
                  else if (locationProvider.locationState == LocationStatus.disabled && !bluetoothProvider.isConnected()) {
                    content = 'Please turn on location and connect to OBD-II adapter to start recording your track.';
                    locationState = false;
                    bluetoothState = false;
                  }
                  else if (!bluetoothProvider.isConnected()) {
                    content = 'Please connect to OBD-II adapter to start recording your track.';
                    bluetoothState = false;
                  }
                  else if (carsProvider.getSelectedCar == null) {
                    content = 'Please select a car to start recording your track.';
                    carState = false;
                  }
                  else if (locationProvider.locationState == LocationStatus.disabled) {
                    content = 'Please turn on location services to start recording your track.';
                    locationState = false;
                  }
                  showAlertDialog(
                    context: context,
                    title: title,
                    content: content,
                    carState: carState,
                    locationState: locationState,
                    bluetoothState: bluetoothState
                  );
                }
              },
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
