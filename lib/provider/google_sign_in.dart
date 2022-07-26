import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/db/remote/firebase_storage_source.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/model/bg_theme.dart';
import 'package:flutter_demo_01/model/chat_with_user.dart';
import 'package:flutter_demo_01/model/user_bio_edit.dart';
import 'package:flutter_demo_01/model/user_profile_edit.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/screens/setup_screens/first_name_bgg_page.dart';
import 'package:flutter_demo_01/utils/fire_auth.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<Response> googleRegister() async {
    try {
      GoogleSignInAccount? googleSignInUser = await googleSignIn.signIn();

      if (googleSignInUser == null) {
        return Response.error("No user was selected");
      } else {
        final GoogleSignInAuthentication? googleSignInAuth =
            await googleSignInUser.authentication;

        if (googleSignInAuth != null) {
          final AuthCredential authCredentials = GoogleAuthProvider.credential(
              idToken: googleSignInAuth.idToken,
              accessToken: googleSignInAuth.accessToken);

          return Response.success(authCredentials);
        }
      }
    } catch (e) {
      print(e.toString());
      return Response.error("Error");
    }
    return Response.error("Error");
  }

  Future logout() async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        await SharedPreferencesUtil.removeUserId();

        await googleSignIn.disconnect();
        FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
