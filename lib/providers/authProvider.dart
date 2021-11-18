import 'package:flutter/foundation.dart';

import '../models/user.dart';

/// provides user's data and current auth status (logged in or out)
///
/// it is used to fetch user's username and token for http calls
/// and also to set the status true or false corresponding to which
/// login screen and dashboard screen are drawn

class AuthProvider with ChangeNotifier {
  User _user;
  bool _authStatus;

  set setUser(User user) {
    _user = user;
  }

  User get getUser {
    return _user;
  }

  set setAuthStatus(bool authStatus) {
    _authStatus = authStatus;

    notifyListeners();
  }

  bool get getAuthStatus {
    return _authStatus;
  }

  void removeUser() {
    setUser = null;
    setAuthStatus = false;
  }
}
