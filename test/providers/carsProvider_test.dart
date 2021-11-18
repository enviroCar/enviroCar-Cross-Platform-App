import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

import 'package:envirocar_app_main/providers/carsProvider.dart';
import 'package:envirocar_app_main/models/car.dart';

void main() {
  testWidgets(
    'Update when the value changes',
    (tester) async {
      final _providerKey = GlobalKey();

      await tester.pumpWidget(
        ChangeNotifierProvider<CarsProvider>(
          key: _providerKey,
          create: (c) {
            return CarsProvider();
          },
          child: Container(),
        ),
      );

      /// Only the descendants of the `ChangeNotifierProvider<T>`
      /// can call `Provider.of<T>`, so find his context...
      final BuildContext childContext = tester.element(find.byType(Container));

      // Check the initial value provider to be null...
      expect(
        Provider.of<CarsProvider>(childContext, listen: false).getSelectedCar,
        null,
      );

      // Check the initial value provider to be null...
      expect(
        Provider.of<CarsProvider>(childContext, listen: false).getCarsList,
        null,
      );

      // Set data in provider
      Provider.of<CarsProvider>(childContext, listen: false).setSelectedCar =
          Car(
        type: "car",
        properties: Properties(
          id: 'dummyID',
          constructionYear: 2020,
          engineDisplacement: 3600,
          fuelType: 'HYBRID',
          manufacturer: 'Toyota',
          model: 'Pentagon',
        ),
      );

      // Fetch the new data and check if it matches the one stored in it
      expect(
        Provider.of<CarsProvider>(childContext, listen: false).getSelectedCar
          ..properties.fuelType,
        'HYBRID',
      );
    },
  );
}
