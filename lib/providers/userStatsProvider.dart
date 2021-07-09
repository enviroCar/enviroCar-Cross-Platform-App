import 'package:flutter/foundation.dart';

import '../models/userStats.dart';

class UserStatsProvider with ChangeNotifier {
  UserStats _userStats;

  UserStats get getUserStats {
    return _userStats;
  }

  set setUserStats(UserStats userStats) {
    _userStats = userStats;
    notifyListeners();
  }

  void removeStats() {
    _userStats = null;
  }
}
