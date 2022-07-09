import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/chats_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/discover_page.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  static const String id = 'main_navigation_page';

  const MainNavigation({Key? key}) : super(key: key);

  @override
  _MainNavigation createState() => _MainNavigation();
}

class _MainNavigation extends State<MainNavigation> {
  var screens = [];
  int currentIndex = 0;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    _getCurrentPosition();
    // 4 Different Tab Screens
    screens = [const DiscoverPage(), const ChatsScreen(), const ProfilePage()];
  }

  CancelableOperation? _myCancelableFuture;

  Future _getCurrentPosition() async {
    print("LOG GET CURRENT LOCATION BUTTON WAS PRESSED");
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();

    print("LOG position latitude ${position.latitude.toString()}");
    print("LOG position longitude ${position.longitude.toString()}");

    _getAddressFromLatLng(position);
  }

  Future _myFuture(Position position, AppUser userSnapshot) async {
    // await Future.delayed(const Duration(seconds: 5));
    // return 'Future completed';

    placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "fi")
        .asStream()
        .listen((placemarks) {
      Placemark place = placemarks[0];
      print("LOG place ${place.locality}");

      _userProvider.updateCurrentLocationAddress(
          userSnapshot, place.locality!, context);

      _userProvider.updateCurrentGeoLocation(userSnapshot, position, context);
    });
  }

  Future _getAddressFromLatLng(Position? position) async {
    AppUser userSnapshot = await _userProvider.user;

    print("SDF ${userSnapshot.name}");
    if (position != null) {
      _myCancelableFuture = CancelableOperation.fromFuture(
        _myFuture(position, userSnapshot),
        onCancel: () => 'Future has been cancelled',
      );
    }
  }

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void dispose() {
    _myCancelableFuture?.cancel();

    super.dispose();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("Location services are disabled. Please enable the services"),
      ));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permissions are denied")));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Location permissions are permanently denied, we cannot request permissions."),
      ));
      return false;
    }

    return true;
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
