import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'homeScreen.dart';
import 'loginScreen.dart';
import '../models/user.dart';
import '../providers/authProvider.dart';
import '../services/authenticationServices.dart';
import '../services/secureStorageServices.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> loginExistingUser() async {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final User _user = await SecureStorageServices().getUserFromSecureStorage();

    String message = await AuthenticationServices()
        .loginUser(authProvider: _authProvider, user: _user);

    // if user deletes account from website and opens app again
    // then send to login screen and remove data from secure storage
    if (message == 'invalid username or password') {
      AuthenticationServices().logoutUser(authProvider: _authProvider);
    }
    return _authProvider.getAuthStatus;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginExistingUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data ? HomeScreen() : LoginScreen();
        } else {
          return Scaffold(
            body: Center(
              child: Text('EnviroCar'),
            ),
          );
        }
      },
    );
  }
}
