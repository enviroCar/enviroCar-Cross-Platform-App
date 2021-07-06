import 'package:flutter/foundation.dart';

import '../models/user.dart';

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
