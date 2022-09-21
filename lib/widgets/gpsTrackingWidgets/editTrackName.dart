import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../button.dart';
import '../../globals.dart';
import '../../constants.dart';
import 'trackDetailsTile.dart';
import '../../providers/carsProvider.dart';
import '../../models/localTrackModel.dart';
import '../../providers/gpsTrackProvider.dart';
import '../../providers/localTracksProvider.dart';

class EditTrackName extends StatefulWidget {
  final GpsTrackProvider gpsTrackProvider;

  const EditTrackName({this.gpsTrackProvider});

  @override
  _EditTrackNameState createState() => _EditTrackNameState();
}

class _EditTrackNameState extends State<EditTrackName> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  final OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    borderSide: BorderSide(
      width: 3,
      color: kSecondaryColor,
    ),
  );

  bool useDefaultTrackName = true;
  String customTrackName;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  @override
  void initState() {
    _textEditingController.text = widget.gpsTrackProvider.getTrackName;
    setState(() {
      customTrackName = _textEditingController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomContainer(
        height: deviceHeight,
        progressColor: kGreyColor.withOpacity(0.9),
        progress: 0.7,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: deviceHeight * 0.16,
            horizontal: deviceWidth * 0.1,
          ),
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border.all(
              color: kGreyColor.withOpacity(0.5),
              width: 5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Form(
                key: _key,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Track Name',
                          hintStyle: TextStyle(
                            color: kPrimaryColor.withOpacity(0.6),
                            fontSize: 15,
                          ),
                          labelStyle: TextStyle(
                            color: kPrimaryColor.withOpacity(0.6),
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: kSecondaryColor.withOpacity(0.5),
                          enabledBorder: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          focusedErrorBorder: outlineInputBorder,
                          errorBorder: outlineInputBorder,
                          border: outlineInputBorder,
                        ),
                        cursorHeight: 24,
                        cursorColor: kGreyColor.withOpacity(0.3),
                        textAlignVertical: TextAlignVertical.center,
                        validator: (String text) {
                          if (text.trim().isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                        onFieldSubmitted: (String text) {
                          setState(() {
                            customTrackName = text;
                          });
                        },
                        onChanged: (String text) {
                          setState(() {
                            customTrackName = text;
                          });
                        },
                        onSaved: (String text) {
                          setState(() {
                            customTrackName = text;
                          });
                        },
                        style: TextStyle(
                          color: kPrimaryColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: useDefaultTrackName,
                            onChanged: (bool checked) {
                              setState(() {
                                useDefaultTrackName = checked;
                                if (useDefaultTrackName) {
                                  setState(() {
                                    _textEditingController.text =
                                        widget.gpsTrackProvider.getTrackName;
                                    customTrackName =
                                        _textEditingController.text;
                                  });
                                } else {
                                  setState(() {
                                    customTrackName =
                                        _textEditingController.text;
                                    _textEditingController.text = '';
                                  });
                                }
                              });
                            },
                            activeColor: kSecondaryColor,
                            checkColor: kWhiteColor,
                          ),
                          Text(
                            'Use default track name',
                            style: TextStyle(
                              color: kPrimaryColor.withOpacity(0.6),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: kSecondaryColor,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.5),
                        border: Border.all(
                          color: kSecondaryColor,
                          width: 5,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TrackDetailsTile(
                            title: 'start',
                            subTitle: widget.gpsTrackProvider.getTrackStartTime,
                          ),
                          TrackDetailsTile(
                            title: 'end',
                            subTitle: widget.gpsTrackProvider.getTrackEndTime,
                          ),
                          const TrackDetailsTile(
                            title: 'speed',
                            subTitle:
                                '49.3 km/hr', // todo: change hardcoded value
                          ),
                          TrackDetailsTile(
                            title: 'distance',
                            subTitle:
                                '${widget.gpsTrackProvider.getDistance.toStringAsFixed(2)} km',
                          ),
                          TrackDetailsTile(
                            title: 'Duration',
                            subTitle: widget.gpsTrackProvider.getTrackDuration,
                          ),
                          TrackDetailsTile(
                            title: 'no of stops',
                            subTitle:
                                widget.gpsTrackProvider.getNoOfStops.toString(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Button(
                        title: 'save'.toUpperCase(),
                        color: kSpringColor,
                        onTap: () {
                          if (_key.currentState.validate()) {
                            _logger.i(
                              'Call function to save recording data and set track name.',
                            );
                            widget.gpsTrackProvider
                                .setTrackName(customTrackName);
                            final CarsProvider carsProvider =
                                Provider.of<CarsProvider>(
                              context,
                              listen: false,
                            );
                            final LocalTrackModel track =
                                widget.gpsTrackProvider.getLocalTrack(
                              sensor: carsProvider.getSelectedCar,
                            );
                            final LocalTracksProvider localTracksProvider =
                                Provider.of<LocalTracksProvider>(
                              context,
                              listen: false,
                            );
                            localTracksProvider.addLocalTrack(track);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Color progressColor;
  final double height;
  final double progress;
  final Widget child;

  const CustomContainer({
    @required this.progressColor,
    @required this.height,
    @required this.progress,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height * (1 - progress),
        ),
        Container(
          margin: EdgeInsets.only(top: height * (1 - progress)),
          color: progressColor,
          height: height * progress,
        ),
        Center(
          child: child,
        )
      ],
    );
  }
}
