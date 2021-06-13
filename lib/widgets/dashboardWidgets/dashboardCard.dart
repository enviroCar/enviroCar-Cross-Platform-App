import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class DashboardCard extends StatelessWidget {
  final double width;
  final double height;
  final String assetName;
  final String title;
  final String subtitle;

  const DashboardCard({
    @required this.height,
    @required this.width,
    @required this.assetName,
    @required this.title,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kSpringColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        assetName,
                        color: Colors.white,
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
                        ),
                      ),
                      Text(subtitle),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                child: Icon(
                  Icons.arrow_forward,
                ),
              ),
            ],
          ),
          height: height * 0.12,
          width: width * 0.9,
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
      ),
    );
  }
}
