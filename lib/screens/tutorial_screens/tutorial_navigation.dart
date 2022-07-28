import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/chats_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/discover_page.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page.dart';
import 'package:flutter_demo_01/screens/tutorial_screens/tutorial_start.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TutorialNavigation extends StatefulWidget {
  static const String id = 'tutorial_navigation_page';

  const TutorialNavigation({Key? key}) : super(key: key);

  @override
  _TutorialNavigation createState() => _TutorialNavigation();
}

class _TutorialNavigation extends State<TutorialNavigation> {
  var screens = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    screens = [const TutorialStart(), Container(), Container()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.black38,
          unselectedLabelStyle: const TextStyle(
            color: Colors.black38,
          ),
          unselectedItemColor: Colors.black38,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ]),
    );
  }
}
