import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/car.dart';
import '../../providers/carsProvider.dart';
import '../../hiveDB/sensorsCollection.dart';

class CarsListWidget extends StatefulWidget {
  @override
  _CarsListWidgetState createState() => _CarsListWidgetState();
}

class _CarsListWidgetState extends State<CarsListWidget> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<CarsProvider>(
      builder: (_, carsProvider, child) {
        final List<Car> carsList = carsProvider.getCarsList;
        final Car selectedCar = carsProvider.getSelectedCar;

        // Cars haven't been fetched from Hive yet so fetch them
        if (carsList == null) {
          _logger.i('getCarsFromDatabase called');

          // delaying to avoid rebuilding before the widget is built
          Future.delayed(
            const Duration(),
            () => CarsCollection().getCarsFromHive(context: context),
          );

          return const Center(
            child: CircularProgressIndicator(
              color: kSpringColor,
            ),
          );
        }

        // Cars have been fetched from Hive but it's empty
        else if (carsList.isEmpty) {
          return const Center(
            child: Text(
              'There are no cars here',
            ),
          );
        }

        // Cars have been fetched from Hive and it's not empty
        else {
          return ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: carsList.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  carsProvider.setSelectedCar = carsList[index];
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: const Icon(Icons.drive_eta_sharp),
                  title: Text(
                      '${carsList[index].properties.manufacturer} - ${carsList[index].properties.model}'),
                  subtitle: Text(
                      '${carsList[index].properties.constructionYear}, ${carsList[index].properties.engineDisplacement}, ${carsList[index].properties.fuelType}'),
                  trailing: Radio(
                    onChanged: (bool value) {},
                    groupValue: true,
                    value: selectedCar == null
                        ? false
                        : (carsList[index].properties.id ==
                                selectedCar.properties.id
                            ? true
                            : false),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
