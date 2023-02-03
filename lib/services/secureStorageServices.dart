import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class SecureStorageServices {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Fetches data stored locally on a secure storage
  Future<User?> getUserFromSecureStorage() async {
    final String? username = await _secureStorage.read(key: 'username');
    final String? password = await _secureStorage.read(key: 'password');

    if (username == null || password == null) {
      return null;
    }
    final User? user = User(
        username: username,
        password: password,
        acceptedPrivacy: false,
        acceptedTerms: false);

    return user;
  }

  // Sets data in secure storage on the device
  Future<void> setUserInSecureStorage({
    required String username,
    required String password,
  }) async {
    _secureStorage.write(key: 'username', value: username);
    _secureStorage.write(key: 'password', value: password);
  }

  // Removes data from secure storage from device
  void deleteUserFromSecureStorage() {
    _secureStorage.delete(key: 'username');
    _secureStorage.delete(key: 'password');
  }
}
