import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/carsProvider.dart';
import '../button.dart';
import '../../exceptionHandling/result.dart';
import '../../hiveDB/sensorsCollection.dart';
import '../../models/car.dart';
import '../../providers/authProvider.dart';
import '../../services/carServices.dart';

class AttributesOption extends StatefulWidget {
  static const routeName = '/createCarScreen';
  @override
  _AttributesOptionState createState() => _AttributesOptionState();
}

class _AttributesOptionState extends State<AttributesOption> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Properties newProperties = Properties();

  Future<void> createCar() async {
    if (_formKey.currentState.validate()) {
      _logger.i('createCar called');
      final AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);

      final CarsProvider carsProvider =
          Provider.of<CarsProvider>(context, listen: false);

      final Car newCar = Car(
        username: authProvider.getUser.getUsername,
        type: 'car',
        properties: newProperties,
      );

      // upload car to server
      await CarServices().uploadCarToServer(context: context, car: newCar).then(
        (Result result) {
          if (result.status == ResultStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(result.exception.getErrorMessage()),
              ),
            );
          }

          // if uploading to server is successful
          else {
            // get the ID from headers
            final String carID = result.value as String;

            // set the ID fetched to the car object
            newCar.properties.id = carID;

            // set username in fueling object to identify the creator when
            // fetching from Hive
            final AuthProvider authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            newCar.username = authProvider.getUser.getUsername;

            // store the data in local db
            CarsCollection().addCarToHive(car: newCar.toJson());

            // add car to the list to show on cars screen
            carsProvider.addCar(newCar);

            // close the screen and go back to prev screen
            Navigator.pop(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Please enter the details of your vehicle by attributes. Be precise. Parts of this information are especially important for calculating estimated values such as consumption.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Manufacturer
              TextFormField(
                decoration: inputDecoration.copyWith(
                  labelText: 'Manufacturer',
                ),
                onChanged: (value) {
                  newProperties.manufacturer = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // Model
              TextFormField(
                decoration: inputDecoration.copyWith(
                  labelText: 'Model',
                ),
                onChanged: (value) {
                  newProperties.model = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // Construction year
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: inputDecoration.copyWith(
                  labelText: 'Construction year',
                ),
                onChanged: (value) {
                  newProperties.constructionYear = int.parse(value);
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // Fuel Type
              TextFormField(
                decoration: inputDecoration.copyWith(
                  labelText: 'Fuel Type',
                ),
                onChanged: (value) {
                  newProperties.fuelType = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // Engine Displacement
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: inputDecoration.copyWith(
                  labelText: 'Engine Displacement',
                ),
                onChanged: (value) {
                  newProperties.engineDisplacement = int.parse(value);
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Required';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // Login Button
              Button(
                title: 'Create Car',
                color: kSpringColor,
                onTap: createCar,
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
