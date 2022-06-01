import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/chats_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/discover_page.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  static const String id = 'main_navigation_page';

  @override
  _MainNavigation createState() => _MainNavigation();
}

class _MainNavigation extends State<MainNavigation> {
  var screens = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // 4 Different Tab Screens
    screens = [
      DiscoverPage(),
      Center(child: Text("Feed", style: TextStyle(fontSize: 60))),
      ChatsScreen(),
      ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Feed',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.green,
            )
          ]),
    );
  }
}
