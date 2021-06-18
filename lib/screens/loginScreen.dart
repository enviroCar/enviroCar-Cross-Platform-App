import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../constants.dart';
import '../services/authenticationServices.dart';
import './registerScreen.dart';
import '../models/user.dart';
import './index.dart';
import '../providers/userStatsProvider.dart';

// TODO: Add validators

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _username;
  String _password;
  bool _wrongCredentials = false;

  _showDialogbox(String message) async {
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
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    double height = _mediaQuery.size.height;
    double width = _mediaQuery.size.width;

    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final UserStatsProvider _userStatsProvider =
        Provider.of<UserStatsProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return;
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),

                    // enviroCar Logo
                    Image.asset(
                      'assets/images/img_envirocar_logo.png',
                      scale: 5,
                    ),

                    SizedBox(
                      height: height * 0.1,
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
                      height: height * 0.03,
                    ),

                    // Password
                    TextFormField(
                      obscureText: true,
                      autofocus: false,
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
                      height: height * 0.03,
                    ),

                    // Error for wrong credentials
                    _wrongCredentials
                        ? Text(
                            'Wrong Credentials',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Container(),

                    SizedBox(
                      height: height * 0.03,
                    ),

                    // Login Button
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kSpringColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
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
                      onTap: () async {
                        setState(
                          () {
                            _wrongCredentials = false;
                          },
                        );

                        // if (_formKey.currentState.validate()) {
                        User _user = new User(
                          username: _username,
                          password: _password,
                        );

                        String _status =
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
                    ),

                    SizedBox(
                      height: height * 0.03,
                    ),

                    // Register screen button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          RegisterScreen.routeName,
                        );
                      },
                      child: Text(
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
