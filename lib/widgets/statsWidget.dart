import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/userStats.dart';
import '../providers/userStatsProvider.dart';

class StatsWidget extends StatelessWidget {
  final double height;
  final double width;

  StatsWidget({
    @required this.height,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.20,
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
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'Total Tracks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  width: width * 0.3,
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
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'Total Distance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  width: width * 0.3,
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
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'Total Time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  width: width * 0.3,
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
