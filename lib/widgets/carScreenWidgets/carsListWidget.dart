import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../models/car.dart';
import '../../providers/carsProvider.dart';
import '../../database/carsTable.dart';

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

  // Provider to set cars list in the data store and notify widgets
  CarsProvider carsProvider;

  @override
  void initState() {
    super.initState();

    carsProvider = Provider.of<CarsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarsProvider>(
      builder: (_, carsProvider, child) {
        final List<Car> carsList = carsProvider.getCarsList;
        final Car selectedCar = carsProvider.getSelectedCar;
        // Cars haven't been fetched from DB yet
        // Fetch them
        if (carsList == null) {
          _logger.i('getCarsFromDatabase called');
          CarsTable().getCarsFromDatabase(carsProvider: carsProvider);
          return const Center(
            child: Text(
              'There are no cars here',
            ),
          );
        }

        // Cars have been fetched from DB but it's empty
        else if (carsList.isEmpty) {
          return const Center(
            child: Text(
              'There are no cars here',
            ),
          );
        }

        // Cars have been fetched from DB and it's not empty
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
                      '${carsList[index].manufacturer} - ${carsList[index].model}'),
                  subtitle: Text(
                      '${carsList[index].constructionYear}, ${carsList[index].engineDisplacement}, ${carsList[index].fuelType}'),
                  trailing: Radio(
                    onChanged: (bool value) {},
                    groupValue: true,
                    value: selectedCar == null
                        ? false
                        : (carsList[index].id == selectedCar.id ? true : false),
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
