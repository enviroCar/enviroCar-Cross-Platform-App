import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import './providers/authProvider.dart';
import './screens/splashScreen.dart';
import './screens/bluetoothDevicesScreen.dart';
import './screens/index.dart';
import './screens/loginScreen.dart';
import './screens/mapScreen.dart';
import './screens/registerScreen.dart';
import './constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricts rotation of screen
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provides user data to different widgets on the tree
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          accentColor: kSpringColor,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          SplashScreen.routeName: (context) => SplashScreen(),
          Index.routeName: (context) => Index(),
          BluetoothDevicesScreen.routeName: (context) =>
              BluetoothDevicesScreen(),
          MapScreen.routeName: (context) => MapScreen(),
        },
      ),
    );
  }
}
