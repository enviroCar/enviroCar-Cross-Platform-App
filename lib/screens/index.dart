import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals.dart';
import '../constants.dart';
import '../widgets/tracksScreenWidgets/trackDialogBox.dart';
import './tracksScreen.dart';
import './profileScreen.dart';
import './settingsScreen.dart';
import './dashboardScreen.dart';
import '../widgets/OBDhelpDialog.dart';

/// The base widget that contains all the 4 screens on the bottom nav bar
///
/// it is used to navigate between the 4 screens all the while
/// preserving the state in them so that data isn't loaded each time

class Index extends StatefulWidget {
  static const routeName = '/index';
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  int _currentIndex = 0;

  List<Widget> _screensList;

  @override
  void initState() {
    super.initState();

    _screensList = [
      DashboardScreen(),
      TracksScreen(),
      SettingsScreen(),
      ProfileScreen(),
    ];
  }

  void changeScreen(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void showHelpDialog() {
    _logger.i('Showing help dialog');
    showDialog(
      context: context,
      builder: (_) {
        return OBDHelpDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerState,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kGreyColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.help,
              color: Colors.white,
            ),
            onPressed: () {
              showHelpDialog();
            },
          ),
          // enviroCar logo
          title: Image.asset(
            'assets/images/img_envirocar_logo_white.png',
            scale: 10,
          ),
          centerTitle: true,
          actions: _currentIndex == 1
              ? [
                  IconButton(
                    onPressed: () {
                      showTrackDialogBox(context);
                    },
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: kWhiteColor,
                    ),
                  ),
                ]
              : [],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screensList,
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 55,
          color: kGreyColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  _logger.i('On dashboard');
                  changeScreen(0);
                },
                child: SvgPicture.asset(
                  'assets/icons/speedometer.svg',
                  height: 30,
                  color: _currentIndex == 0 ? kSpringColor : Colors.grey[300],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _logger.i('On tracks screen');
                  changeScreen(1);
                },
                child: SvgPicture.asset(
                  'assets/icons/track.svg',
                  height: 30,
                  color: _currentIndex == 1 ? kSpringColor : Colors.grey[300],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _logger.i('On settings screen');
                  changeScreen(2);
                },
                child: Icon(
                  Icons.settings,
                  size: 30,
                  color: _currentIndex == 2 ? kSpringColor : Colors.grey[300],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _logger.i('On profile screen');
                  changeScreen(3);
                },
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: _currentIndex == 3 ? kSpringColor : Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
