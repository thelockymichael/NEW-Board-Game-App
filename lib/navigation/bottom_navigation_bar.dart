import 'package:flutter/material.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/chats_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/discover_page.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page.dart';

class MainNavigation extends StatefulWidget {
  static const String id = 'main_navigation_page';

  const MainNavigation({Key? key}) : super(key: key);

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
    screens = [const DiscoverPage(), const ChatsScreen(), const ProfilePage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
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
