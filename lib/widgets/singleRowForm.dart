import 'package:flutter/material.dart';

import '../constants.dart';

/// Used in
/// 1. Create Fueling Screen
/// 2. Report Issue Screen

// Title and Textfield in a Row Widget of CreateFuelingScreen
class SingleRowForm extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController textEditingController;

  const SingleRowForm({
    @required this.title,
    @required this.hint,
    @required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          // Title of the textfield
          Expanded(child: Text(title)),

          // Textfield
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              decoration: inputDecoration.copyWith(
                hintText: hint,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty || value == null) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
