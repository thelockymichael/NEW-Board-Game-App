import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/PositionLocality.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/tutorial_screens/tutorial_navigation.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';
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

  bool errorMessageEnabled = false;

  String? _currentLocation;
  Position? _currentGeoLocation;

  CancelableOperation? _myCancelableFuture;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  late StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future<Response> _getCurrentPosition(AppUser appUser) async {
    print("LOG GET CURRENT LOCATION BUTTON WAS PRESSED");
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      return Response.error("Location permission not granted.");
    }

    final position = await _geolocatorPlatform.getCurrentPosition();

    print("LOG position latitude ${position.latitude.toString()}");
    print("LOG position longitude ${position.longitude.toString()}");

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "fi");

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Response<dynamic> response = await userProvider
        .updateGeoLocationAndLocality(
            appUser, position, placemarks[0].locality!, context)
        .then(((value) {
      print("LOG kl successfully uploaded");
      return Response.success(PositionLocality(position, placemarks[0]));
    })).catchError((err) {
      print("LOG kl error");
    });

    if (response is Success<String>) {
      return Response.success(PositionLocality(position, placemarks[0]));
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
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
            "Location permissions have been denied. We cannot provide you the nearest users."),
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

                                                    Response<dynamic> response =
                                                        await _getCurrentPosition(
                                                      userSnapshot.data!,
                                                    );
                                                    print("LOG kl ${response}");

                                                    if (response is Success<
                                                        PositionLocality>) {
                                                      if (_isLoaderVisible) {
                                                        context.loaderOverlay
                                                            .hide();
                                                      }
                                                      PositionLocality
                                                          positionLocality =
                                                          response.value;

                                                      print(
                                                          "LOG kl position ${positionLocality.position}");
                                                      print(
                                                          "LOG kl position ${positionLocality.placemark.locality}");

                                                      await userProvider
                                                          .updateSetupCompleted(
                                                              true,
                                                              positionLocality,
                                                              userSnapshot
                                                                  .data!,
                                                              context);

                                                      bool? tutorialCompleted =
                                                          await SharedPreferencesUtil
                                                              .getTutorialState();

                                                      print(
                                                          "LOG cvb tutorialCompleted: bool => $tutorialCompleted");

                                                      if (tutorialCompleted !=
                                                          null) {
                                                        if (tutorialCompleted) {
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      MainNavigation()),
                                                              (route) => false);
                                                        } else {
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      TutorialNavigation()),
                                                              (route) => false);
                                                        }
                                                      } else {
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    TutorialNavigation()),
                                                            (route) => false);
                                                      }
                                                    }
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
