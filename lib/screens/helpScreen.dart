import 'package:flutter/material.dart';

import '../globals.dart';
import '../constants.dart';
import '../widgets/dividerLine.dart';
import '../values/helpScreenValues.dart';

class HelpScreen extends StatelessWidget {
  static const String routeName = '/helpScreen';

  // For heading 1
  Widget buildH1({@required String headline1}) {
    return Text(
      headline1,
      style: const TextStyle(
        fontSize: 22,
      ),
    );
  }

  // For heading 2
  Widget buildH2({@required String headline2}) {
    return Text(
      headline2,
      style: const TextStyle(
        fontSize: 17,
      ),
    );
  }

  // For paragraphs
  Widget buildParagraph({@required String paragraph}) {
    return Text(
      paragraph,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: deviceWidth,
              color: kGreyColor,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/img_envirocar_logo_white.png',
                    scale: 4.5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Help',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Headline 1
                  buildH1(headline1: help_headline_1),
                  buildParagraph(paragraph: help_content_1),

                  DividerLine(),

                  // Headline 2
                  buildH1(headline1: help_headline_2),
                  const SizedBox(
                    height: 5,
                  ),
                  buildH2(headline2: help_headline_2_1),
                  buildParagraph(paragraph: help_content_2_1),
                  buildParagraph(paragraph: help_content_2_1_enum_1),
                  buildParagraph(paragraph: help_content_2_1_enum_2),
                  buildParagraph(paragraph: help_content_2_1_enum_3),

                  buildH2(headline2: help_headline_2_2),
                  buildParagraph(paragraph: help_content_2_2),

                  buildH2(headline2: help_headline_2_3),
                  buildParagraph(paragraph: help_content_2_3),

                  DividerLine(),

                  // Headline 3
                  buildH1(headline1: help_headline_3),
                  buildParagraph(paragraph: help_content_3_1),
                  buildParagraph(paragraph: help_content_3_bullet_1),
                  buildParagraph(paragraph: help_content_3_bullet_2),
                  buildParagraph(paragraph: help_content_3_bullet_3),
                  buildParagraph(paragraph: help_content_3_bullet_4),
                  buildParagraph(paragraph: help_content_3_2),

                  DividerLine(),

                  // Headline 4
                  buildH1(headline1: help_headline_4),

                  buildParagraph(paragraph: help_content_4_0),

                  buildH2(headline2: help_headline_4_1),
                  buildParagraph(paragraph: help_content_4_1),

                  buildH2(headline2: help_headline_4_2),
                  buildParagraph(paragraph: help_content_4_2),

                  DividerLine(),

                  // Headline 5
                  buildH1(headline1: help_headline_5),
                  buildParagraph(paragraph: help_content_5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
