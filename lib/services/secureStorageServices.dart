import 'package:flutter/foundation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class SecureStorageServices {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<User> getUserFromSecureStorage() async {
    String username = await _secureStorage.read(key: 'username');
    String password = await _secureStorage.read(key: 'password');

    User user = new User(
      username: username,
      password: password,
    );

    return user;
  }

  Future<void> setUserInSecureStorage(
      {@required String username, @required String password}) async {
    _secureStorage.write(key: 'username', value: username);
    _secureStorage.write(key: 'password', value: password);
  }

  void deleteUserFromSecureStorage() {
    _secureStorage.delete(key: 'username');
    _secureStorage.delete(key: 'password');
  }
}
