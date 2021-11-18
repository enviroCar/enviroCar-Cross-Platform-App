import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import './statsServices.dart';
import './secureStorageServices.dart';
import '../providers/authProvider.dart';
import '../providers/tracksProvider.dart';
import '../exceptionHandling/result.dart';
import '../providers/userStatsProvider.dart';
import '../exceptionHandling/appException.dart';
import '../exceptionHandling/errorHandler.dart';

/// Authentication services include logging user in, registering new user and silent sign in
///
/// To the base URI we send user's username and token to log them in after fetching from secure storage
/// For new user we pass two boolean values along with them
/// The response and request sample can be found on the link below
/// http://envirocar.github.io/enviroCar-server/api/

class AuthenticationServices {
  // The base uri for authentication
  final baseUri = 'https://envirocar.org/api/stable/users';

  // Creates a new User
  Future<String> registerUser({
    @required User user,
  }) async {
    final Uri uri = Uri.parse(baseUri);

    // The payload is the user object converted to a JSON object to be sent as the body
    final String jsonPayload = jsonEncode(user.toMap());

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonPayload,
    );

    /// After succesful registration the user is sent an email from where they to
    /// confirm their email to log in
    if (response.statusCode == 201) {
      return 'Mail Sent';
    } else {
      final decodedBody = jsonDecode(response.body);
      return decodedBody['message'] as String;
    }
  }

  // Logs in user
  Future<Result> loginUser({
    @required BuildContext context,
    @required User user,
  }) async {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final UserStatsProvider _userStatsProvider =
        Provider.of<UserStatsProvider>(context, listen: false);

    try {
      final dio.Response response = await dio.Dio().get(
        '$baseUri/${user.getUsername}',
        options: dio.Options(
          headers: {
            'X-User': user.getUsername,
            'X-Token': user.getPassword,
          },
        ),
      );

      SecureStorageServices().setUserInSecureStorage(
          username: user.getUsername, password: user.getPassword);

      final decodedBody = response.data;

      user.setEmail = decodedBody['mail'] as String;
      user.setAcceptedTerms = true;
      user.setAcceptedPrivacy = true;

      _authProvider.setUser = user;

      StatsServices().getUserStats(
        context: context,
      );

      _authProvider.setAuthStatus = true;
      return const Result.success(true);
    } catch (e) {
      final ApplicationException exception = handleException(e);
      return Result.failure(exception);
    }
  }

  // Logs in user if they didn't logout the last time they opened the app
  Future<Result> silentSignIn({@required BuildContext context}) async {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // We get the username and token stored in the secure storage
    final User user = await SecureStorageServices().getUserFromSecureStorage();

    if (user.getUsername != null && user.getPassword != null) {
      try {
        final Result result = await loginUser(
          context: context,
          user: user,
        );

        return result;
      } catch (e) {
        // If any error occures then handle it and show snackbar
        final ApplicationException exception = handleException(e);
        return Result.failure(exception);
      }
    } else {
      _authProvider.setAuthStatus = false;
      return const Result.success(false);
    }
  }

  // Log user out and deletes their username and token from secure storage
  void logoutUser({
    @required AuthProvider authProvider,
    @required UserStatsProvider userStatsProvider,
    @required TracksProvider tracksProvider,
  }) {
    SecureStorageServices().deleteUserFromSecureStorage();
    userStatsProvider.removeStats();
    tracksProvider.removeTracks();
    authProvider.removeUser();
  }
}
