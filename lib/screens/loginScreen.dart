import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../constants.dart' as constants;
import '../services/authenticationServices.dart';
import './registerScreen.dart';
import '../models/user.dart';
import './homeScreen.dart';
import '../utils/validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _username;
  String _password;
  bool _wrongCredentials = false;

  final Validator validator = Validator();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.3,
                    ),

                    // Username
                    TextFormField(
                      decoration: constants.inputDecoration.copyWith(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        return validator.validateUsername(value);
                      },
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
                      decoration: constants.inputDecoration.copyWith(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        return validator.validatePassword(value);
                      },
                      onChanged: (value) {
                        _password = value;
                      },
                    ),

                    SizedBox(
                      height: height * 0.03,
                    ),

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

                    ElevatedButton(
                      onPressed: () async {
                        setState(
                          () {
                            _wrongCredentials = false;
                          },
                        );

                        if (_formKey.currentState.validate()) {
                          User _user = new User(
                            username: _username,
                            password: _password,
                          );

                          String _status =
                              await AuthenticationServices().loginUser(
                            authProvider: _authProvider,
                            user: _user,
                          );

                          if (_status == 'Logged In') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return HomeScreen();
                                },
                              ),
                            );
                          } else if (_status ==
                              'invalid username or password') {
                            setState(
                              () {
                                _wrongCredentials = true;
                              },
                            );
                          } else if (_status == 'mail not confirmed') {
                            _showDialogbox('mail not confirmed');
                          }
                        }
                      },
                      child: Text(
                        'Login',
                      ),
                    ),

                    SizedBox(
                      height: height * 0.03,
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return RegisterScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'New to enviroCar?\nRegister here',
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
