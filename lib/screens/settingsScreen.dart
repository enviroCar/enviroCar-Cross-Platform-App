import 'Package:flutter/material.dart';

import '../constants.dart';
import '../utils/values.dart';
import '../widgets/settingsScreenWidgets/settingsListWidget.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Build the divider between two different types of settings
  Widget buildDivider() {
    return Divider(
      thickness: 2,
    );
  }

  // Builds the title of each type of settings
  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 15, color: kSpringColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle('General Settings'),
            SettingsListWidget(settings: generalSettings),
            buildDivider(),
            buildTitle('OBD Mode'),
            SettingsListWidget(settings: OBDModeSettings),
            buildDivider(),
            buildTitle('GPS Mode'),
            SettingsListWidget(settings: GPSModeSettings),
            buildDivider(),
            buildTitle('Debugging'),
            SettingsListWidget(settings: debuggingSettings),
          ],
        ),
      ),
    );
  }
}
