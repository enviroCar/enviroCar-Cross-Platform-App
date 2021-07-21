import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/car.dart';
import '../../providers/carsProvider.dart';
import '../button.dart';
import '../../database/carsTable.dart';
import '../../database/databaseHelper.dart';

class AttributesOption extends StatefulWidget {
  static const routeName = '/createCarScreen';
  @override
  _AttributesOptionState createState() => _AttributesOptionState();
}

class _AttributesOptionState extends State<AttributesOption> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Car newCar = Car();

  Future<void> createCar() async {
    if (_formKey.currentState.validate()) {
      final CarsProvider carsProvider =
          Provider.of<CarsProvider>(context, listen: false);

      carsProvider.addCar(newCar);
      await DatabaseHelper.instance.insertValue(
        tableName: CarsTable.tableName,
        data: newCar.toJson(),
      );

      Navigator.pop(context);
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
                  newCar.manufacturer = value;
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
                  newCar.model = value;
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
                  newCar.constructionYear = int.parse(value);
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
                  newCar.fuelType = value;
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
                  newCar.engineDisplacement = int.parse(value);
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
