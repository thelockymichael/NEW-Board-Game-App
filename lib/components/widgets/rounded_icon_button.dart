import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  // ignore: prefer_typing_uninitialized_variables
  final paddingReduce;
  final Color buttonColor;

  const RoundedIconButton(
      {Key? key,
      required this.onPressed,
      required this.iconData,
      this.iconSize = 30,
      required this.buttonColor,
      this.iconColor = Colors.black,
      this.paddingReduce = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 0,
      elevation: 5,
      color: buttonColor,
      onPressed: onPressed,
      padding: EdgeInsets.all((iconSize / 2) - paddingReduce),
      child: Icon(iconData, size: iconSize, color: iconColor),
      shape: const CircleBorder(),
    );
  }
}
