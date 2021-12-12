import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

import 'package:envirocar_app_main/providers/tracksProvider.dart';

void main() {
  testWidgets(
    'Update when the value changes',
    (tester) async {
      final _providerKey = GlobalKey();

      await tester.pumpWidget(
        ChangeNotifierProvider<TracksProvider>(
          key: _providerKey,
          create: (c) {
            return TracksProvider();
          },
          child: Container(),
        ),
      );

      /// Only the descendants of the `ChangeNotifierProvider<T>`
      /// can call `Provider.of<T>`, so find his context...
      final BuildContext childContext = tester.element(find.byType(Container));

      // Check the initial value provider to be null...
      expect(
        Provider.of<TracksProvider>(childContext, listen: false).getTracks(),
        null,
      );

      // Set data in provider
      Provider.of<TracksProvider>(childContext, listen: false)
          .setTracks(tracksJsonList);

      // Fetch the new data and check if it matches the one stored in it
      expect(
        Provider.of<TracksProvider>(childContext, listen: false)
            .getTracks()
            .length,
        2,
      );

      // Remove data in provider
      Provider.of<TracksProvider>(childContext, listen: false).removeTracks();

      // Fetch the new data and check if it matches the one stored in it
      expect(
        Provider.of<TracksProvider>(childContext, listen: false)
            .getTracks()
            .length,
        0,
      );
    },
  );
}

final Map<String, dynamic> tracksJsonList = {
  "tracks": [
    {
      "id": "60fa640b0bd6756ea33da7dd",
      "length": 9.12021693011568,
      "begin": "2021-07-22T17:23:09Z",
      "end": "2021-07-22T17:38:41Z",
      "sensor": {
        "type": "car",
        "properties": {
          "engineDisplacement": 1595,
          "model": "Golf V Plus 1.6",
          "id": "5fd9d14e05fa792e88dc8b7b",
          "fuelType": "gasoline",
          "constructionYear": 2006,
          "manufacturer": "VW"
        }
      }
    },
    {
      "id": "60fa640a0bd6756ea33da583",
      "length": 1.3444958839760286,
      "begin": "2021-07-22T17:04:28Z",
      "end": "2021-07-22T17:07:02Z",
      "sensor": {
        "type": "car",
        "properties": {
          "engineDisplacement": 1595,
          "model": "Golf V Plus 1.6",
          "id": "5fd9d14e05fa792e88dc8b7b",
          "fuelType": "gasoline",
          "constructionYear": 2006,
          "manufacturer": "VW"
        }
      }
    },
  ],
};
