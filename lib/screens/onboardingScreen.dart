import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';

import './loginScreen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: GlobalKey<IntroductionScreenState>(),
      pages: [
        PageViewModel(
          title: "First Introduction Screen",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
        ),
        PageViewModel(
          title: "Second Introduction Screen",
          body:
              "Download the Stockpile app and master the market with our mini-lesson.",
        ),
        PageViewModel(
          title: "Third Introduction Screen",
          bodyWidget: Column(
            children: [
              Text('Let\s get going'),
              Image.asset('assets/images/img_envirocar_logo.png'),
            ],
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
