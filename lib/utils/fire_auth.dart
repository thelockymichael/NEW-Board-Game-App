// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo_01/db/remote/response.dart';

class FireAuth {
  // Firestore
  // For registering a new user
  FirebaseAuth instance = FirebaseAuth.instance;

  Future<Response<UserCredential>> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await instance.signInWithEmailAndPassword(
          email: email, password: password);
      return Response.success(userCredential);
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }

  Future<Response<UserCredential>> register(
      String email, String password) async {
    try {
      UserCredential userCredential = await instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return Response.success(userCredential);
    } catch (e) {
      return Response.error((e as FirebaseException).message ?? e.toString());
    }
  }
}
