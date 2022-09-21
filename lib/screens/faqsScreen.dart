import 'package:flutter/material.dart';

import '../constants.dart';

class FAQsScreen extends StatelessWidget {
  static final String routeName = '/faqs';

  final List<String> questions = [
    'What geographic information is often recorded alongside the track?',
    'Is the local track data (location-specific) processed?',
    'How is the processing of the uploaded tracks\' data done?',
    'What does informed consent mean?',
    'How is sharing Personal Location Information (PLI) critical?',
    'What privacy threats can geolocation technologies pose?',
  ];

  final List<String> answers = [
    'The track recording includes the user\'s personal location data, or the geographic coordinates (latitude and longitude), to which the values of the parsed parameter are mapped.',
    'No, the location-specific data from the local track is not handled. The tracks are simply saved on your device and are only visible to you. As long as the track is not posted to the server as open data, the data is only available to you.',
    'The data from uploaded tracks is analysed, and the factors related to the physical coordinates are utilised to determine CO2 hotspots and traffic flow. The control of traffic flow can also be done using the interpretation of the results from this data.',
    'Informed consent for location data refers to telling the user about what location data is being used or processed by the offered service and always asking for permission to use the location data without compromising the user\'s privacy.',
    'Sharing personal location information (PLI) is crucial since a user\'s position coordinates might disclose a lot about them. This data, after analyzing and making inferences, can be utilized to learn about the user\'s routinely visited destinations, thereby jeopardizing their privacy.',
    'Geolocation technologies compromise users\' privacy by sharing and monetizing their personal location information (PLI). This PLI data is crucial, and conclusions formed from it can result in privacy violations.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        title: Text(
          'FAQs',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index == questions.length) {
            return SizedBox(
              height: 30,
            );
          }
          return CustomExpansionTile(
            question: questions[index],
            answer: answers[index],
          );
        },
        itemCount: questions.length + 1,
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String question;
  final String answer;

  CustomExpansionTile({
    @required this.question,
    @required this.answer,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded;

  @override
  void initState() {
    isExpanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          margin: EdgeInsets.only(
            left: 16,
          ),
          decoration: BoxDecoration(
            color: kOffWhiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.question_answer_rounded,
            color: isExpanded ? kErrorColor: kGreyColor,
            size: 16,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
            decoration: BoxDecoration(
              color: kOffWhiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              collapsedIconColor: kGreyColor,
              iconColor: kErrorColor,
              collapsedTextColor: kGreyColor,
              textColor: kErrorColor,
              onExpansionChanged: (bool value) {
                setState(() {
                  isExpanded = value;
                });
              },
              title: Text(
                widget.question,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    widget.answer,
                    style: TextStyle(
                      fontSize: 13,
                      color: kGreyColor.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
