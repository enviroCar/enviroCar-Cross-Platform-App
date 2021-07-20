import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../globals.dart';
import '../models/fueling.dart';
import '../providers/fuelingsProvider.dart';
import './createFuelingScreen.dart';
import '../widgets/logbookWidgets/fuelingCard.dart';
import '../widgets/titleWidget.dart';

// Screen that displays all the fueling logs
class LogBookScreen extends StatelessWidget {
  static const routeName = '/logBookScreen';

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
