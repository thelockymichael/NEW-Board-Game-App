import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/tutorial_screens/tutorial_navigation.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EnableLocationPage extends StatefulWidget {
  static const String id = 'enable_location_page';

  const EnableLocationPage({
    Key? key,
  }) : super(key: key);

  @override
  EnableLocationPageState createState() => EnableLocationPageState();
}

class EnableLocationPageState extends State<EnableLocationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // END

  bool _isLoaderVisible = false;
  late UserProvider _userProvider;

  /* 1. Gender Select */
  // 1. Default Selected Gender

  late List<String> selectedPhotos;

  bool errorMessageEnabled = false;

  String? _currentLocation;
  Position? _currentGeoLocation;

  /// 1. END Gender Select END */

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return Response.error("Permission not granted");

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentGeoLocation = position);

      _getAddressFromLatLng(_currentGeoLocation!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    AppUser userSnapshot = await _userProvider.user;

    print("SDF ${userSnapshot.name}");
    await placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "fi")
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      setState(() {
        _currentLocation = '${place.locality}';
        _userProvider.updateCurrentLocationAddress(
            userSnapshot, _currentLocation!, context);

        _userProvider.updateCurrentGeoLocation(userSnapshot, position, context);
      });
    }).catchError((e) {
      debugPrint(e);
    });
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
        appBar: AppBar(),
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                    inAsyncCall: userProvider.isLoading,
                    child: userSnapshot.hasData
                        ? Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          const Icon(Icons.location_pin,
                                              size: 120, color: Colors.grey),
                                          const Text(
                                            "Enable location",
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            "With access to location data app can find you the best users near you.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87),
                                          ),
                                          errorMessageEnabled
                                              ? Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 8, 0, 8),
                                                  child: Text(
                                                    "At least one photo must be uploaded.",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                )
                                              : Container(),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    context.loaderOverlay.show(
                                                        widget:
                                                            (CreateLocationOverlay()));
                                                    setState(() {
                                                      _isLoaderVisible = context
                                                          .loaderOverlay
                                                          .visible;
                                                    });

                                                    Timer(Duration(seconds: 1),
                                                        () async {
                                                      if (_isLoaderVisible) {
                                                        context.loaderOverlay
                                                            .hide();
                                                      } //   userSnapshot.data!
                                                      userSnapshot.data!
                                                              .setupIsCompleted =
                                                          true;

                                                      userProvider
                                                          .updateSetupCompleted(
                                                              userSnapshot
                                                                  .data!,
                                                              context)
                                                          .asStream()
                                                          .listen(
                                                              (event) async {
                                                        bool?
                                                            tutorialCompleted =
                                                            await SharedPreferencesUtil
                                                                .getTutorialState();

                                                        print(
                                                            "LOG kl $tutorialCompleted");

                                                        if (tutorialCompleted !=
                                                            null) {
                                                          if (tutorialCompleted) {
                                                            Navigator.pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        MainNavigation()),
                                                                (route) =>
                                                                    false);
                                                          } else {
                                                            Navigator.pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        TutorialNavigation()),
                                                                (route) =>
                                                                    false);
                                                          }
                                                        } else {
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      TutorialNavigation()),
                                                              (route) => false);
                                                        }
                                                      });
                                                    });

                                                    // await _getCurrentPosition()
                                                    //     .then((value) {
                                                    //   if (_isLoaderVisible) {
                                                    //     context.loaderOverlay.hide();
                                                    //   }

                                                    //   userSnapshot.data!
                                                    //       .setupIsCompleted = true;

                                                    //   userProvider
                                                    //       .updateSetupCompleted(
                                                    //           userSnapshot.data!,
                                                    //           _scaffoldKey);

                                                    //   Navigator.of(context)
                                                    //       .pushNamedAndRemoveUntil(
                                                    //           MainNavigation.id,
                                                    //           (route) => false);
                                                    // });
                                                  },
                                                  child: const Text(
                                                    'ENABLE LOCATION',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          )
                        : Container());
              });
        }));
  }
}

class CreateLocationOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
          child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue[300]),
        height: 100,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Updating your current city\n and geo location.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Please wait...',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ));
}
