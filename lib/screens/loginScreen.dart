import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../constants.dart';
import '../services/authenticationServices.dart';
import './registerScreen.dart';
import '../models/user.dart';
import './index.dart';
import '../providers/userStatsProvider.dart';
import '../globals.dart';

// TODO: Add validators

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username;
  String _password;
  bool _wrongCredentials = false;

  Future<void> _showDialogbox(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final UserStatsProvider _userStatsProvider =
        Provider.of<UserStatsProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: deviceHeight,
          width: deviceWidth,
          padding:
              EdgeInsets.fromLTRB(deviceWidth * 0.05, 0, deviceWidth * 0.05, 0),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return;
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: deviceHeight * 0.03),
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.1,
                    ),

                    // enviroCar Logo
                    Image.asset(
                      'assets/images/img_envirocar_logo.png',
                      scale: 5,
                    ),

                    SizedBox(
                      height: deviceHeight * 0.1,
                    ),

                    // Username
                    TextFormField(
                      decoration: inputDecoration.copyWith(
                        labelText: 'Username',
                      ),
                      // validator: (value) {
                      //   return validator.validateUsername(value);
                      // },
                      onChanged: (value) {
                        _username = value;
                      },
                    ),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    // Password
                    TextFormField(
                      obscureText: true,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Password',
                      ),
                      // validator: (value) {
                      //   return validator.validatePassword(value);
                      // },
                      onChanged: (value) {
                        _password = value;
                      },
                    ),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    // Error for wrong credentials
                    if (_wrongCredentials)
                      const Text(
                        'Wrong Credentials',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    else
                      Container(),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    // Login Button
                    GestureDetector(
                      onTap: () async {
                        setState(
                          () {
                            _wrongCredentials = false;
                          },
                        );

                        // if (_formKey.currentState.validate()) {
                        final User _user = User(
                          username: _username,
                          password: _password,
                        );

                        final String _status =
                            await AuthenticationServices().loginUser(
                          authProvider: _authProvider,
                          user: _user,
                          userStatsProvider: _userStatsProvider,
                        );

                        if (_status == 'Logged In') {
                          Navigator.of(context).pushReplacementNamed(
                            Index.routeName,
                          );
                        } else if (_status == 'invalid username or password') {
                          setState(
                            () {
                              _wrongCredentials = true;
                            },
                          );
                        } else if (_status == 'mail not confirmed') {
                          _showDialogbox('mail not confirmed');
                        }
                        // }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: kSpringColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    // Register screen button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          RegisterScreen.routeName,
                        );
                      },
                      child: const Text(
                        'New to enviroCar?\nRegister here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kGreyColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
