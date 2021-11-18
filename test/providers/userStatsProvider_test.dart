import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:envirocar_app_main/models/userStats.dart';
import 'package:envirocar_app_main/providers/userStatsProvider.dart';

void main() {
  testWidgets(
    'Update when the value changes',
    (tester) async {
      final _providerKey = GlobalKey();

      await tester.pumpWidget(
        ChangeNotifierProvider<UserStatsProvider>(
          key: _providerKey,
          create: (c) {
            return UserStatsProvider();
          },
          child: Container(),
        ),
      );

      /// Only the descendants of the `ChangeNotifierProvider<T>`
      /// can call `Provider.of<T>`, so find his context...
      final BuildContext childContext = tester.element(find.byType(Container));

      // Check the initial value provider to be null...
      expect(
          Provider.of<UserStatsProvider>(childContext, listen: false)
              .getUserStats,
          null);

      // Set data in provider
      Provider.of<UserStatsProvider>(childContext, listen: false).setUserStats =
          UserStats(trackCount: 2);

      // Fetch the new data and check if it matches the one stored in it
      expect(
          Provider.of<UserStatsProvider>(childContext, listen: false)
              .getUserStats
              .trackCount,
          2);
    },
  );
}
