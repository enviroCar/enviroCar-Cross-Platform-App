import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../services/authenticationServices.dart';
import './loginScreen.dart';
import './bluetoothDevicesScreen.dart';
import './mapScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    MediaQueryData _mediaQuery = MediaQuery.of(context);
    double height = _mediaQuery.size.height;
    double width = _mediaQuery.size.width;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.20,
              width: double.infinity,
              color: Color.fromARGB(255, 23, 33, 43),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TODO: Replace dummy data with actual data
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '23',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            'Total Tracks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 80, 100),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '100 km',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            'Total Distance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 80, 100),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '0.01 hr',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            'Total Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 80, 100),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 55,
        color: Color.fromARGB(255, 23, 33, 43),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // TODO: Create screens and map to the bottom bar
            GestureDetector(
              child: Icon(
                Icons.home,
                size: 30,
                color: Color.fromARGB(255, 0, 223, 165),
              ),
            ),
            GestureDetector(
              child: Icon(
                Icons.settings,
                size: 30,
                color: Colors.grey[300],
              ),
            ),
            GestureDetector(
              onTap: () {
                AuthenticationServices()
                    .logoutUser(authProvider: _authProvider);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
              child: Icon(
                Icons.logout,
                size: 30,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
