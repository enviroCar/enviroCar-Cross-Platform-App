import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../constants.dart';
import '../models/fueling.dart';
import './createFuelingScreen.dart';
import '../widgets/titleWidget.dart';
import '../services/fuelingServices.dart';
import '../exceptionHandling/result.dart';
import '../hiveDB/fuelingsCollection.dart';
import '../providers/fuelingsProvider.dart';
import '../exceptionHandling/exceptionType.dart';
import '../widgets/logbookWidgets/fuelingCard.dart';

// Screen that displays all the fueling logs
class LogBookScreen extends StatelessWidget {
  static const routeName = '/logBookScreen';

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        actions: [
          // Button to navigate to CreateFuelingScreen
          GestureDetector(
            onTap: () {
              _logger.i('Going to create fueling screen');
              Navigator.of(context).pushNamed(CreateFuelingScreen.routeName);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.add),
            ),
          ),
        ],

        // enviroCar logo
        title: const Text('LogBook'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),

        // Consumer provides all the fueling logs
        child: Consumer<FuelingsProvider>(
          builder: (_, fuelingsProvider, child) {
            final List<Fueling> fuelingsList = fuelingsProvider.getFuelingsList;

            if (fuelingsList == null) {
              FuelingServices().getFuelingsFromServer(context: context).then(
                (Result result) {
                  if (result.status == ResultStatus.error) {
                    // if the error type is no internet then fetch fuelings from Hive
                    if (result.exception.type ==
                        ExceptionType.noInternetConnection) {
                      FuelingsCollection()
                          .getFuelingsFromHive(context: context);
                    }
                    // for any other error show snackbar with message
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(result.exception.getErrorMessage()),
                        ),
                      );
                    }
                  }
                },
              );
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // If there are no logs then show 'No logs' image
            if (fuelingsList.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWidget(title: 'My Fuelings'),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image of no logs
                          Image.asset(
                            'assets/images/img_logbook.png',
                            height: deviceHeight * 0.3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'NO FUELINGS',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'There are no fuelings assigned\nto the current user',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // else show the fueling logs in a list
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const TitleWidget(title: 'Your Fuelings'),

                    // Creates fueling cards by taking data from fuelings provider
                    for (Fueling fuelings in fuelingsList)
                      FuelingCard(fueling: fuelings)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
