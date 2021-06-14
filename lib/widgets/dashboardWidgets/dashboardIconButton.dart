import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';
import '../../globals.dart';

class DashboardIconButton extends StatelessWidget {
  final String routeName;
  final String assetName;
  const DashboardIconButton({
    @required this.routeName,
    @required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            routeName,
          );
        },
        child: Container(
          height: deviceHeight * 0.09,
          width: deviceHeight * 0.09,
          decoration: BoxDecoration(
            color: kSpringColor,
            borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }
}
