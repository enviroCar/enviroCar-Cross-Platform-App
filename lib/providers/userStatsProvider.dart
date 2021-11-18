import 'package:flutter/foundation.dart';

import '../models/userStats.dart';

class UserStatsProvider with ChangeNotifier {
  UserStats _userStats;

  UserStats get getUserStats {
    return _userStats;
  }

  /// function to set [UserStats]
  set setUserStats(UserStats userStats) {
    _userStats = userStats;
    notifyListeners();
  }

  /// function to remove stats when user sign out
  void removeStats() {
    _userStats = null;
  }
}
