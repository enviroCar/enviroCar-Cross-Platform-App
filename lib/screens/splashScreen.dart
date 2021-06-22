import 'package:envirocar_app_main/providers/tracksProvider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './index.dart';
import './loginScreen.dart';
import '../providers/authProvider.dart';
import '../services/authenticationServices.dart';
import '../providers/userStatsProvider.dart';
import '../globals.dart';
import './onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future buildScreen;

  // Navigates user to either Onboarding Screens or Login Screen
  // depending on whether the app has been opened the very first time
  Widget navigate() {
    if (preferences.getBool('displayIntroduction') == null) {
      preferences.setBool('displayIntroduction', false);
      return OnboardingScreen();
    } else {
      return LoginScreen();
    }
  }

  @override
  void initState() {
    super.initState();

    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final UserStatsProvider _userStatsProvider =
        Provider.of<UserStatsProvider>(context, listen: false);
    final TracksProvider _tracksProvider =
        Provider.of<TracksProvider>(context, listen: false);

    buildScreen = AuthenticationServices().loginExistingUser(
      authProvider: _authProvider,
      userStatsProvider: _userStatsProvider,
      tracksProvider: _tracksProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initializes device height and width to be used throuhout the app
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      // tries to login user if they didn't logout last time
      future: buildScreen,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data ? Index() : navigate();
        } else {
          return Scaffold(
            body: Center(
              child: Image.asset(
                'assets/images/img_envirocar_logo.png',
                scale: 5,
              ),
            ),
          );
        }
      },
    );
  }
}
