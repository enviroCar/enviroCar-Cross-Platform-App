import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/carsProvider.dart';
import './createCarScreen.dart';
import '../models/car.dart';
import '../constants.dart';

class CarScreen extends StatefulWidget {
  static const routeName = '/carScreen';

  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.add),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(CreateCarScreen.routeName);
            },
          ),
        ],

        // enviroCar logo
        title: Image.asset(
          'assets/images/img_envirocar_logo_white.png',
          scale: 10,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Consumer<CarsProvider>(
          builder: (_, carsProvider, child) {
            List<Car> carsList = carsProvider.getCarsList;
            Car selectedCar = carsProvider.getSelectedCar;
            if (carsList.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: carsList.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      carsProvider.setSelectedCar = carsList[index];
                    },
                    child: ListTile(
                      leading: Icon(Icons.drive_eta_sharp),
                      title: Text(carsList[index].manufacturer +
                          ' - ' +
                          carsList[index].model),
                      subtitle: Text(
                          carsList[index].constructionYear.toString() +
                              ', ' +
                              carsList[index].engineDisplacement.toString() +
                              ', ' +
                              carsList[index].fuelType),
                      trailing: Radio(
                        onChanged: (bool value) {},
                        groupValue: true,
                        value: selectedCar == null
                            ? false
                            : (carsList[index].id == selectedCar.id
                                ? true
                                : false),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: Text(
                'There are no cars here',
              ),
            );
          },
        ),
      ),
    );
  }
}
