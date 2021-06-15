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

        // enviroCar logo
        title: Image.asset(
          'assets/images/img_envirocar_logo_white.png',
          scale: 10,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(CreateCarScreen.routeName);
        },
      ),
      body: Container(
        child: Consumer<CarsProvider>(
          builder: (_, carsProvider, child) {
            List<Car> carsList = carsProvider.getCarsList;
            print(carsList.length);
            if (carsList.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: carsProvider.getCarsList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Icon(Icons.drive_eta_sharp),
                    title: Text(carsProvider.getCarsList[index].manufacturer +
                        ' - ' +
                        carsProvider.getCarsList[index].model),
                    subtitle: Text(carsProvider
                            .getCarsList[index].constructionYear
                            .toString() +
                        ', ' +
                        carsProvider.getCarsList[index].engineDisplacement
                            .toString() +
                        ', ' +
                        carsProvider.getCarsList[index].fuelType),
                    trailing: Radio(
                      onChanged: (bool value) {},
                      groupValue: true,
                      value: carsProvider.getCarsList[index].isSelected,
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
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      // Expanded(
      //   flex: 1,
      //   // width: double.infinity,
      //   child: Container(
      //     padding: EdgeInsets.only(left: 15),
      //     width: double.infinity,
      //     child: Align(
      //       alignment: Alignment.centerLeft,
      //       child: Text(
      //         'My Cars',
      //         style: TextStyle(
      //           color: Color.fromARGB(255, 23, 33, 43),
      //           fontSize: 20,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // Expanded(
      //   flex: 10,
      //   child:

      // ),
      //   ],
      // ),
    );
  }
}
