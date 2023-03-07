import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../constants.dart';
import '../models/user.dart';
import '../services/authenticationServices.dart';

// TODO: Add validators

class RegisterScreen extends StatefulWidget {
  static const routeName = '/registerScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username;
  String _password;
  String _confirmPassword;
  String _email;
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _showError = false;

  Future<void> _showDialogbox(String message) async {
    _logger.i('Showing dialog');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
      ),
    ).then(
      (value) {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: deviceHeight,
          width: deviceWidth,
          padding: EdgeInsets.fromLTRB(
            deviceWidth * 0.05,
            0,
            deviceWidth * 0.05,
            0,
          ),
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
                    // enviroCar logo
                    Image.asset(
                      'assets/images/img_envirocar_logo.png',
                      scale: 5,
                    ),

                    SizedBox(
                      height: deviceHeight * 0.05,
                    ),

                    // Email
                    TextFormField(
                      decoration: inputDecoration.copyWith(
                        labelText: 'Email',
                      ),
                      // validator: (value) {
                      //   return validator.validateEmail(value);
                      // },
                      onChanged: (value) {
                        _email = value;
                      },
                    ),

                    SizedBox(
                      height: deviceHeight * 0.03,
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

                    // Confirm Password
                    TextFormField(
                      obscureText: true,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Confirm Password',
                      ),
                      validator: (value) {
                        if (_confirmPassword.compareTo(_password) != 0) {
                          return 'Password doesn\'t match';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _confirmPassword = value;
                      },
                    ),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    // Terms and Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (value) {
                            setState(
                              () {
                                _acceptedTerms = value;
                              },
                            );
                          },
                        ),
                        const Flexible(
                          child: Text(

                              'I acknowledge that I have read and agree to enviroCar\'s Terms and Conditions'),

                        ),
                      ],
                    ),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    // Privacy Statements
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptedPrivacy,
                          onChanged: (value) {
                            setState(
                              () {
                                _acceptedPrivacy = value;
                              },
                            );
                          },
                        ),
                        const Flexible(
                          child: Text(
                            'I have taken note of the Privacy Statement',
                          ),
                        ),
                      ],
                    ),

                    // Error if both boxes aren't checked
                    if (_showError)
                      const Text(
                        'Please check both boxes',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    else
                      Container(),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    // Register button
                    GestureDetector(
                      onTap: () async {
                        if (_acceptedTerms && _acceptedPrivacy) {
                          setState(() {
                            _showError = false;
                          });
                        } else {
                          setState(() {
                            _showError = true;
                          });
                        }

                        if (_formKey.currentState.validate() && !_showError) {
                          _logger.i('Registering user');
                          final User _newUser = User(
                            username: _username,
                            email: _email,
                            password: _password,
                            acceptedTerms: _acceptedTerms,
                            acceptedPrivacy: _acceptedPrivacy,
                          );

                          final String _status =
                              await AuthenticationServices().registerUser(
                            user: _newUser,
                          );

                          if (_status == 'Mail Sent') {
                            _logger.i('Registration mail sent');
                            _showDialogbox('Mail Sent');
                          } else if (_status == 'name already exists') {
                            _logger.w('Mail already in use');
                            _showDialogbox('Email already in use');
                          } else {
                            _logger.w('Unknown error while registering');
                            _showDialogbox('An error was encountered.Please try again.');
                          }
                        }
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
                            'Register',
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

                    // Go to Login Screen button
                    TextButton(
                      onPressed: () {
                        _logger.i('Going to login screen');
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Already have an account?\nLogin here',
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
