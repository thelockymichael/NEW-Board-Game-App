import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar(GlobalKey<ScaffoldState> globalKey, String message) {
  final snackBar = SnackBar(content: Text(message));
  globalKey.currentState?.hideCurrentSnackBar();
  globalKey.currentState?.showSnackBar(snackBar);
}

String compareAndCombineIds(String userID1, String userID2) {
  if (userID1.compareTo(userID2) < 0) {
    return userID2 + userID1;
  } else {
    return userID1 + userID2;
  }
}

String convertEpochMsToDateTime(int epochMs) {
  int oneDayInMs = 86400000;
  var date = DateTime.fromMillisecondsSinceEpoch(epochMs);
  int currentTimeMs = DateTime.now().millisecondsSinceEpoch;
  if ((currentTimeMs - epochMs) >= oneDayInMs) {
    return '${DateFormat.yMd().format(date)}  ${DateFormat.jm().format(date)}';
  } else {
    return DateFormat.jm().format(date);
  }
}

extension StringExtension on String {
  String capitalize() {
    List<String> strArr = this.split(' ');

    if (strArr.length == 1) {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    } else {
      List<String> moreThanOneStr = [];

      for (var element in strArr) {
        moreThanOneStr.add(
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}");
      }

      final joinedName = moreThanOneStr.join(" ");

      return joinedName;
    }
  }
}
