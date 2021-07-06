import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';

import './loginScreen.dart';
import '../services/statsServices.dart';
import '../models/envirocarStats.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: GlobalKey<IntroductionScreenState>(),
      pages: [
        PageViewModel(
          decoration: const PageDecoration(
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
            children: const [
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
                final EnvirocarStats envirocarStats = snapshot.data;
                return Column(
                  children: [
                    Text(
                      envirocarStats.users.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const Text(
                      'Users',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      envirocarStats.tracks.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const Text(
                      'Tracks',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      envirocarStats.measurements.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const Text(
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
