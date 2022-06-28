import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/loading_overlay.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
        child: Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "First Name",
                      style: TextStyle(fontSize: 32),
                    ),
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
                              hintText: "First name",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
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
                              hintText: "Board Game Geek",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(999.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
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
                                              _userRegistration, _scaffoldKey)
                                          .then((response) {
                                        if (response is Success) {
                                          if (_isLoaderVisible) {
                                            context.loaderOverlay.hide();
                                          }

                                          // BACKUP 28.6.22

                                          // Navigator.pop(context);
                                          // Navigator.pushNamed(
                                          //     context, MainNavigation.id);
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
              ),
            ],
          ),
        ));
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
