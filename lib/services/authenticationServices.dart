import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../models/user.dart';
import './secureStorageServices.dart';
import './statsServices.dart';
import '../providers/userStatsProvider.dart';
import '../providers/tracksProvider.dart';
import '../exceptionHandling/appException.dart';
import '../exceptionHandling/errorHandler.dart';
import '../exceptionHandling/result.dart';

class AuthenticationServices {
  final baseUri = 'https://envirocar.org/api/stable/users';

  // Creates a new User
  Future<String> registerUser({
    @required User user,
  }) async {
    final Uri uri = Uri.parse(baseUri);

    final String jsonPayload = jsonEncode(user.toMap());

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonPayload,
    );

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
    final User user = await SecureStorageServices().getUserFromSecureStorage();

    if (user.getUsername != null && user.getPassword != null) {
      try {
        final Result result = await loginUser(
          context: context,
          user: user,
        );

        return result;
      } catch (e) {
        final ApplicationException exception = handleException(e);
        return Result.failure(exception);
      }
    } else {
      _authProvider.setAuthStatus = false;
      return const Result.success(false);
    }
  }

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
