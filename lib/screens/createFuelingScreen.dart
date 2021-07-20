import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/car.dart';
import '../models/fueling.dart';
import '../providers/carsProvider.dart';
import '../providers/fuelingsProvider.dart';
import '../widgets/singleRowForm.dart';
import '../widgets/button.dart';
import '../widgets/dividerLine.dart';
import '../widgets/titleWidget.dart';
import '../constants.dart';

// Screen to create fueling logs
class CreateFuelingScreen extends StatefulWidget {
  static const String routeName = '/createFuelingScreen';

  @override
  _CreateFuelingScreenState createState() => _CreateFuelingScreenState();
}

class _CreateFuelingScreenState extends State<CreateFuelingScreen> {
  // Form key to validate the fueling form
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool partialFueling;
  bool missedPreviousFueling;

  Car selectedCar;

  // Controllers for textfields to fetch the input data
  TextEditingController mileageController;
  TextEditingController fueledVolumeController;
  TextEditingController pricePerLitreController;
  TextEditingController totalPriceController;
  TextEditingController commentController;

  // Triggered when 'Add' button is pressed after filling the form
  // Creates the fueling object and stores it in Provider
  void addFueling() {
    if (_formKey.currentState.validate()) {
      final Fueling fueling = Fueling(
        // TODO: generate uuid for id
        id: '32',
        car: selectedCar,
        mileage: mileageController.text,
        fueledVolume: fueledVolumeController.text,
        totalPrice: totalPriceController.text,
        pricePerLitre: pricePerLitreController.text,
        partialFueling: partialFueling,
        missedPreviousFueling: missedPreviousFueling,
        comment: commentController.text,
      );

      // Provider instance to add the new fueling log to the list
      final FuelingsProvider fuelingsProvider =
          Provider.of<FuelingsProvider>(context, listen: false);

      fuelingsProvider.addFueling(fueling);

      // Navigates user to the Log book screen after fueling log is added
      Navigator.of(context).pop();
    }
  }

  // Navigates user to the Log book screen when 'Cancel' button is pressed
  void cancelFueling() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    partialFueling = false;
    missedPreviousFueling = false;

    mileageController = TextEditingController();
    fueledVolumeController = TextEditingController();
    pricePerLitreController = TextEditingController();
    totalPriceController = TextEditingController();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        // enviroCar logo
        title: const Text('LogBook'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          15,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleWidget(title: 'Fueling Detals'),
              const SizedBox(
                height: 20,
              ),

              // Consumer provides the Cars data in the dropdown button
              Consumer<CarsProvider>(
                builder: (_, carsProvider, child) {
                  final List<Car> carsList = carsProvider.getCarsList;

                  // Drop Down button to select Car
                  return DropdownButtonFormField<Car>(
                    decoration: inputDecoration.copyWith(
                      labelText: 'Car',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Required';
                      }
                      return null;
                    },
                    elevation: 24,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    value: selectedCar,
                    onChanged: (Car newValue) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        selectedCar = newValue;
                      });
                    },
                    items: List.generate(
                      carsList.length,
                      (index) {
                        return DropdownMenuItem<Car>(
                          value: carsList[index],
                          child: Text(
                              '${carsList[index].manufacturer} ${carsList[index].model}'),
                        );
                      },
                    ),
                  );
                },
              ),
              DividerLine(),

              // Mileage textfield
              SingleRowForm(
                title: 'Mileage',
                hint: '0.00 km',
                textEditingController: mileageController,
              ),

              // Fueled volume textfield
              SingleRowForm(
                title: 'Fueled Volume',
                hint: '0.00 I',
                textEditingController: fueledVolumeController,
              ),

              // Price per litre textfield
              SingleRowForm(
                title: 'Price per litre',
                hint: '0.00 \$/L',
                textEditingController: pricePerLitreController,
              ),

              // Total price textfield
              SingleRowForm(
                title: 'Total Price',
                hint: '0.00 \$',
                textEditingController: totalPriceController,
              ),
              DividerLine(),

              // Checkbox for partial fueling
              CheckboxListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text('Partial Fueling?'),
                value: partialFueling,
                onChanged: (bool val) {
                  setState(() {
                    partialFueling = val;
                  });
                },
              ),

              // Checkbox for missed previous fueling
              CheckboxListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text('Missed Previous Fueling?'),
                value: missedPreviousFueling,
                onChanged: (bool val) {
                  setState(() {
                    missedPreviousFueling = val;
                  });
                },
              ),
              DividerLine(),

              // Textfield for comments
              TextFormField(
                decoration: inputDecoration.copyWith(
                  labelText: 'Comments',
                ),
                maxLines: 5,
                controller: commentController,
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
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: Button(
                      title: 'Cancel',
                      onTap: cancelFueling,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  // Add button
                  Expanded(
                    child: Button(
                      title: 'Add',
                      onTap: addFueling,
                      color: kSpringColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
