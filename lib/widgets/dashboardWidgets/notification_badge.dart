import 'package:flutter/material.dart';

import '../../constants.dart';

class NotificationBadge extends StatelessWidget {
  final int notifications;

  const NotificationBadge({this.notifications = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              right: 10,
              top: 4,
            ),
            child: Icon(
              Icons.notifications,
              color: kWhiteColor,
            ),
          ),
          if (notifications > 0)
            const Positioned(
              right: 5,
              top: 0,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: kErrorColor,
                child: Text(
                  '5',
                  style: TextStyle(
                    fontSize: 12,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
