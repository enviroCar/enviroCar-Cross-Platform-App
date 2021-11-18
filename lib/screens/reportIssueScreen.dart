import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../constants.dart';
import '../models/report.dart';
import '../widgets/button.dart';
import '../widgets/titleWidget.dart';
import '../widgets/singleRowForm.dart';
import '../values/reportIssueValues.dart';

class ReportIssueScreen extends StatefulWidget {
  static const String routeName = '/ReportIssueScreen';

  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  // Key to validate the form
  GlobalKey<FormState> _formKey;

  // Controller to extract the data from textfields
  TextEditingController estimatedTimeController;
  TextEditingController problemController;

  // bool variables for checkboxes
  bool forceCrashBool;
  bool suddenLagsBool;
  bool unresponsiveAppBool;
  bool componentNotWorkingBool;
  bool featureRequestBool;

  // triggered when 'Create Report' button is pressed
  void createReport() {
    _logger.i('createReport called');
    final Report report = Report(
      // TODO: Add id from uuid package
      id: '32',
      estimatedTime: estimatedTimeController.text,
      problem: problemController.text,
      forceCrash: forceCrashBool,
      suddenLags: suddenLagsBool,
      appWasUnresponsive: unresponsiveAppBool,
      componentDoesNotWorkAsExpected: componentNotWorkingBool,
      requestForAFeature: featureRequestBool,
    );

    _logger.i(report);
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();

    estimatedTimeController = TextEditingController();
    problemController = TextEditingController();

    forceCrashBool = false;
    suddenLagsBool = false;
    unresponsiveAppBool = false;
    componentNotWorkingBool = false;
    featureRequestBool = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyColor,
        elevation: 0,
        // enviroCar logo
        title: const Text('Report Issue'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: deviceWidth,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Heading text
                const Text(heading),
                const SizedBox(
                  height: 10,
                ),

                // Estimated time textfield
                SingleRowForm(
                  title: estimatedTime,
                  hint: '10.00',
                  textEditingController: estimatedTimeController,
                ),
                const SizedBox(
                  height: 10,
                ),

                // Textfield for problem description
                TextFormField(
                  controller: problemController,
                  maxLines: 5,
                  decoration: inputDecoration.copyWith(
                    labelText: describeYourProblem,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Categories heading
                const TitleWidget(
                  title: categories,
                ),

                // Force Crash Checkbox
                CheckboxListTile(
                  title: const Text(forceCrash),
                  value: forceCrashBool,
                  onChanged: (bool val) {
                    setState(() {
                      forceCrashBool = val;
                    });
                  },
                ),

                // Sudden Lags Checkbox
                CheckboxListTile(
                  title: const Text(suddenLags),
                  value: suddenLagsBool,
                  onChanged: (bool val) {
                    setState(() {
                      suddenLagsBool = val;
                    });
                  },
                ),

                // App was unresponsive Checkbox
                CheckboxListTile(
                  title: const Text(appWasUnresponsive),
                  value: unresponsiveAppBool,
                  onChanged: (bool val) {
                    setState(() {
                      unresponsiveAppBool = val;
                    });
                  },
                ),

                // Component Does not work Checkbox
                CheckboxListTile(
                  title: const Text(componentDoesNotWorkAsExpected),
                  value: componentNotWorkingBool,
                  onChanged: (bool val) {
                    setState(() {
                      componentNotWorkingBool = val;
                    });
                  },
                ),

                // Feature request Checkbox
                CheckboxListTile(
                  title: const Text(requestForAFeature),
                  value: featureRequestBool,
                  onChanged: (bool val) {
                    setState(() {
                      featureRequestBool = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                // Create Report button
                Button(
                  title: sendReport,
                  color: kSpringColor,
                  onTap: () {
                    createReport();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
