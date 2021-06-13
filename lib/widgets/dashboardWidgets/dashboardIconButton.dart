import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            routeName,
          );
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: kSpringColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              assetName,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
