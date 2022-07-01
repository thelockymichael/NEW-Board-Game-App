import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/setup_screens/date_of_birth_page.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_demo_01/utils/utils.dart';

class FirstNameBggPage extends StatefulWidget {
  static const String id = 'first_name_bgg_page';

  const FirstNameBggPage({Key? key}) : super(key: key);

  @override
  FirstNameBggPageState createState() => FirstNameBggPageState();
}

class FirstNameBggPageState extends State<FirstNameBggPage> {
  final UserRegistration _userRegistration = UserRegistration();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _registerFormKey = GlobalKey<FormState>();

  final _firstNameTextController = TextEditingController();
  final _bggUsernameTextController = TextEditingController();

  final _focusFirstName = FocusNode();
  final _focusBggUsername = FocusNode();

  bool _isLoaderVisible = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusFirstName.unfocus();
          _focusBggUsername.unfocus();
        },
        child: Scaffold(
            appBar: AppBar(),
            body:
                Consumer<UserProvider>(builder: (context, userProvider, child) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "First name",
                                          style: TextStyle(fontSize: 32),
                                        ),
                                        Form(
                                          key: _registerFormKey,
                                          child: Column(
                                            children: <Widget>[
                                              TextFormField(
                                                controller:
                                                    _firstNameTextController
                                                      ..text = userSnapshot
                                                              .data?.name
                                                              .capitalize() ??
                                                          "",
                                                focusNode: _focusFirstName,
                                                validator: (value) =>
                                                    Validator.validateFirstName(
                                                  firstName: value,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "First name",
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              Text(
                                                "Board Game Geek username",
                                                style: TextStyle(fontSize: 32),
                                              ),
                                              TextFormField(
                                                controller:
                                                    _bggUsernameTextController
                                                      ..text = userSnapshot
                                                              .data?.bggName
                                                              .capitalize() ??
                                                          "",
                                                focusNode: _focusBggUsername,
                                                validator: (value) => Validator
                                                    .validateBggUsername(
                                                        bggUsername: value),
                                                decoration: InputDecoration(
                                                  hintText: "BGG username",
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 8, 0, 8),
                                                child: Text(
                                                    "Your first name and board game geek username will be visible to other users. You can edit these later."),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (_registerFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          _userRegistration
                                                                  .firstName =
                                                              _firstNameTextController
                                                                  .text;

                                                          _userRegistration
                                                                  .bggUsername =
                                                              _bggUsernameTextController
                                                                  .text;

                                                          // Loader Overlay
                                                          context.loaderOverlay
                                                              .show(
                                                                  widget:
                                                                      UpdateFirstNameAndBggUsername());
                                                          setState(() {
                                                            _isLoaderVisible =
                                                                context
                                                                    .loaderOverlay
                                                                    .visible;
                                                          });

                                                          await _userProvider
                                                              .updateFirstNameAndBggUsername(
                                                                  userSnapshot
                                                                      .data!,
                                                                  _userRegistration,
                                                                  _scaffoldKey)
                                                              .then((response) {
                                                            if (response
                                                                is Success) {
                                                              if (_isLoaderVisible) {
                                                                context
                                                                    .loaderOverlay
                                                                    .hide();
                                                              }

                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      PageRouteBuilder(
                                                                pageBuilder: (
                                                                  BuildContext
                                                                      context,
                                                                  Animation<
                                                                          double>
                                                                      animation,
                                                                  Animation<
                                                                          double>
                                                                      secondaryAnimation,
                                                                ) =>
                                                                    DateOfBirthPage(),
                                                                transitionsBuilder: (
                                                                  BuildContext
                                                                      context,
                                                                  Animation<
                                                                          double>
                                                                      animation,
                                                                  Animation<
                                                                          double>
                                                                      secondaryAnimation,
                                                                  Widget child,
                                                                ) =>
                                                                    SlideTransition(
                                                                  position: Tween<
                                                                      Offset>(
                                                                    begin:
                                                                        const Offset(
                                                                            1,
                                                                            0),
                                                                    end: Offset
                                                                        .zero,
                                                                  ).animate(
                                                                      animation),
                                                                  child: child,
                                                                ),
                                                              ));
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container());
                  });
            })));
  }
}

class UpdateFirstNameAndBggUsername extends StatelessWidget {
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
                  'Setting first name and bgg name.',
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
