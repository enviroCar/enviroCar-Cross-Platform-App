import 'package:flutter/material.dart';

import 'bluetoothDevicesScreen.dart';
import 'mapScreen.dart';
import 'dashboardScreen.dart';
import 'tracksScreen.dart';
import 'settingsScreen.dart';
import 'profileScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> screensList;

  @override
  void initState() {
    super.initState();

    screensList = [
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
        backgroundColor: Color.fromARGB(255, 23, 33, 43),
        elevation: 0,
        actions: [
          // Map screen button
          IconButton(
            icon: Icon(
              Icons.gps_fixed_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MapScreen();
                  },
                ),
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return BluetoothDevicesScreen();
                  },
                ),
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
      body: screensList[_currentIndex],
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 55,
        color: Color.fromARGB(255, 23, 33, 43),
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
                color: _currentIndex == 0
                    ? Color.fromARGB(255, 0, 223, 165)
                    : Colors.grey[300],
              ),
            ),
            GestureDetector(
              onTap: () {
                changeScreen(1);
              },
              child: Icon(
                Icons.trending_up_sharp,
                size: 30,
                color: _currentIndex == 1
                    ? Color.fromARGB(255, 0, 223, 165)
                    : Colors.grey[300],
              ),
            ),
            GestureDetector(
              onTap: () {
                changeScreen(2);
              },
              child: Icon(
                Icons.settings,
                size: 30,
                color: _currentIndex == 2
                    ? Color.fromARGB(255, 0, 223, 165)
                    : Colors.grey[300],
              ),
            ),
            GestureDetector(
              onTap: () {
                changeScreen(3);
              },
              child: Icon(
                Icons.person,
                size: 30,
                color: _currentIndex == 3
                    ? Color.fromARGB(255, 0, 223, 165)
                    : Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
