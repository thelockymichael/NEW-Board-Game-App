import 'package:flutter/material.dart';

class RoundedOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RoundedOutlinedButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
            // child: OutlineButton(
            onPressed: onPressed,
            child: Text(text, style: Theme.of(context).textTheme.button))
        // ignore: deprecated_member_use
        // child: OutlineButton(
        //   highlightedBorderColor: kAccentColor,
        //   borderSide: const BorderSide(color: kSecondaryColor, width: 2.0),
        //   child: Text(text, style: Theme.of(context).textTheme.button),
        //   onPressed: onPressed,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(25),
        //   ),
        // )
        );
  }
}
