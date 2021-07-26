import 'package:flutter/material.dart';

import '../../constants.dart';

class TrackDetailsTile extends StatelessWidget {
  final String title;
  final String subTitle;

  const TrackDetailsTile({@required this.title, @required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Row(
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor.withOpacity(0.8),
                  letterSpacing: 1
              ),
            ),
            const Spacer(),
            Text(
              subTitle,
              style: TextStyle(
                color: kPrimaryColor.withOpacity(0.6),
              ),
            ),
          ]
      ),
    );
  }
}