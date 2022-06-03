import 'dart:async';

import 'package:firebase_functions_interop/firebase_functions_interop.dart';

import "users.dart";

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
  final snapshot = change.after;

  if (snapshot.data.getString("uppercasedName") == null) {
    var original = snapshot.data.getString("name");
    print("Uppercasing $original");

    UpdateData newData = new UpdateData();
    newData.setString("uppercasedName", original.toUpperCase());

    return snapshot.reference.updateData(newData);
  }

  return null;
} 


// /// Example Realtime Database function.
// FutureOr<void> makeLowercase(
//     Change<DocumentSnap<String>> snap, EventContext context) {
//   try {
//     // final firestore = snap.firestore;


//     snap.
//   } catch (e) {
//     print("Error logged: ${e}");
//   }
//   // final DataSnapshot<String> snapshot = change.after;
//   // var original = snapshot.val();
//   // var pushId = context.params['testId'];
//   // print('Uppercasing $original');
//   // var uppercase = pushId.toString() + ': ' + original.toUpperCase();
//   // return snapshot.ref.parent.child('uppercase').setValue(uppercase);
// }
