import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/screens/login_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/first_name_bgg_page.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIfUserExists();
  }

  Future<void> checkIfUserExists() async {
    String? userId = await SharedPreferencesUtil.getUserId();
    FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

    print("LOG splash $userId");
    Navigator.pop(context);
    // App does NOT have userId preference
    if (userId != null) {
      if (Utils.testingNewRegistration) {
        var _snapshotUser = await _databaseSource.getUser(userId);

        AppUser _user = AppUser.fromSnapshot(_snapshotUser);

        print("LOG IS SETUP COMPLETED ??? ${_user.setupIsCompleted}");

        if (_user.setupIsCompleted) {
          Navigator.pushNamed(context, MainNavigation.id);
        } else {
          Navigator.pushNamed(context, FirstNameBggPage.id);
        }
      }
    } else {
      Navigator.pushNamed(context, LoginPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: kDefaultPadding,
          child: Container(),
        ),
      ),
    );
  }
}
