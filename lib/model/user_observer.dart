import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';

class UserObserver {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  List<AppUser> usersList = [];
  List<StreamSubscription<DocumentSnapshot>> subscriptionList = [];

  UserObserver(this.usersList);

  void startObservers(Function onUserUpdated) {
    for (var element in usersList) {
      StreamSubscription<DocumentSnapshot> userSubscription =
          _databaseSource.observeUser(element.id).listen((event) {
        AppUser updatedUser = AppUser.fromSnapshot(event);

        print("LOG updatedUser ${updatedUser.id}");

        onUserUpdated();
      });

      subscriptionList.add(userSubscription);
    }
  }

  void removeObservers() async {
    for (var i = 0; i < subscriptionList.length; i++) {
      await subscriptionList[i].cancel();
      subscriptionList.removeAt(i);
    }

    // subscriptionList = null;
    // usersList = null;
  }
}
