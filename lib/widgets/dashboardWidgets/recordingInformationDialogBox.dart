import 'package:flutter/material.dart';

import '../../constants.dart';

class RecordingInformationDialogBox extends StatelessWidget {
  final VoidCallback onButtonTap;

  const RecordingInformationDialogBox({
    @required this.onButtonTap,
});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: kSpringColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/img_envirocar_logo_white.png',
            scale: 12,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              'You can start your track recording by tapping the "Start Recording" button below. Personal Location information and data collected from the OBD-II device get recorded. You can also edit your location data sharing preferences by toggling the parameters you do not want to record from the data privacy and control settings.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            onButtonTap();
          },
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: kSpringColor,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                child: const Text(
                  'Start Recording',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to Data Privacy and Control Settings
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  margin: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: const Text(
                    'Location Data Sharing Preferences',
                    style: TextStyle(
                      color: kLightGrayColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
