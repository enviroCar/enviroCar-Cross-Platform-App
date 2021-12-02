import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

import 'package:envirocar_app_main/models/fueling.dart';
import 'package:envirocar_app_main/providers/fuelingsProvider.dart';
import 'package:envirocar_app_main/models/car.dart';

void main() {
  testWidgets(
    'Update when the value changes',
    (tester) async {
      final _providerKey = GlobalKey();

      await tester.pumpWidget(
        ChangeNotifierProvider<FuelingsProvider>(
          key: _providerKey,
          create: (c) {
            return FuelingsProvider();
          },
          child: Container(),
        ),
      );

      /// Only the descendants of the `ChangeNotifierProvider<T>`
      /// can call `Provider.of<T>`, so find his context...
      final BuildContext childContext = tester.element(find.byType(Container));

      // Check the initial value provider to be null...
      expect(
        Provider.of<FuelingsProvider>(childContext, listen: false)
            .getFuelingsList,
        null,
      );

      // Set data in provider
      Provider.of<FuelingsProvider>(childContext, listen: false)
          .addFueling(_fueling);

      // Fetch the new data and check if it matches the one stored in it
      expect(
        Provider.of<FuelingsProvider>(childContext, listen: false)
            .getFuelingsList
            .length,
        1,
      );
    },
  );
}

final Fueling _fueling = Fueling(
  id: '1234',
  car: Car(),
  mileage: UnitValue(
    value: 32,
    unit: 'KILOMETRES',
  ),
  volume: UnitValue(
    value: 12,
    unit: 'LITRES',
  ),
  cost: UnitValue(
    value: 45,
    unit: 'EURO',
  ),
  partialFueling: false,
  missedFuelStop: true,
  comment: 'Hello There',
  fuelType: 'HYBRID',
);
