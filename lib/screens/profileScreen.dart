import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import './loginScreen.dart';
import '../services/authenticationServices.dart';
import './reportIssueScreen.dart';
import '../widgets/dividerLine.dart';
import '../providers/userStatsProvider.dart';
import '../providers/tracksProvider.dart';
import './logBookScreen.dart';
import './helpScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget buildIconButton(
      {@required String title,
      @required IconData iconData,
      @required Function onTap,
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
              SizedBox(
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

    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Log book button
            buildIconButton(
              title: 'Log Book',
              iconData: Icons.menu_book,
              color: Colors.black,
              onTap: () {
                Navigator.of(context).pushNamed(LogBookScreen.routeName);
              },
            ),

            // Help button
            buildIconButton(
              title: 'Help',
              iconData: Icons.help_outline,
              color: Colors.black,
              onTap: () {
                Navigator.of(context).pushNamed(HelpScreen.routeName);
              },
            ),

            // Report Issue button
            buildIconButton(
              title: 'Report Issue',
              iconData: Icons.bug_report,
              color: Colors.black,
              onTap: () {
                Navigator.of(context).pushNamed(ReportIssueScreen.routeName);
              },
            ),

            // Rate us button
            buildIconButton(
              title: 'Rate Us',
              iconData: Icons.star,
              color: Colors.black,
              onTap: () {},
            ),

            // Logout button
            buildIconButton(
              title: 'Logout',
              iconData: Icons.logout,
              color: Colors.black,
              onTap: () {
                AuthenticationServices().logoutUser(
                  authProvider: _authProvider,
                  userStatsProvider: _userStatsProvider,
                  tracksProvider: _tracksProvider,
                );
                Navigator.of(context).pushReplacementNamed(
                  LoginScreen.routeName,
                );
              },
            ),

            // Button to navigate to close the app
            buildIconButton(
              title: 'Close enviroCar',
              iconData: Icons.highlight_off_rounded,
              color: Colors.red,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
