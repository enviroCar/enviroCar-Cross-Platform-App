import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../globals.dart';
import './mapScreen.dart';
import './carScreen.dart';
import '../constants.dart';
import '../models/car.dart';
import '../utils/enums.dart';
import 'gpsTrackingScreen.dart';
import '../widgets/button.dart';
import './bluetoothDevicesScreen.dart';
import '../providers/carsProvider.dart';
import '../utils/customAlertDialog.dart';
import '../providers/bluetoothProvider.dart';
import '../providers/locationStatusProvider.dart';
import '../providers/bluetoothStatusProvider.dart';
import '../widgets/dashboardWidgets/statsWidget.dart';
import '../widgets/dashboardWidgets/dashboardCard.dart';
import '../widgets/dashboardWidgets/dashboardIconButton.dart';
import '../widgets/dashboardWidgets/recordingInformationDialogBox.dart';

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
  late BuildContext showcaseContext;

  bool? showWalkThrough = false;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

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
                      beginWalkThrough();
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
  void beginWalkThrough() {
    ShowCaseWidget.of(showcaseContext)!.startShowCase(
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
    showWalkThrough = preferences.getBool('showWalkThrough');
    if (showWalkThrough == null) {
      _showDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onComplete: (int? index, GlobalKey<State<StatefulWidget>> key) {
        preferences.setBool('showWalkThrough', false);
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
                      child: Consumer<BluetoothStatusProvider>(
                        builder: (context, provider, child) {
                          return DashboardIconButton(
                            routeName: BluetoothDevicesScreen.routeName,
                            assetName: 'assets/icons/bluetooth.svg',
                            buttonColor: provider.bluetoothState ==
                                    BluetoothConnectionStatus.ON
                                ? kSpringColor
                                : kSecondaryColor,
                          );
                        },
                      ),
                    ),
                    Showcase(
                      key: _obd,
                      title: 'OBD',
                      description:
                          'Indicates whether an OBD device is\nconnected or not',
                      child: Consumer<BluetoothProvider>(
                        builder: (context, bluetoothProvider, child) {
                          final bool isConnected =
                              bluetoothProvider.isConnected();
                          return DashboardIconButton(
                            routeName: BluetoothDevicesScreen.routeName,
                            assetName: 'assets/icons/smartphone.svg',
                            buttonColor:
                                isConnected ? kSpringColor : kSecondaryColor,
                          );
                        },
                      ),
                    ),
                    Showcase(
                      key: _car,
                      title: 'Car',
                      description: 'Indicates whether a car is selected or not',
                      child: Consumer<CarsProvider>(
                        builder: (context, provider, child) {
                          return DashboardIconButton(
                            routeName: CarScreen.routeName,
                            assetName: 'assets/icons/car.svg',
                            buttonColor: provider.getSelectedCar != null
                                ? kSpringColor
                                : kSecondaryColor,
                          );
                        },
                      ),
                    ),
                    Showcase(
                      key: _gps,
                      title: 'GPS',
                      description: 'Indicates whether GPS is turned on or not',
                      child: Consumer<LocationStatusProvider>(
                        builder: (context, provider, child) {
                          return DashboardIconButton(
                            routeName: MapScreen.routeName,
                            assetName: 'assets/icons/gps.svg',
                            buttonColor:
                                provider.locationState == LocationStatus.enabled
                                    ? kSpringColor
                                    : kSecondaryColor,
                          );
                        },
                      ),
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
                    BluetoothDevice? connectedDevice;
                    if (isConnected) {
                      connectedDevice = bluetoothProvider.getConnectedDevice!;
                    }

                    return Showcase(
                      key: _selectedObd,
                      title: 'Selected OBD',
                      description:
                          'Shows the OBD device currently paired with the app',
                      child: DashboardCard(
                        assetName: 'assets/icons/bluetooth.svg',
                        title: isConnected
                            ? (connectedDevice!.name.isNotEmpty
                                ? connectedDevice.name
                                : 'Unknown Device')
                            : 'No OBD-II adapter selected',
                        subtitle: isConnected
                            ? connectedDevice!.id.toString()
                            : 'Click here to select one',
                        routeName: BluetoothDevicesScreen.routeName,
                        iconBackgroundColor:
                            isConnected ? kSpringColor : kSecondaryColor,
                      ),
                    );
                  },
                ),

                SizedBox(
                  height: deviceHeight * 0.02,
                ),

                // Car Card
                Consumer<CarsProvider>(
                  builder: (_, carsProvider, child) {
                    final Car? selectedCar = carsProvider.getSelectedCar;

                    return Showcase(
                      key: _selectedCar,
                      title: 'Selected Car',
                      description: 'Shows the currently selected car',
                      child: DashboardCard(
                        assetName: 'assets/icons/car.svg',
                        title: selectedCar == null
                            ? 'No car selected'
                            : '${selectedCar.properties!.manufacturer}, ${selectedCar.properties!.model}',
                        subtitle: selectedCar == null
                            ? 'Select a car'
                            : '${selectedCar.properties!.constructionYear}, ${selectedCar.properties!.engineDisplacement}, ${selectedCar.properties!.fuelType}',
                        routeName: CarScreen.routeName,
                        iconBackgroundColor: carsProvider.getSelectedCar != null
                            ? kSpringColor
                            : kSecondaryColor,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
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
                      onTap: () {
                        final locationProvider =
                            Provider.of<LocationStatusProvider>(
                          context,
                          listen: false,
                        );
                        final carsProvider =
                            Provider.of<CarsProvider>(context, listen: false);
                        final bluetoothProvider =
                            Provider.of<BluetoothProvider>(
                          context,
                          listen: false,
                        );

                        if (locationProvider.locationState ==
                                LocationStatus.enabled &&
                            carsProvider.getSelectedCar != null &&
                            bluetoothProvider.isConnected()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return RecordingInformationDialogBox(
                                onButtonTap: () {
                                  _logger.i('Going to GPS tracking screen');
                                  Navigator.pushNamed(
                                    context,
                                    GpsTrackingScreen.routeName,
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          const String title = 'Cannot start GPS tracking';
                          String content = ' ';
                          bool carState = true;
                          bool locationState = true;
                          bool bluetoothState = true;
                          if (locationProvider.locationState ==
                                  LocationStatus.disabled &&
                              carsProvider.getSelectedCar == null &&
                              !bluetoothProvider.isConnected()) {
                            content =
                                'Please turn on location, select a car and connect to OBD-II adapter to start recording your track.';
                            locationState = false;
                            carState = false;
                            bluetoothState = false;
                          } else if (carsProvider.getSelectedCar == null &&
                              !bluetoothProvider.isConnected()) {
                            content =
                                'Please select a car and connect to OBD-II adapter to start recording your track.';
                            carState = false;
                            bluetoothState = false;
                          } else if (carsProvider.getSelectedCar == null &&
                              locationProvider.locationState ==
                                  LocationStatus.disabled) {
                            content =
                                'Please turn on location and select a car to start recording your track.';
                            locationState = false;
                            carState = false;
                          } else if (locationProvider.locationState ==
                                  LocationStatus.disabled &&
                              !bluetoothProvider.isConnected()) {
                            content =
                                'Please turn on location and connect to OBD-II adapter to start recording your track.';
                            locationState = false;
                            bluetoothState = false;
                          } else if (!bluetoothProvider.isConnected()) {
                            content =
                                'Please connect to OBD-II adapter to start recording your track.';
                            bluetoothState = false;
                          } else if (carsProvider.getSelectedCar == null) {
                            content =
                                'Please select a car to start recording your track.';
                            carState = false;
                          } else if (locationProvider.locationState ==
                              LocationStatus.disabled) {
                            content =
                                'Please turn on location services to start recording your track.';
                            locationState = false;
                          }
                          showAlertDialog(
                            context: context,
                            title: title,
                            content: content,
                            carState: carState,
                            locationState: locationState,
                            bluetoothState: bluetoothState,
                          );
                        }
                      },
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
