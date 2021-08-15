import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../globals.dart';
import '../../exceptionHandling/result.dart';
import '../../screens/chartsScreen.dart';
import '../../services/tracksServices.dart';

class StackedMapButton extends StatefulWidget {
  final String trackID;

  const StackedMapButton({@required this.trackID});

  @override
  _StackedMapButtonState createState() => _StackedMapButtonState();
}

class _StackedMapButtonState extends State<StackedMapButton> {
  final double buttonDiameter = 55;
  Map<String, dynamic> track;

  Future<void> getTrackDetails() async {
    final Result result =
        await TracksServices().getTrackFromID(trackID: widget.trackID);
    track = result.value as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (deviceHeight * 0.3) + buttonDiameter / 2,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/map_placeholder.png',
            fit: BoxFit.cover,
            height: deviceHeight * 0.3,
            width: double.infinity,
          ),
          Positioned(
            top: (deviceHeight * 0.3) - buttonDiameter / 2,
            right: (30) / 2,
            child: Container(
              decoration: const BoxDecoration(
                color: kSpringColor,
                shape: BoxShape.circle,
              ),
              height: buttonDiameter,
              width: buttonDiameter,
              child: FutureBuilder(
                future: getTrackDetails(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return ChartScreen(
                                track: track,
                              );
                            },
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.map,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
