import 'dart:async';

import 'package:firebase_functions_interop/firebase_functions_interop.dart';

void main() {
  // Users.handle();
  functions['logAuth'] = functions.auth.user().onCreate(logAuth);
  functions['makeLowercase'] =
      functions.firestore.document("/users/{userId}").onWrite(makeLowercase);
}

/// Example Auth
void logAuth(UserRecord data, EventContext context) {
  print(data.email);
}

// Example Firestore
FutureOr<void> makeLowercase(
    Change<DocumentSnapshot> change, EventContext content) {
  var newFavBgGenres = <String>[];

  final snapshot = change.after;

  // if (snapshot.data.getString("name") == null) {
  var originalName = snapshot.data.getString("name");
  var originalCurrentLocation = snapshot.data.getString("currentLocation");
  var originalGender = snapshot.data.getString("gender");
  var origFavBgGenres = snapshot.data.getList("favBoardGameGenres");
  print("Lowercasing $originalName");
  print("Lowercasing $originalCurrentLocation");
  print("Lowercasing $originalGender");

  UpdateData newData = new UpdateData();

  if (origFavBgGenres.isNotEmpty) {
    origFavBgGenres.forEach((element) {
      newFavBgGenres.add(element.toString().toLowerCase());
    });
    newData.setList("favBoardGameGenres", newFavBgGenres);
  }

  newData.setString("name", originalName.toLowerCase());
  newData.setString("currentLocation", originalCurrentLocation.toLowerCase());
  newData.setString("gender", originalGender.toLowerCase());

  return snapshot.reference.updateData(newData);
}
