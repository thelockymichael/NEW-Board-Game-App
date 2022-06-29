import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/loading_overlay.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_demo_01/utils/utils.dart';

class AddPhotosPage extends StatefulWidget {
  static const String id = 'gender_page';

  const AddPhotosPage({Key? key}) : super(key: key);

  @override
  AddPhotosPageState createState() => AddPhotosPageState();
}

class AddPhotosPageState extends State<AddPhotosPage> {
  final UserRegistration _userRegistration = UserRegistration();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // END

  bool _isLoaderVisible = false;
  late UserProvider _userProvider;

  /* 1. Gender Select */
  // 1. Default Selected Gender

  List<String> availableGenders = ["male", "female", "other"];

  List<String> selectedGender = [];

  bool errorMessageEnabled = false;

  // String selectedGender = defaultSelectedGender;

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Add Photos",
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 200,
                                          child: ListView(
                                            children:
                                                availableGenders.map((gender) {
                                              final isSelected = selectedGender
                                                  .contains(gender);

                                              final selectedColor =
                                                  Theme.of(context)
                                                      .primaryColor;
                                              final style = isSelected
                                                  ? TextStyle(
                                                      fontSize: 18,
                                                      color: selectedColor,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : TextStyle(fontSize: 18);

                                              return ListTile(
                                                onTap: () {
                                                  // setState(() {
                                                  //   errorMessageEnabled = false;
                                                  // });
                                                  selectedGender.clear();

                                                  final isSelected =
                                                      selectedGender
                                                          .contains(gender);

                                                  setState(() {
                                                    errorMessageEnabled = false;

                                                    isSelected
                                                        ? selectedGender
                                                            .remove(gender)
                                                        : selectedGender
                                                            .add(gender);
                                                  });
                                                  print(
                                                      "LOG isSelected selectedGender: $selectedGender");
                                                  print(
                                                      "LOG isSelected gender: $gender");
                                                },
                                                title: Text(
                                                  gender.capitalize(),
                                                  style: style,
                                                ),
                                                trailing: isSelected
                                                    ? Icon(
                                                        Icons
                                                            .radio_button_checked,
                                                        color: selectedColor,
                                                        size: 26)
                                                    : Icon(
                                                        Icons
                                                            .radio_button_unchecked,
                                                        color: selectedColor,
                                                        size: 26),
                                              );
                                            }).toList(),
                                            // children: [Text("Hello")],
                                          ),
                                        ),
                                        errorMessageEnabled
                                            ? Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 8, 0, 8),
                                                child: Text(
                                                  "Gender must be selected.",
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
                                                  bool isValidGender =
                                                      Validator.validateGender(
                                                          selectedGender:
                                                              selectedGender);
                                                  if (isValidGender) {
                                                    print("LOG isValid Gender");

                                                    _userRegistration.gender =
                                                        selectedGender[0];

                                                    context.loaderOverlay.show(
                                                        widget: UpdateGender());
                                                    setState(() {
                                                      _isLoaderVisible = context
                                                          .loaderOverlay
                                                          .visible;
                                                    });

                                                    await _userProvider
                                                        .updateGender(
                                                            userSnapshot.data!,
                                                            _userRegistration,
                                                            _scaffoldKey)
                                                        .then((response) {
                                                      if (response is Success) {
                                                        if (_isLoaderVisible) {
                                                          context.loaderOverlay
                                                              .hide();
                                                        }
                                                      }
                                                    });

                                                    Navigator.of(context)
                                                        .push(PageRouteBuilder(
                                                      pageBuilder: (
                                                        BuildContext context,
                                                        Animation<double>
                                                            animation,
                                                        Animation<double>
                                                            secondaryAnimation,
                                                      ) =>
                                                          AddPhotosPage(),
                                                      transitionsBuilder: (
                                                        BuildContext context,
                                                        Animation<double>
                                                            animation,
                                                        Animation<double>
                                                            secondaryAnimation,
                                                        Widget child,
                                                      ) =>
                                                          SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                              1, 0),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: child,
                                                      ),
                                                    ));
                                                  } else {
                                                    setState(() {
                                                      errorMessageEnabled =
                                                          true;
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'Next',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
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

class UpdateGender extends StatelessWidget {
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
                  'Setting gender.',
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
