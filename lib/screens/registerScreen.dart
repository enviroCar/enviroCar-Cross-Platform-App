import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../constants.dart' as constants;
import '../services/authenticationServices.dart';
import '../models/user.dart';
import '../utils/validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _username;
  String _password;
  String _confirmPassword;
  String _email;
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _showError = false;

  final Validator validator = Validator();

  void _showDialogbox(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
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
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    double _height = _mediaQuery.size.height;
    double _width = _mediaQuery.size.width;

    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.fromLTRB(_width * 0.05, 0, _width * 0.05, 0),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return;
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: _height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    TextFormField(
                      decoration: constants.inputDecoration.copyWith(
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
                      height: _height * 0.03,
                    ),

                    // Username
                    TextFormField(
                      decoration: constants.inputDecoration.copyWith(
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
                      height: _height * 0.03,
                    ),

                    // Password
                    TextFormField(
                      obscureText: true,
                      autofocus: false,
                      decoration: constants.inputDecoration.copyWith(
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
                      height: _height * 0.03,
                    ),

                    // Confirm Password
                    TextFormField(
                      obscureText: true,
                      autofocus: false,
                      decoration: constants.inputDecoration.copyWith(
                        labelText: 'Password',
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
                      height: _height * 0.03,
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
                        Flexible(
                          child: Text(
                              'I acknowledge I have read and agree to enviroCar\'s Terms and Conditions'),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: _height * 0.03,
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
                        Flexible(
                          child: Text(
                              'I have taken note of the Privacy Statement'),
                        ),
                      ],
                    ),

                    _showError
                        ? Text(
                            'Please check both boxes',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Container(),

                    SizedBox(
                      height: _height * 0.03,
                    ),

                    // Register button
                    ElevatedButton(
                      onPressed: () async {
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
                          User _newUser = new User(
                            username: _username,
                            email: _email,
                            password: _password,
                            acceptedTerms: _acceptedTerms,
                            acceptedPrivacy: _acceptedPrivacy,
                          );

                          String _status =
                              await AuthenticationServices().registerUser(
                            authProvider: _authProvider,
                            user: _newUser,
                          );

                          print(_status);
                          if (_status == 'Mail Sent') {
                            _showDialogbox('Mail Sent');
                          } else if (_status == 'name already exists') {
                            _showDialogbox('Email already in use');
                          } else {
                            _showDialogbox('Some other error');
                          }
                        }
                      },
                      child: Text(
                        'Register',
                      ),
                    ),

                    // Go to Login Screen button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Already have an account?\nLogin here',
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
