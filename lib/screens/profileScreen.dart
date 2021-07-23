import 'dart:io';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/authProvider.dart';
import '../services/authenticationServices.dart';
import './reportIssueScreen.dart';
import '../widgets/dividerLine.dart';
import '../providers/userStatsProvider.dart';
import '../providers/tracksProvider.dart';
import './logBookScreen.dart';
import './helpScreen.dart';
import '../constants.dart';

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

  Widget buildIconButton(
      {@required String title,
      @required IconData iconData,
      @required void Function() onTap,
      @required Color color}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                iconData,
                color: color,
                size: 35,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        DividerLine(),
      ],
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
              color: Colors.black,
              onTap: () {
                _logger.i('Going to logbook screen');
                Navigator.of(context).pushNamed(LogBookScreen.routeName);
              },
            ),

            // Help button
            buildIconButton(
              title: 'Help',
              iconData: Icons.help_outline,
              color: Colors.black,
              onTap: () {
                _logger.i('Going to help screen');
                Navigator.of(context).pushNamed(HelpScreen.routeName);
              },
            ),

            // Report Issue button
            buildIconButton(
              title: 'Report Issue',
              iconData: Icons.bug_report,
              color: Colors.black,
              onTap: () {
                _logger.i('Going to report issue screen');
                Navigator.of(context).pushNamed(ReportIssueScreen.routeName);
              },
            ),

            // Rate us button
            buildIconButton(
              title: 'Rate Us',
              iconData: Icons.star,
              color: Colors.black,
              onTap: () async {
                if (await canLaunch(playstoreUrl)) {
                  _logger.i('Launching playstore');
                  launch(playstoreUrl);
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
              color: Colors.black,
              onTap: () {
                _logger.i('logoutUser called');
                AuthenticationServices().logoutUser(
                  authProvider: _authProvider,
                  userStatsProvider: _userStatsProvider,
                  tracksProvider: _tracksProvider,
                );
              },
            ),

            // Button to navigate to close the app
            buildIconButton(
              title: 'Close enviroCar',
              iconData: Icons.highlight_off_rounded,
              color: Colors.red,
              onTap: () {
                _logger.i('closeEnvirocar called');
                // Closes the app programatically
                // Apple may SUSPEND THE APP as it is again Apple's Human Interface Guidelines
                exit(0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
