import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'constants.dart';
import './globals.dart';
import './screens/index.dart';
import 'screens/dataPrivacyControlScreen.dart';
import 'screens/helpScreen.dart';
import './screens/carScreen.dart';
import './screens/mapScreen.dart';
import './screens/loginScreen.dart';
import '../screens/helpScreen.dart';
import 'models/localTrackModel.dart';
import 'models/pointProperties.dart';
import './screens/splashScreen.dart';
import './screens/logBookScreen.dart';
import 'providers/themeProvider.dart';
import './providers/authProvider.dart';
import './screens/registerScreen.dart';
import './providers/carsProvider.dart';
import './screens/createCarScreen.dart';
import 'screens/gpsTrackingScreen.dart';
import './providers/tracksProvider.dart';
import 'providers/gpsTrackProvider.dart';
import './hiveDB/sensorsCollection.dart';
import './hiveDB/fuelingsCollection.dart';
import './screens/reportIssueScreen.dart';
import './providers/fuelingsProvider.dart';
import 'services/notification_service.dart';
import 'providers/localTracksProvider.dart';
import './providers/userStatsProvider.dart';
import './providers/bluetoothProvider.dart';
import './screens/createFuelingScreen.dart';
import './screens/bluetoothDevicesScreen.dart';
import './providers/locationStatusProvider.dart';
import './providers/bluetoothStatusProvider.dart';

Future<void> main() async {
  // Ensures all the future functions of main() finish before launching the app
  WidgetsFlutterBinding.ensureInitialized();

  // Instance of shared prefs
  preferences = await SharedPreferences.getInstance();

  // instance of scaffold messenger state global key
  scaffoldMessengerState = GlobalKey<ScaffoldMessengerState>();

  // initialise hive db
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter<LocalTrackModel>(LocalTrackModelAdapter());
  Hive.registerAdapter<PointProperties>(PointPropertiesAdapter());

  // open Hive boxes to fetch data from
  await CarsCollection().openCarsHive();
  await FuelingsCollection().openFuelingsHive();
  await Hive.openBox<LocalTrackModel>(localTracksTableName);

  // initialise the flutter local notification plugin
  await NotificationService().initialiseNotificationPlugin();

  // Restricts rotation of screen
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  runApp(
    DevicePreview(
      // to check the UI on different devices make enabled true
      enabled: false,
      builder: (context) {
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

            // Provides bluetooth status update to the different widgets on the tree
            ChangeNotifierProvider(
              create: (context) => BluetoothStatusProvider(),
            ),

            // Provides location status update to the different widgets on the tree
            ChangeNotifierProvider(
              create: (context) => LocationStatusProvider(),
            ),

            // Provides bluetooth functions to the different widgets on the tree
            ChangeNotifierProvider(
              create: (context) => BluetoothProvider(),
            ),

            // Provides Fueling data to different widgets
            ChangeNotifierProvider(
              create: (context) => FuelingsProvider(),
            ),

            ChangeNotifierProvider(
              create: (context) => GpsTrackProvider(),
            ),

            ChangeNotifierProvider(
              create: (context) => LocalTracksProvider(),
            ),

            // Provides theme data to different widgets on the tree
            ChangeNotifierProvider(
              create: (context) => ThemeProvider(),
            ),
          ],
          child: MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: Provider.of<ThemeProvider>(context).getTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

      // Helps in navigating to different screens via route name
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        SplashScreen.routeName: (context) => SplashScreen(),
        Index.routeName: (context) => Index(),
        BluetoothDevicesScreen.routeName: (context) => BluetoothDevicesScreen(),
        MapScreen.routeName: (context) => MapScreen(),
        CarScreen.routeName: (context) => CarScreen(),
        CreateCarScreen.routeName: (context) => CreateCarScreen(),
        CreateFuelingScreen.routeName: (context) => CreateFuelingScreen(),
        LogBookScreen.routeName: (context) => LogBookScreen(),
        ReportIssueScreen.routeName: (context) => ReportIssueScreen(),
        HelpScreen.routeName: (context) => HelpScreen(),
        GpsTrackingScreen.routeName: (context) => GpsTrackingScreen(),
        DataPrivacyControlScreen.routeName: (context) => DataPrivacyControlScreen(),
      },
    );
  }
}
