import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../providers/authProvider.dart';
import '../models/user.dart';
import './secureStorageServices.dart';

class AuthenticationServices {
  final baseUri = 'https://envirocar.org/api/stable/users';

  // Creates a new User
  Future<String> registerUser({
    @required AuthProvider authProvider,
    @required User user,
  }) async {
    final Uri uri = Uri.parse(baseUri);

    String jsonPayload = jsonEncode(user.toMap());

    http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonPayload,
    );

    if (response.statusCode == 201) {
      return 'Mail Sent';
    } else {
      var decodedBody = jsonDecode(response.body);
      return decodedBody['message'];
    }
  }

  // Logs in existing user
  Future<String> loginUser({
    @required AuthProvider authProvider,
    @required User user,
  }) async {
    if (user.getUsername != null && user.getPassword != null) {
      final Uri uri = Uri.parse(baseUri + '/' + user.getUsername);

      http.Response response = await http.get(
        uri,
        headers: {
          'X-User': user.getUsername,
          'X-Token': user.getPassword,
        },
      );

      // if correct username and password is used then status code returned is 200
      if (response.statusCode == 200) {
        SecureStorageServices().setUserInSecureStorage(
            username: user.getUsername, password: user.getPassword);

        var decodedBody = jsonDecode(response.body);

        user.setEmail = decodedBody['mail'];
        user.setAcceptedTerms = true;
        user.setAcceptedPrivacy = true;

        authProvider.setUser = user;
        authProvider.setAuthStatus = true;
        return 'Logged In';
      } else {
        authProvider.setAuthStatus = false;

        var decodedBody = jsonDecode(response.body);
        return decodedBody['message'];
      }
    } else {
      authProvider.setAuthStatus = false;
      return 'no data in secure storage';
    }
  }

  // Logs in user if they didn't logout the last time they opened the app
  Future<bool> loginExistingUser({@required AuthProvider authProvider}) async {
    final User _user = await SecureStorageServices().getUserFromSecureStorage();

    String message =
        await this.loginUser(authProvider: authProvider, user: _user);

    // if user deletes account from website and opens app again
    // then send to login screen and remove data from secure storage
    if (message == 'invalid username or password') {
      this.logoutUser(authProvider: authProvider);
    }
    return authProvider.getAuthStatus;
  }

  void logoutUser({@required AuthProvider authProvider}) {
    SecureStorageServices().deleteUserFromSecureStorage();
    authProvider.removeUser();
  }
}
