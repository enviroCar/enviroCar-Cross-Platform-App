import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import './loginScreen.dart';
import '../constants.dart';
import '../globals.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  final int _numPages = 3;
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    final List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? kSpringColor : Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                physics: const ClampingScrollPhysics(),
                controller: pageController,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Record',
                        style: TextStyle(
                          color: kSpringColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/onboarding/track.gif',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          'Record you Tracks while driving by connecting with OBD. OBD connection help can be found in the dashboard.'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Upload',
                        style: TextStyle(
                          color: kSpringColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/onboarding/cloud.gif',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          'Upload your data as open data and help Research Studies and effective Traffic Planning.'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Analyze',
                        style: TextStyle(
                          color: kSpringColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/onboarding/analyze.png',
                        scale: 2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          'Analyze your tracks and find the driving efficiency, car running cost and much more.'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 50,
              width: double.infinity,
              color: kSpringColor,
              child: GestureDetector(
                onTap: () {
                  preferences.setBool('displayIntroduction', false);
                  _logger.i('Going to login screen');
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: const Center(
                  child: Text(
                    'Get started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : const Text(''),
    );
  }
}
