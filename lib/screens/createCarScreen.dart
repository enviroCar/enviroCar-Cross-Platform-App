import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart' as constants;
import '../models/car.dart';
import '../providers/carsProvider.dart';
import '../globals.dart';
import '../widgets/button.dart';

class CreateCarScreen extends StatefulWidget {
  static const routeName = '/createCarScreen';
  @override
  _CreateCarScreenState createState() => _CreateCarScreenState();
}

class _CreateCarScreenState extends State<CreateCarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Car newCar = Car();

  void createCar() {
    if (_formKey.currentState.validate()) {
      Uuid uuid = Uuid();
      newCar.id = uuid.v1();

      print(newCar.id);

      CarsProvider carsProvider =
          Provider.of<CarsProvider>(context, listen: false);

      carsProvider.addCar(newCar);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 33, 43),
        elevation: 0,

        // enviroCar logo
        title: Image.asset(
          'assets/images/img_envirocar_logo_white.png',
          scale: 10,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: deviceHeight,
          width: deviceWidth,
          padding:
              EdgeInsets.fromLTRB(deviceWidth * 0.05, 0, deviceWidth * 0.05, 0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: deviceHeight * 0.03),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Please enter the details of your vehicle. Be precise. Parts of this information are especially important for calculating estimated values such as consumption.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),

                  // Manufacturer
                  TextFormField(
                    decoration: constants.inputDecoration.copyWith(
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

                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),

                  // Model
                  TextFormField(
                    decoration: constants.inputDecoration.copyWith(
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

                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),

                  // Construction year
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: constants.inputDecoration.copyWith(
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

                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),

                  // Fuel Type
                  TextFormField(
                    decoration: constants.inputDecoration.copyWith(
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

                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),

                  // Engine Displacement
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: constants.inputDecoration.copyWith(
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

                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),

                  // Login Button
                  Button(
                    title: 'Create Car',
                    color: constants.kSpringColor,
                    onTap: createCar,
                  ),

                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
