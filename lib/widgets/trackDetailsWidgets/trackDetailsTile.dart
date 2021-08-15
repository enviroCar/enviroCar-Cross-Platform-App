import 'package:flutter/material.dart';

import '../../constants.dart';

class TrackDetailsTile extends StatelessWidget {
  final String title;
  final String details;
  final IconData iconData;

  const TrackDetailsTile({@required this.title, @required this.details, @required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              iconData,
              color: kSpringColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              title,
              style: TextStyle(
                  color: kGreyColor.withOpacity(0.8),
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              width: 140,
              child: Text(
                details,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: kGreyColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}