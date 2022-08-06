import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class UploadTrackDialogBox extends StatefulWidget {
  final String trackName;
  final Function uploadTrack;

  const UploadTrackDialogBox({
    @required this.trackName,
    @required this.uploadTrack,
  });

  @override
  State<UploadTrackDialogBox> createState() => _UploadTrackDialogBoxState();
}

class _UploadTrackDialogBoxState extends State<UploadTrackDialogBox> {
  bool uploaded;

  @override
  void initState() {
    uploaded = false;
    super.initState();
  }

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
        children: uploaded
            ? [
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: const Text(
                    'Uploaded Successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: kSpringColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/checkCircle.svg',
                    color: kSpringColor,
                    width: 82,
                    height: 80,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'Your track',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${widget.trackName} ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'has been successfully uploaded to the server. The location data you shared is latitude, longitude along with that you vehicle speed, CO2 emission etc.',
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            : [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 8,
                  ),
                  child: const Text(
                    'Are you sure?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: kSpringColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'Are you sure you want to upload the track',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${widget.trackName} ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'to the server as open data. Once you upload it to the server, you are sharing your location data with them and once uploaded the data cannot be deleted.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
      ),
      actions: [
        Column(
          children: [
            if (uploaded)
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
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
                  child: Text(
                    'Close'.toUpperCase(),
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: DialogBoxButton(
                        title: 'Yes',
                        callback: () async {
                          await widget.uploadTrack();

                          Future.delayed(
                            Duration.zero,
                          ).then(
                            (value) => setState(() {
                              uploaded = true;
                            }),
                          );
                        },
                        buttonColor: kSpringColor,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: DialogBoxButton(
                        title: 'Cancel',
                        callback: () {
                          Navigator.of(context).pop();
                        },
                        buttonColor: kErrorColor,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ],
    );
  }
}

class DialogBoxButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final Color buttonColor;

  const DialogBoxButton({
    @required this.title,
    @required this.callback,
    @required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: buttonColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
