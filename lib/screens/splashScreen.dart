import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './index.dart';
import '../globals.dart';
import './loginScreen.dart';
import './onboardingScreen.dart';
import '../providers/authProvider.dart';
import '../exceptionHandling/result.dart';
import '../services/authenticationServices.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Initializes device height and width to be used throughout the app
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    // if app is opened first time then show onboarding screens
    if (preferences.getBool('displayIntroduction') == null) {
      return OnboardingScreen();
    }

    return Consumer<AuthProvider>(
      builder: (_, authProvider, child) {
        final bool authStatus = authProvider.getAuthStatus;

        // call silent sign-in
        if (authStatus == null) {
          AuthenticationServices().silentSignIn(context: context).then(
            (Result result) {
              if (result.status == ResultStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(result.exception!.getErrorMessage()!),
                  ),
                );
              }
            },
          );
          return Scaffold(
            body: Center(
              child: Image.asset(
                'assets/images/img_envirocar_logo.png',
                scale: 5,
              ),
            ),
          );
        } else if (authStatus == false) {
          return LoginScreen();
        } else {
          return Index();
        }
      },
    );
  }
}
