import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/loading_overlay.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_demo_01/utils/utils.dart';

class EnableLocationPage extends StatefulWidget {
  static const String id = 'enable_location_page';

  const EnableLocationPage({
    Key? key,
  }) : super(key: key);

  @override
  EnableLocationPageState createState() => EnableLocationPageState();
}

class EnableLocationPageState extends State<EnableLocationPage> {
  final UserRegistration _userRegistration = UserRegistration();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // END

  bool _isLoaderVisible = false;
  late UserProvider _userProvider;

  /* 1. Gender Select */
  // 1. Default Selected Gender

  late List<String> selectedPhotos;

  bool errorMessageEnabled = false;

  // TODO Check if photo(s) already exist(s)

  /** 1. END Gender Select END */
  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
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
                                child: Column(
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
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                    errorMessageEnabled
                                        ? Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Text(
                                              "At least one photo must be uploaded.",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        : Container(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // TODO

                                              // bool isValidGender =
                                              //     Validator.validatePhotosArray(
                                              //         photosArray:
                                              //             selectedPhotos);
                                              // if (isValidGender) {
                                              //   print("LOG photos are valid");

                                              // _userRegistration.gender =
                                              //     selectedGender[0];

                                              // TODO if selectedPhotos are not empty

                                              // Navigator.of(context)
                                              //     .push(PageRouteBuilder(
                                              //   pageBuilder: (
                                              //     BuildContext context,
                                              //     Animation<double>
                                              //         animation,
                                              //     Animation<double>
                                              //         secondaryAnimation,
                                              //   ) =>
                                              //       EnableLocationPage(),
                                              //   transitionsBuilder: (
                                              //     BuildContext context,
                                              //     Animation<double>
                                              //         animation,
                                              //     Animation<double>
                                              //         secondaryAnimation,
                                              //     Widget child,
                                              //   ) =>
                                              //       SlideTransition(
                                              //     position: Tween<Offset>(
                                              //       begin: const Offset(
                                              //           1, 0),
                                              //       end: Offset.zero,
                                              //     ).animate(animation),
                                              //     child: child,
                                              //   ),
                                              // ));
                                              // } else {
                                              //   setState(() {
                                              //     errorMessageEnabled = true;
                                              //   });
                                              // }
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
                            ],
                          )
                        : Container());
              });
        }));
  }
}

class UpdatePhotos extends StatelessWidget {
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
                  'Uploading photos.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
