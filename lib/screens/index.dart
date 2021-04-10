import 'package:flutter/material.dart';

import './bluetoothDevicesScreen.dart';
import './mapScreen.dart';
import './dashboardScreen.dart';
import './tracksScreen.dart';
import './settingsScreen.dart';
import './profileScreen.dart';
import '../constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        actions: [
          // Map screen button
          IconButton(
            icon: Icon(
              Icons.gps_fixed_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                MapScreen.routeName,
              );
            },
          ),

          // Bluetooth screen button
          IconButton(
            icon: Icon(
              Icons.bluetooth,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                BluetoothDevicesScreen.routeName,
              );
            },
          ),
        ],

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
              child: Icon(
                Icons.home,
                size: 30,
                color: _currentIndex == 0 ? kSpringColor : Colors.grey[300],
              ),
            ),
            GestureDetector(
              onTap: () {
                changeScreen(1);
              },
              child: Icon(
                Icons.trending_up_sharp,
                size: 30,
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
    );
  }
}
