import 'Package:flutter/material.dart';

import '../widgets/createCarWidgets/attributesOption.dart';
import '../widgets/createCarWidgets/tsnHsnOption.dart';

import '../widgets/tabButtonsPage.dart';
import '../utils/enums.dart';

class CreateCarScreen extends StatefulWidget {
  static const String routeName = '/createCarScreen';
  @override
  _CreateCarScreenState createState() => _CreateCarScreenState();
}

class _CreateCarScreenState extends State<CreateCarScreen> {
  CreateCarTab selectedTab = CreateCarTab.hsnTsn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 33, 43),
        elevation: 0,

        // enviroCar logo
        title: Image.asset(
          'assets/images/img_envirocar_logo_white.png',
          scale: 10,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabButtonsPage(
              button1Title: 'HSN/TSN',
              button2Title: 'Attributes',
              tab1: CreateCarTab.hsnTsn,
              tab2: CreateCarTab.attributes,
              page1: TsnHsnOption(),
              page2: AttributesOption(),
            ),
          ],
        ),
      ),
    );
  }
}
