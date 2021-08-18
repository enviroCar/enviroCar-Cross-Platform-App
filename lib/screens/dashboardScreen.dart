import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../widgets/dashboardWidgets/statsWidget.dart';
import './bluetoothDevicesScreen.dart';
import '../widgets/dashboardWidgets/dashboardIconButton.dart';
import '../widgets/dashboardWidgets/dashboardCard.dart';
import '../constants.dart';
import '../models/car.dart';
import './mapScreen.dart';
import '../globals.dart';
import './carScreen.dart';
import '../providers/carsProvider.dart';
import '../widgets/button.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // keys used to focus the tooltip of instructions on specific widget
  final GlobalKey _userStats = GlobalKey();
  final GlobalKey _bluetooth = GlobalKey();
  final GlobalKey _obd = GlobalKey();
  final GlobalKey _car = GlobalKey();
  final GlobalKey _gps = GlobalKey();
  final GlobalKey _selectedObd = GlobalKey();
  final GlobalKey _selectedCar = GlobalKey();
  final GlobalKey _startTrack = GlobalKey();

  // context passed to show the instructions
  BuildContext showcaseContext;

  bool showWalkthrough;

  // dialog to ask whether to show the instructions or not
  void _showDialog() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(milliseconds: 200),
        () {
          showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: const Text(
                  'Hi and welcome to enviroCar! Do you want to take a quick tour of the app?',
                ),
                actions: [
                  //Skip button
                  TextButton(
                    onPressed: () {
                      preferences.setBool('showWalkthrough', false);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFFd71f1f),
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      beginWalkthrough();
                    },
                    child: const Text(
                      'Let\'s Go',
                      style: TextStyle(
                        color: kSpringColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // initializes the instructions
  void beginWalkthrough() {
    ShowCaseWidget.of(showcaseContext).startShowCase(
      [
        _userStats,
        _bluetooth,
        _obd,
        _car,
        _gps,
        _selectedObd,
        _selectedCar,
        _startTrack,
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    /// check whether user has opened the app the first time
    /// if yes then ask whether to show the instructions or not
    /// if not then don't show any dialogs or instructions
    showWalkthrough = preferences.getBool('showWalkthrough');
    if (showWalkthrough == null) {
      _showDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onComplete: (int index, GlobalKey<State<StatefulWidget>> key) {
        preferences.setBool('showWalkthrough', false);
      },
      builder: Builder(
        builder: (BuildContext showcaseCtx) {
          showcaseContext = showcaseCtx;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Widget that shows the stats of user
                Showcase(
                  key: _userStats,
                  title: 'Overall Statistics',
                  description:
                      'Displays stats of all the local and\nuploaded tracks',
                  child: StatsWidget(),
                ),

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
                    Showcase(
                      key: _bluetooth,
                      title: 'Bluetooth',
                      description:
                          'Indicates whether Bluetooth is\nturned on or not',
                      child: const DashboardIconButton(
                        routeName: BluetoothDevicesScreen.routeName,
                        assetName: 'assets/icons/bluetooth.svg',
                      ),
                    ),
                    Showcase(
                      key: _obd,
                      title: 'OBD',
                      description:
                          'Indicates whether an OBD device is\nconnected or not',
                      child: const DashboardIconButton(
                        routeName: BluetoothDevicesScreen.routeName,
                        assetName: 'assets/icons/smartphone.svg',
                      ),
                    ),
                    Showcase(
                      key: _car,
                      title: 'Car',
                      description: 'Indicates whether a car is selected or not',
                      child: const DashboardIconButton(
                        routeName: BluetoothDevicesScreen.routeName,
                        assetName: 'assets/icons/car.svg',
                      ),
                    ),
                    Showcase(
                      key: _gps,
                      title: 'GPS',
                      description: 'Indicates whether GPS is turned on or not',
                      child: const DashboardIconButton(
                        routeName: MapScreen.routeName,
                        assetName: 'assets/icons/gps.svg',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),

                // Bluetooth Card
                Showcase(
                  key: _selectedObd,
                  title: 'Selected OBD',
                  description:
                      'Shows the OBD device currently paired with the app',
                  child: const DashboardCard(
                    assetName: 'assets/icons/bluetooth.svg',
                    title: 'OBD-II V9',
                    subtitle: 'ELM327',
                    routeName: BluetoothDevicesScreen.routeName,
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),

                // Car Card
                Consumer<CarsProvider>(
                  builder: (_, carsProvider, child) {
                    final Car selectedCar = carsProvider.getSelectedCar;
                    return Showcase(
                      key: _selectedCar,
                      title: 'Selected Car',
                      description: 'Shows the currently selected car',
                      child: DashboardCard(
                        assetName: 'assets/icons/car.svg',
                        title: selectedCar == null
                            ? 'No car selected'
                            : '${selectedCar.properties.manufacturer}, ${selectedCar.properties.model}',
                        subtitle: selectedCar == null
                            ? 'Select a car'
                            : '${selectedCar.properties.constructionYear}, ${selectedCar.properties.engineDisplacement}, ${selectedCar.properties.fuelType}',
                        routeName: CarScreen.routeName,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.03,
                ),

                // Start Tracks Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Showcase(
                    key: _startTrack,
                    title: 'Start Button',
                    description:
                        'Starts recording the track when all indicators are set',
                    child: Button(
                      title: 'Start Track',
                      color: kSpringColor,
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
