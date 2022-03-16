import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

import './index.dart';
import '../globals.dart';
import '../constants.dart';
import '../models/user.dart';
import './registerScreen.dart';
import '../exceptionHandling/result.dart';
import '../services/authenticationServices.dart';

// TODO: Add validators

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username;
  String _password;
  bool _wrongCredentials = false;
  bool _isObscure = true;

  Future<void> _showDialogbox(String message) async {
    _logger.i('Showing dialog');
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: deviceHeight,
          width: deviceWidth,
          padding:
              EdgeInsets.fromLTRB(deviceWidth * 0.05, 0, deviceWidth * 0.05, 0),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
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
                      obscureText: _isObscure,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
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
                        _logger.i('Loggin user in');
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

                        await AuthenticationServices()
                            .loginUser(
                          context: context,
                          user: _user,
                        )
                            .then(
                          (Result result) {
                            if (result.status == ResultStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(result.exception.getErrorMessage()),
                                ),
                              );
                            } else {
                              _logger.i('Logged in successfully');
                              _logger.i('Going to Dashboard');
                              Navigator.of(context).pushReplacementNamed(
                                Index.routeName,
                              );
                            }
                          },
                        );
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
                        _logger.i('Going to register screen');
                        Navigator.of(context).pushNamed(
                          RegisterScreen.routeName,
                        );
                      },
                      child: const Text(
                        'New to enviroCar?\nRegister here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
