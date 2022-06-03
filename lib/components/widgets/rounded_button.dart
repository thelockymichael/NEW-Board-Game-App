// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/utils/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RoundedButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        disabledColor: kAccentColor.withOpacity(0.25),
        padding: const EdgeInsets.symmetric(vertical: 14),
        highlightElevation: 0,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Text(text, style: Theme.of(context).textTheme.button),
        onPressed: onPressed,
      ),
    );
  }
}
