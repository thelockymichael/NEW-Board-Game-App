// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/entity/UserQuery.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:intl/intl.dart';

class Utils {
  static int ascendingSort(FavBgMechanicItem c1, FavBgMechanicItem c2) =>
      c1.name.compareTo(c2.name);
}

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
    List<String> strArr = split(' ');

    if (isEmpty) {
      return this;
    }

    if (strArr.length == 1) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
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

// TODO Calculate age by using date of birth

int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();

  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;

  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;

    if (day2 > day1) {
      age--;
    }
  }

  return age;
}

// TODO 1. RETURN QUERYREF
// TODO 2. Loop every query

Query<Map<String, dynamic>> filterSwipableUsers(
    Query<Map<String, dynamic>> queryRef, List<UserQuery> queries) {
  queries.forEach((query) {
    // 11 options
    switch (query.condition) {
      case "arrayContains":
        break;
      case "arrayContainsAny":
        break;

      case "isEqualTo":
        if (query.field.contains("gender")) {
          if (!query.value.contains("everyone")) {
            print("VMK dsada ${query.value}");
            if (query.value.contains("women")) {
              print("VMK women");
              queryRef = queryRef.where(query.field, isEqualTo: "female");
            } else if (query.value.contains("men")) {
              print("VMK men");
              queryRef = queryRef.where(query.field, isEqualTo: "male");
            } else if (query.value.contains("other")) {
              print("VMK other");
              queryRef = queryRef.where(query.field, isEqualTo: "other");
            }
            //   print("VMK everyone");
            //   queryRef = queryRef.where(query.field, isEqualTo: query.value)
            //   .where(query.field, );
            // } else {
            // print("VMK else");
            // queryRef = queryRef.where(query.field, isEqualTo: query.value);
          }
        }

        break;

      case "isGreaterThan":
        break;

      case "isGreaterThanOrEqualTo":
        queryRef =
            queryRef.where(query.field, isGreaterThanOrEqualTo: query.value);

        break;

      case "isLessThan":
        break;

      case "isLessThanOrEqualTo":
        queryRef =
            queryRef.where(query.field, isLessThanOrEqualTo: query.value);

        break;

      case "isNotEqualTo":
        break;

      case "isNull":
        break;

      case "whereIn":
        break;

      case "whereNotIn":
        break;

      default:
        break;
    }
  });

  return queryRef;
}
