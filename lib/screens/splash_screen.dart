import 'package:flutter/material.dart';
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
    bool? setupIsCompleted = await SharedPreferencesUtil.getSetupState();

    print("LOG splash $userId");
    Navigator.pop(context);
    if (userId != null) {
      if (Utils.testingNewRegistration) {
        if (setupIsCompleted != null) {
          if (setupIsCompleted) {
            Navigator.pushNamed(context, MainNavigation.id);
          } else {
            Navigator.pushNamed(context, FirstNameBggPage.id);
          }
        } else {
          Navigator.pushNamed(context, MainNavigation.id);
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
