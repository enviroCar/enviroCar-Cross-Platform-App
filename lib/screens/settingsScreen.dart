import 'Package:flutter/material.dart';

import '../widgets/dividerLine.dart';
import '../widgets/titleWidget.dart';
import '../values/settingsValues.dart';
import '../widgets/settingsScreenWidgets/settingsListWidget.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            const TitleWidget(title: 'General Settings'),
            SettingsListWidget(settings: generalSettings),
            DividerLine(),

            // OBD Mode Settings
            const TitleWidget(title: 'OBD Mode'),
            SettingsListWidget(settings: OBDModeSettings),
            DividerLine(),

            // GPS Mode Settings
            const TitleWidget(title: 'GPS Mode'),
            SettingsListWidget(settings: GPSModeSettings),
            DividerLine(),

            // Debugging Settings
            const TitleWidget(title: 'Debugging'),
            SettingsListWidget(settings: debuggingSettings),
          ],
        ),
      ),
    );
  }
}
