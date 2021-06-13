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
  Widget navigate() {
    if (preferences.getBool('displayIntroduction') == null) {
      preferences.setBool('displayIntroduction', false);
      return OnboardingScreen();
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final UserStatsProvider _userStatsProvider =
        Provider.of<UserStatsProvider>(context, listen: false);

    return FutureBuilder(
      future: AuthenticationServices().loginExistingUser(
        authProvider: _authProvider,
        userStatsProvider: _userStatsProvider,
      ),
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
