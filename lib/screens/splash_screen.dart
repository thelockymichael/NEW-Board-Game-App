import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/screens/register_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/first_name_bgg_page.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  @override
  void initState() {
    super.initState();
    checkIfUserExists();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> checkIfUserExists() async {
    Timer(Duration(seconds: 2), () async {
      String? userId = await SharedPreferencesUtil.getUserId();

      print("LOG signup checkIfUserExists splasScreen $userId");

      if (userId != null) {
        var _snapshotUser = await _databaseSource.getUser(userId);

        AppUser _user = AppUser.fromSnapshot(_snapshotUser);

        if (_user.setupIsCompleted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainNavigation()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => FirstNameBggPage()),
              (route) => false);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => RegisterPage()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              'assets/images/splash-screen.jpg',
            ),
            fit: BoxFit.cover,
          )),
        ),
      ),
      Positioned(
          child: Padding(
              padding: kDefaultPadding,
              child: Center(
                  child: Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.black),
                child: Text(
                  "Board Match",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50),
                ),
              ))))
    ])

            //  Padding(
            //     padding: kDefaultPadding,
            //     child: Center(
            //       child: Text(
            //         "Board Match",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            //       ),
            //     ))
            ));
  }
}
