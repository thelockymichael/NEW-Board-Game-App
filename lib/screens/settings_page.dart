import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/login_page.dart';
import 'package:flutter_demo_01/utils/fire_auth.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static const String id = 'settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  void logoutPressed(UserProvider userProvider, BuildContext context) async {
    userProvider.logoutUser();
    Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Settings'),
        ),
        key: _scaffoldKey,
        body: Center(
            child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 42.0,
            horizontal: 18.0,
          ),
          margin: EdgeInsets.only(bottom: 40),
          child:
              Consumer<UserProvider>(builder: (context, userProvider, child) {
            return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                    inAsyncCall:
                        userProvider.user == null || userProvider.isLoading,
                    child: userSnapshot.hasData
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ID: ${userSnapshot.data?.id}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                'NAME: ${userSnapshot.data?.name}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                'EMAIL: ${userSnapshot.data?.email}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              _isSigningOut
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isSigningOut = true;
                                        });
                                        logoutPressed(userProvider, context);
                                      },
                                      child: Text("Sign Out",
                                          style:
                                              TextStyle(color: Colors.white)))
                            ],
                          )
                        : Container());
              },
            );
          }),
        )));
  }
}
