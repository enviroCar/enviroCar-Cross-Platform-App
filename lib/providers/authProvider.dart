import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User _user;
  bool _authStatus;

  /// function to set [User]
  set setUser(User user) {
    _user = user;
  }

  /// function to get currently signed in [User]
  User get getUser {
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
    setUser = null;
    setAuthStatus = false;
  }
}
