import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../globals.dart';
import './dashboardScreen.dart';
import './profileScreen.dart';
import './settingsScreen.dart';
import './tracksScreen.dart';
import '../constants.dart';
import '../widgets/OBDhelpDialog.dart';

class Index extends StatefulWidget {
  static const routeName = '/index';
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
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
