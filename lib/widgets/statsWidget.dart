import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/userStats.dart';
import '../providers/userStatsProvider.dart';
import '../globals.dart';

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
            UserStats userStats = userStatsProvider.getUserStats;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                  width: deviceWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 65, 80, 100),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userStats == null
                            ? '...'
                            : userStats.distance.toString(),
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
                  width: deviceWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 65, 80, 100),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userStats == null
                            ? '...'
                            : userStats.duration.toString(),
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
                  width: deviceWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 65, 80, 100),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
