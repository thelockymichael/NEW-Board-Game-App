import 'package:flutter/material.dart';
import 'package:flutter_demo_01/utils/constants.dart';

class RoundedOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  RoundedOutlinedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: OutlineButton(
          highlightedBorderColor: kAccentColor,
          borderSide: BorderSide(color: kSecondaryColor, width: 2.0),
          child: Text(text, style: Theme.of(context).textTheme.button),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ));
  }
}
