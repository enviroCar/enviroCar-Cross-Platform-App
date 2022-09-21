import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import './helpScreen.dart';
import './logBookScreen.dart';
import './reportIssueScreen.dart';
import '../providers/authProvider.dart';
import '../providers/tracksProvider.dart';
import '../providers/userStatsProvider.dart';
import '../services/authenticationServices.dart';
import 'dataPrivacyControlScreen.dart';
import 'faqsScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  Widget buildIconButton({
    @required String title,
    @required IconData iconData,
    @required void Function() onTap,
    Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Icon(
                  iconData,
                  size: 35,
                  color: color ?? Theme.of(context).iconTheme.color,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: color ?? Theme.of(context).iconTheme.color,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provides user data
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Provides user stats data
    final UserStatsProvider _userStatsProvider =
        Provider.of<UserStatsProvider>(context, listen: false);

    // provides tracks data
    final TracksProvider _tracksProvider =
        Provider.of<TracksProvider>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Log book button
            buildIconButton(
              title: 'Log Book',
              iconData: Icons.menu_book,
              onTap: () {
                _logger.i('Going to logbook screen');
                Navigator.of(context).pushNamed(LogBookScreen.routeName);
              },
            ),

            // Data privacy and control settings button
            buildIconButton(
              title: 'Data Privacy/Control',
              iconData: Icons.security,
              onTap: () {
                _logger.i('Going to data privacy/control screen');
                Navigator.of(context)
                    .pushNamed(DataPrivacyControlScreen.routeName);
              },
            ),

            // Help button
            buildIconButton(
              title: 'Help',
              iconData: Icons.help_outline,
              onTap: () {
                _logger.i('Going to help screen');
                Navigator.of(context).pushNamed(HelpScreen.routeName);
              },
            ),

            // Report Issue button
            buildIconButton(
              title: 'Report Issue',
              iconData: Icons.bug_report,
              onTap: () {
                _logger.i('Going to report issue screen');
                Navigator.of(context).pushNamed(ReportIssueScreen.routeName);
              },
            ),

            // Rate us button
            buildIconButton(
              title: 'Rate Us',
              iconData: Icons.star,
              onTap: () async {
                if (await canLaunchUrl(playStoreUrl)) {
                  _logger.i('Launching playstore');
                  launchUrl(playStoreUrl);
                  return;
                } else {
                  _logger.w('Tried opening playstore but failed');
                  throw 'Cannot Launch';
                }
              },
            ),

            // Logout button
            buildIconButton(
              title: 'Logout',
              iconData: Icons.logout,
              onTap: () {
                _logger.i('logoutUser called');
                AuthenticationServices().logoutUser(
                  authProvider: _authProvider,
                  userStatsProvider: _userStatsProvider,
                  tracksProvider: _tracksProvider,
                );
              },
            ),

            // Button to navigate to FAQs Screen
            buildIconButton(
              title: 'FAQs',
              iconData: Icons.question_answer,
              onTap: () {
                _logger.i('Navigate to FAQs screen');
                Navigator.of(context).pushNamed(FAQsScreen.routeName);
              },
            ),

            // Button to close the app
            buildIconButton(
              title: 'Close enviroCar',
              iconData: Icons.highlight_off_rounded,
              color: Colors.red,
              onTap: () {
                _logger.i('closeEnvirocar called');
                // Closes the app programatically
                // Apple may SUSPEND THE APP as it is against Apple's Human Interface Guidelines
                exit(0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
