import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/fueling.dart';
import '../dividerLine.dart';

class FuelingCard extends StatelessWidget {
  final Fueling fueling;

  const FuelingCard({@required this.fueling});

  @override
  Widget build(BuildContext context) {
    final double totalCost =
        (fueling.cost.value) / (fueling.volume.value) as double;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 8.0,
            offset: const Offset(3, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gas station icon and date
              // TODO: Add real date
              Row(
                children: const [
                  Icon(
                    Icons.ev_station_rounded,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Total Price
              Text(
                '\$${fueling.cost.value}',
                style: const TextStyle(
                  color: kSpringColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          DividerLine(),

          // Mileage and Fueled Volume
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${fueling.mileage.value} km - ${fueling.volume.value} L'),
              Text('${totalCost.toStringAsFixed(2)} \$/L'),
            ],
          ),
          const SizedBox(
            height: 20,
          ),

          // Car information
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.local_taxi),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  '${fueling.car.properties.model} ${fueling.car.properties.manufacturer}',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          // Comment
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.comment),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(fueling.comment),
              ),
            ],
          ),
          DividerLine(),

          // Partial Fill-Up and Missed Previous Fill-Up
          if (fueling.partialFueling)
            Row(
              children: const [
                Icon(Icons.check),
                SizedBox(
                  width: 10,
                ),
                Text('Partial Fill-up'),
              ],
            )
          else
            Container(),
          if (fueling.missedFuelStop)
            Row(
              children: const [
                Icon(Icons.check),
                SizedBox(
                  width: 10,
                ),
                Text('Missed Previous Fill-up'),
              ],
            )
          else
            Container(),
        ],
      ),
    );
  }
}
