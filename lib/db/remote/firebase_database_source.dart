import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_01/db/entity/UserQuery.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/entity/message.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/utils/utils.dart';

class FirebaseDatabaseSource {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  void addUser(AppUser user) {
    instance.collection('users').doc(user.id).set(user.toMap());
  }

  Future<Response> updateUser(AppUser user) async {
    try {
      instance.collection('users').doc(user.id).update(user.toMap());
      return Response.success("success");
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }

  Future<Response<String>> updateUserVersionTwo(AppUser user) async {
    try {
      await instance.collection('users').doc(user.id).update(user.toMap());
      return Response.success("success");
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return instance.collection("users").doc(userId).get();
  }

  void addSwipedUser(String userId, Swipe swipe) {
    instance
        .collection('users')
        .doc(userId)
        .collection('swipes')
        .doc(swipe.id)
        .set(swipe.toMap());
  }

  Future<DocumentSnapshot> getSwipe(String userId, String swipeId) {
    return instance
        .collection('users')
        .doc(userId)
        .collection('swipes')
        .doc(swipeId)
        .get();
  }

  void addMatch(String userId, Match match) {
    instance
        .collection('users')
        .doc(userId)
        .collection('matches')
        .doc(match.id)
        .set(match.toMap());
  }

  Future<QuerySnapshot> getSwipes(String userId) {
    return instance.collection('users').doc(userId).collection('swipes').get();
  }
/**

export async function workTripOrderByQuery(companyId, querys) {
  try {
    // Add a new document in collection "users"
    let queryRef = await db
      .collection('companys')
      .doc(companyId)
      .collection('workTrips')
      .withConverter(workTripConverter)

    querys.forEach((query) => {
      queryRef = queryRef.where(query.field, query.condition, query.value)
    })
    let query = await queryRef.orderBy('scheduledDrive.start').limit(3).get()
    const workTripList = []
    query.forEach((doc) => {
      workTripList.push(workTripConverter.fromData(doc.data()))
    })

    return workTripList
  } catch (error) {
    console.error('Error getting document: ', error)
    return
  }
}
 */

  Future<QuerySnapshot> getPersonsToMatchWith(int limit, List<String> ignoreIds,
      [List<UserQuery>? queries]) {
// Step 1.
// TODO Set collection as a variable

    Query<Map<String, dynamic>> queryRef = instance.collection("users");

    queryRef.where('id', whereNotIn: ignoreIds).limit(limit);

    // queries?.forEach((query) {
    //   queryRef = queryRef.where(query.field, ["isEqualTo"]: query.value);
    // });

    queryRef = filterSwipableUsers(queryRef, queries!);

    return queryRef.get();
    // return queryRef.where('id', whereNotIn: ignoreIds).limit(limit).get();
    // return instance
    //     .collection('users')
    //     // .where("gender", isEqualTo: "female")
    //     .where('id', whereNotIn: ignoreIds)
    //     .limit(limit)
    //     .get();
  }

  void addChat(Chat chat) {
    instance.collection('chats').doc(chat.id).set(chat.toMap());
  }

  Future<QuerySnapshot> getMatches(String userId) {
    return instance.collection('users').doc(userId).collection('matches').get();
  }

  void addMessage(String chatId, Message message) {
    instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  void updateChat(Chat chat) {
    instance.collection('chats').doc(chat.id).update(chat.toMap());
  }

  void updateMessage(String chatId, String messageId, Message message) {
    instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update(message.toMap());
  }

  Future<DocumentSnapshot> getChat(String chatId) {
    return instance.collection('chats').doc(chatId).get();
  }

  Stream<DocumentSnapshot> observeUser(String userId) {
    return instance.collection('users').doc(userId).snapshots();
  }

  Stream<QuerySnapshot> observeMessages(String chatId) {
    return instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('epoch_time_ms', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> observeChat(String chatId) {
    return instance.collection('chats').doc(chatId).snapshots();
  }
}
