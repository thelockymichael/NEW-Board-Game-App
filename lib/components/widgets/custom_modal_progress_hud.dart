// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/utils/constants.dart';

class CustomModalProgressHUD extends StatefulWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  Offset? offset;
  final bool dismissible;
  final Widget child;

  CustomModalProgressHUD({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.transparent,
    this.progressIndicator = const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kAccentColor)),
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  State<CustomModalProgressHUD> createState() => _CustomModalProgressHUDState();
}

class _CustomModalProgressHUDState extends State<CustomModalProgressHUD> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(widget.child);
    if (widget.inAsyncCall) {
      Widget layOutProgressIndicator;
      if (widget.offset == null) {
        layOutProgressIndicator = Center(child: widget.progressIndicator);
      } else {
        layOutProgressIndicator = Positioned(
          child: widget.progressIndicator,
          left: widget.offset?.dx,
          top: widget.offset?.dy,
        );
      }
      final modal = [
        Opacity(
          child: ModalBarrier(
              dismissible: widget.dismissible, color: widget.color),
          opacity: widget.opacity,
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return Stack(
      children: widgetList,
    );
  }
}
