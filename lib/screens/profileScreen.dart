import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import './loginScreen.dart';
import '../services/authenticationServices.dart';
import '../constants.dart';
import '../providers/userStatsProvider.dart';
import '../providers/tracksProvider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      padding: EdgeInsets.symmetric(
        vertical: 20,
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: kGreyColor,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Log Book',
                          style: TextStyle(
                            color: kGreyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: kGreyColor,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Help',
                          style: TextStyle(
                            color: kGreyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.bug_report_rounded,
                          color: kGreyColor,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Bug Report',
                          style: TextStyle(
                            color: kGreyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: kGreyColor,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Rate Us',
                          style: TextStyle(
                            color: kGreyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AuthenticationServices().logoutUser(
                        authProvider: _authProvider,
                        userStatsProvider: _userStatsProvider,
                        tracksProvider: _tracksProvider,
                      );
                      Navigator.of(context).pushReplacementNamed(
                        LoginScreen.routeName,
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: kGreyColor,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: kGreyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.highlight_off_rounded,
                          color: Colors.red,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Close enviroCar',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
