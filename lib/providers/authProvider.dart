import 'package:flutter/foundation.dart';

import '../models/user.dart';

/// provides user's data and current auth status (logged in or out)
///
/// it is used to fetch user's username and token for http calls
/// and also to set the status true or false corresponding to which
/// login screen and dashboard screen are drawn

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _authStatus = false;

  /// function to set [User]
  set setUser(User user) {
    _user = user;
  }

  /// function to get currently signed in [User]
  User? get getUser {
    return _user;
  }

  /// function to set [_authStatus]
  set setAuthStatus(bool authStatus) {
    _authStatus = authStatus;

    notifyListeners();
  }

  /// function to get [_authStatus]
  bool get getAuthStatus {
    return _authStatus;
  }

  /// function to remove user (sign out)
  void removeUser() {
    _user = null;
    setAuthStatus = false;
  }
}
