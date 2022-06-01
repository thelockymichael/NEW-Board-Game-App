import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/entity/message.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';

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

  Future<QuerySnapshot> getPersonsToMatchWith(
      int limit, List<String> ignoreIds) {
    return instance
        .collection('users')
        .where('id', whereNotIn: ignoreIds)
        .limit(limit)
        .get();
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
