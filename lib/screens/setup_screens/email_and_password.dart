import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/setup_screens/first_name_bgg_page.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EmailAndPassword extends StatefulWidget {
  static const String id = 'email_and_password';

  const EmailAndPassword({Key? key}) : super(key: key);

  @override
  _EmailAndPasswordState createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  final UserRegistration _userRegistration = UserRegistration();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _registerFormKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _confirmFocusPassword = FocusNode();

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
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _confirmFocusPassword.unfocus();
      },
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(""),
          leading: new IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_circle_left_rounded,
                size: 50, color: Colors.white),
          ),
          backgroundColor:
              Colors.redAccent.withOpacity(0.0), //You can make this transparent
          elevation: 0.0, //No
        ),
        body: Stack(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(0.0),
                        Colors.black.withOpacity(0.6)
                      ],
                      stops: const [
                        0.0,
                        1.0
                      ]),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/register-login.jpg',
                    ),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 48, bottom: 24.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Create new account",
                                style: TextStyle(
                                    fontSize: 32, color: Colors.white),
                              ),
                            )
                          ],
                        )),
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailTextController,
                            focusNode: _focusEmail,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Email",
                              fillColor: Colors.blue[300],
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordTextController,
                            focusNode: _focusPassword,
                            obscureText: true,
                            validator: (value) =>
                                Validator.validatePassword(value!),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blue[300],
                              hintText: "Password",
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _confirmPasswordTextController,
                            focusNode: _confirmFocusPassword,
                            obscureText: true,
                            validator: (value) => Validator.confirmPassword(
                              password: _passwordTextController.text,
                              confirmPassword: value,
                            ),
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.blue[300],
                              hintText: "Confirm password",
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      _userRegistration.email =
                                          _emailTextController.text;

                                      _userRegistration.password =
                                          _passwordTextController.text;

                                      _userRegistration.confirmPassword =
                                          _confirmPasswordTextController.text;

                                      // Loader Overlay
                                      context.loaderOverlay
                                          .show(widget: CreateNewUserOverlay());
                                      setState(() {
                                        _isLoaderVisible =
                                            context.loaderOverlay.visible;
                                      });

                                      await _userProvider
                                          .registerUser(
                                              _userRegistration, context)
                                          .then((response) {
                                        if (response is Success) {
                                          AppUser user = response.value;

                                          // TODO observe user, when user exists =>
                                          // TODO push new screen !
                                          _databaseSource
                                              .observeUser(user.id)
                                              .listen((event) {})
                                              .onData((data) async {
                                            if (data.exists) {
                                              if (_isLoaderVisible) {
                                                context.loaderOverlay.hide();
                                              }

                                              AppUser appUser =
                                                  AppUser.fromSnapshot(data);
                                              print(
                                                  "LOG signup sdf appUser, ${appUser}");
                                              print(
                                                  "LOG signup sdf appUser, ${appUser.setupIsCompleted}");

                                              await SharedPreferencesUtil
                                                  .setUserId(appUser.id);

                                              if (appUser.setupIsCompleted) {
                                                Navigator.pop(context);
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        MainNavigation.id,
                                                        (route) => false);
                                              } else {
                                                Navigator.pop(context);
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        FirstNameBggPage.id,
                                                        (route) => false);
                                              }
                                            }
                                          });
                                        } else {
                                          if (_isLoaderVisible) {
                                            context.loaderOverlay.hide();
                                          }
                                        }
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(color: Colors.white),
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
              )),
        ]),
      )),
    );
  }
}

class CreateNewUserOverlay extends StatelessWidget {
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
                  'Creating new account.',
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
