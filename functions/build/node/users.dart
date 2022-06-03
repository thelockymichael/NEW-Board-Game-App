// import 'dart:async';

// import 'package:firebase_functions_interop/firebase_functions_interop.dart'
//     hide Message;
// import 'package:foundation/model/message.dart';
// import 'package:foundation/model/user.dart';

// import 'filter.dart';

// class Users {
//   static void handle() {
//     functions["createUser"] = functions.auth.user().onCreate(createUser);
//   }

//   void createUser(User data, EventContext context) {
//     print("logAuth ${data.name}");
//   }
// }




// class Users {
//   static void handle() {
//     functions["createUser"] =
//         functions.firestore.document("users").onCreate(createUser);
//   }

//   static FutureOr<void> createUser(DocumentSnapshot snap, EventContext) async {
//     try {
//       final firestore = snap.firestore;
//       final user = User.fromJson(snap.data.toMap());

//       final userNameText = user.name;

//       final cleanedMessage = await getCleanedMessage(userNameText);

//       if (userNameText == cleanedMessage) {
//         /// Message doesn't contain bad words
//       } else {
//         /// Message contains bad words
//         /// Update chat message
//         final newMessage = "I GOT BANNED for saying ${cleanedMessage}";

//         final update = UpdateData.fromMap({UserField.name: newMessage});

//         await snap.reference.updateData(update);

//         // Ban user
//         final refBanned = firestore.collection('banned').document(user.idUser);

//         await refBanned.setData(DocumentData.fromMap({}));
//       }
//     } catch (e) {
//       print("Error logged: ${e}");
//     }
//   }
// }
