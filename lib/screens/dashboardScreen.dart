import 'Package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    double height = _mediaQuery.size.height;
    double width = _mediaQuery.size.width;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.20,
              width: double.infinity,
              color: Color.fromARGB(255, 23, 33, 43),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TODO: Replace dummy data with actual data
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '23',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            'Total Tracks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 80, 100),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '100 km',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            'Total Distance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 80, 100),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '0.01 hr',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            'Total Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 80, 100),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
