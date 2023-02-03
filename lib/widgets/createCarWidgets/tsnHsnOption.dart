import 'package:flutter/material.dart';

import '../../constants.dart';

class TsnHsnOption extends StatefulWidget {
  @override
  _TsnHsnOptionState createState() => _TsnHsnOptionState();
}

class _TsnHsnOptionState extends State<TsnHsnOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            const Text(
              'Please enter the details of you vehicle by HSN and TSN',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: inputDecoration.copyWith(
                labelText: 'HSN',
              ),
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // Construction year
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: inputDecoration.copyWith(
                labelText: 'TSN',
              ),
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
