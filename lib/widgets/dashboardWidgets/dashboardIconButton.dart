import 'package:flutter/material.dart';

import '../../constants.dart';

class DashboardIconButton extends StatelessWidget {
  final String routeName;
  final IconData iconDate;
  const DashboardIconButton({
    @required this.routeName,
    @required this.iconDate,
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
          child: Icon(
            iconDate,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
