import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';
import '../../globals.dart';

class DashboardCard extends StatelessWidget {
  final String assetName;
  final String title;
  final String subtitle;
  final String routeName;
  final Color iconBackgroundColor;

  const DashboardCard({
    @required this.assetName,
    @required this.title,
    @required this.subtitle,
    @required this.routeName,
    this.iconBackgroundColor: kSpringColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
      child: Container(
        height: deviceHeight * 0.12,
        width: deviceWidth * 0.9,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: deviceHeight * 0.15,
                  width: deviceWidth * 0.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBackgroundColor,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      assetName,
                      color: Colors.white,
                      width: deviceHeight * 0.04,
                      height: deviceHeight * 0.04,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceHeight * 0.02,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: deviceHeight * 0.018,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              child: Icon(
                Icons.arrow_forward,
                size: deviceHeight * 0.035,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 8.0,
              offset: Offset(3, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
