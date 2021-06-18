import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';

import './loginScreen.dart';
import '../services/statsServices.dart';
import '../models/envirocarStats.dart';
import '../constants.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: GlobalKey<IntroductionScreenState>(),
      pages: [
        PageViewModel(
          decoration: PageDecoration(
            descriptionPadding: EdgeInsets.all(10),
            titlePadding: EdgeInsets.all(10),
          ),
          titleWidget: Image.asset(
            'assets/images/img_envirocar_logo.png',
          ),
          bodyWidget: Image.asset(
            'assets/images/enviroCar-en.png',
          ),
        ),
        PageViewModel(
          titleWidget: Column(
            children: [
              Text(
                'enviroCar',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              Text(
                'Stats',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            ],
          ),
          bodyWidget: FutureBuilder(
            future: StatsServices().getEnvirocarStats(),
            builder:
                (BuildContext context, AsyncSnapshot<EnvirocarStats> snapshot) {
              if (snapshot.hasData) {
                EnvirocarStats envirocarStats = snapshot.data;
                return Column(
                  children: [
                    Text(
                      envirocarStats.users.toString(),
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Users',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      envirocarStats.tracks.toString(),
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Tracks',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      envirocarStats.measurements.toString(),
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Measurements',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      },
      showSkipButton: true,
      skip: const Text('Skip'),
      skipFlex: 0,
      onSkip: () {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      },
      next: const Text('Next'),
      nextFlex: 0,
      dotsDecorator: const DotsDecorator(
        size: Size(5.0, 5.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(10.0, 5.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
