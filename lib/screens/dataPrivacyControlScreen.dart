import 'package:flutter/material.dart';

import '../widgets/titleWidget.dart';
import '../values/preferencesValues.dart';
import 'package:envirocar_app_main/constants.dart';
import 'package:envirocar_app_main/widgets/dividerLine.dart';
import '../widgets/dataPrivacyControlWidgets/preferencesWidget.dart';

class DataPrivacyControlScreen extends StatelessWidget {
  static const routeName = '/dataPrivacyScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        title: const Text('Data Privacy/Control'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location data preferences
              const TitleWidget(title: 'Location Data Preferences'),
              PreferencesWidget(preferences: locationPreferencesSettings),
              DividerLine(),

              // Parameters preferences
              const TitleWidget(title: 'Calculated Parameters Preferences'),
              PreferencesWidget(preferences: parametersPreferencesSettings),
              DividerLine(),
            ],
          ),
        ),
      ),
    );
  }
}
