import 'package:envirocar_app_main/widgets/settingsScreenWidgets/settingDropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../widgets/titleWidget.dart';
import '../widgets/dividerLine.dart';
import '../values/settingsValues.dart';
import '../providers/themeProvider.dart';
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
            SettingsListWidget(settings: obdModeSettings),
            DividerLine(),

            // GPS Mode Settings
            const TitleWidget(title: 'GPS Mode'),
            SettingsListWidget(settings: gpsModeSettings),
            DividerLine(),

            // Debugging Settings
            const TitleWidget(title: 'Debugging'),
            SettingsListWidget(settings: debuggingSettings),
            DividerLine(),

            // Theme Settings
            const TitleWidget(title: 'Theme'),
            /*SettingsListWidget(
              settings: themeSettings,
              onChanged: () {
                final ThemeProvider themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.switchThemeData();

                final ThemeData themeData = themeProvider.getTheme;
                themeData.primaryColor == Colors.white
                    ? preferences.setString('theme', 'light')
                    : preferences.setString('theme', 'dark');
              },
            ),*/
            SettingsDropDownWidget(settings: themeSettings),
          ],
        ),
      ),
    );
  }
}
