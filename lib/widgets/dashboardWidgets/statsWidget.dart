import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import '../../constants.dart';
import '../../models/userStats.dart';
import '../../providers/userStatsProvider.dart';

class StatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.20,
      width: double.infinity,
      color: kGreyColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Consumer<UserStatsProvider>(
          builder: (context, userStatsProvider, child) {
            final UserStats? userStats = userStatsProvider.getUserStats;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: deviceWidth * 0.3,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 65, 80, 100),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userStats == null
                            ? '...'
                            : userStats.trackCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceHeight * 0.035,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Text(
                        'Total Tracks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: deviceWidth * 0.3,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 65, 80, 100),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userStats == null || userStats.distance == null
                            ? '...'
                            : userStats.distance!.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceHeight * 0.035,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Text(
                        'Total Distance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: deviceWidth * 0.3,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 65, 80, 100),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userStats == null || userStats.duration == null
                            ? '...'
                            : userStats.duration!.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceHeight * 0.035,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Text(
                        'Total Time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceHeight * 0.02,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
