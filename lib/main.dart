import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './providers/authProvider.dart';
import './providers/tracksProvider.dart';
import './screens/splashScreen.dart';
import './screens/bluetoothDevicesScreen.dart';
import './screens/index.dart';
import './screens/loginScreen.dart';
import './screens/mapScreen.dart';
import './screens/registerScreen.dart';
import './constants.dart';
import './providers/userStatsProvider.dart';
import './globals.dart';
import './screens/carScreen.dart';
import './providers/carsProvider.dart';
import './screens/createCarScreen.dart';
import './screens/trackDetailsScreen.dart';
import './providers/fuelingsProvider.dart';
import './screens/createFuelingScreen.dart';
import './screens/logBookScreen.dart';
import './screens/reportIssueScreen.dart';

void main() async {
  // Ensures all the future functions of main() finish before launching the app
  WidgetsFlutterBinding.ensureInitialized();

  // Instance of shared prefs
  preferences = await SharedPreferences.getInstance();

  // Restricts rotation of screen
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    DevicePreview(
      // to check the UI on different devices make enabled true
      enabled: true,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provides user data to different widgets on the tree
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),

        // Provides user stats data to different widgets on the tree
        ChangeNotifierProvider(
          create: (context) => UserStatsProvider(),
        ),

        // Provides car data to different widget
        ChangeNotifierProvider(
          create: (context) => CarsProvider(),
        ),

        // Provides uploaded tracks to different widgets
        ChangeNotifierProvider(
          create: (context) => TracksProvider(),
        ),

        // Provides Fueling data to different widgets
        ChangeNotifierProvider(
          create: (context) => FuelingsProvider(),
        ),
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          accentColor: kSpringColor,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

        // For navigating to screens which accept arguments
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case TrackDetailsScreen.routeName:
              return MaterialPageRoute(
                builder: (_) {
                  return TrackDetailsScreen(track: settings.arguments);
                },
              );

            default:
              return null;
          }
        },

        // Helps in navigating to different screens via route name
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          SplashScreen.routeName: (context) => SplashScreen(),
          Index.routeName: (context) => Index(),
          BluetoothDevicesScreen.routeName: (context) =>
              BluetoothDevicesScreen(),
          MapScreen.routeName: (context) => MapScreen(),
          CarScreen.routeName: (context) => CarScreen(),
          CreateCarScreen.routeName: (context) => CreateCarScreen(),
          CreateFuelingScreen.routeName: (context) => CreateFuelingScreen(),
          LogBookScreen.routeName: (context) => LogBookScreen(),
          ReportIssueScreen.routeName: (context) => ReportIssueScreen(),
        },
      ),
    );
  }
}
