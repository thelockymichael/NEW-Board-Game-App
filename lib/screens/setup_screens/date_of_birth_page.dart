import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/setup_screens/gender_page.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DateOfBirthPage extends StatefulWidget {
  static const String id = 'date_of_birth_page';

  const DateOfBirthPage({Key? key}) : super(key: key);

  @override
  DateOfBirthPageState createState() => DateOfBirthPageState();
}

class DateOfBirthPageState extends State<DateOfBirthPage> {
  final UserRegistration _userRegistration = UserRegistration();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Set date of birth
  DateTime initDateTime = DateTime(1992, 9, 7);

  late DateTime _dateOfBirth;
  // END

  bool _isLoaderVisible = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    _dateOfBirth = initDateTime;
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
                                      "My Birthday is",
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                            height: 180,
                                            child: CupertinoDatePicker(
                                              initialDateTime: userSnapshot
                                                          .data!.age ==
                                                      0
                                                  ? initDateTime
                                                  : DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          userSnapshot
                                                              .data!.age),
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              onDateTimeChanged:
                                                  (DateTime value) {
                                                _dateOfBirth = value;

                                                print(
                                                    "LOG ${_dateOfBirth.toString()}");
                                              },
                                            )),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 8),
                                          child: Text(
                                              "Your birthday is private information. Only your age is visible to other users."),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  bool isDateOfBirthValid =
                                                      Validator
                                                          .validateDateTime(
                                                              date:
                                                                  _dateOfBirth);

                                                  print(
                                                      "LOG $isDateOfBirthValid");
                                                  if (isDateOfBirthValid) {
                                                    int birthDate = _dateOfBirth
                                                        .millisecondsSinceEpoch;

                                                    _userRegistration
                                                        .birthDate = birthDate;
                                                  }

                                                  context.loaderOverlay.show(
                                                      widget:
                                                          UpdateDateOfBirth());
                                                  setState(() {
                                                    _isLoaderVisible = context
                                                        .loaderOverlay.visible;
                                                  });

                                                  await _userProvider
                                                      .updateDateOfBirth(
                                                          userSnapshot.data!,
                                                          _userRegistration,
                                                          _scaffoldKey)
                                                      .then((response) {
                                                    if (response is Success) {
                                                      if (_isLoaderVisible) {
                                                        context.loaderOverlay
                                                            .hide();
                                                      }

                                                      Navigator.of(context)
                                                          .push(
                                                              PageRouteBuilder(
                                                        pageBuilder: (
                                                          BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secondaryAnimation,
                                                        ) =>
                                                            GenderPage(
                                                          gender: userSnapshot
                                                              .data!.gender,
                                                        ),
                                                        transitionsBuilder: (
                                                          BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secondaryAnimation,
                                                          Widget child,
                                                        ) =>
                                                            SlideTransition(
                                                          position:
                                                              Tween<Offset>(
                                                            begin: const Offset(
                                                                1, 0),
                                                            end: Offset.zero,
                                                          ).animate(animation),
                                                          child: child,
                                                        ),
                                                      ));
                                                    }
                                                  });
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

class UpdateDateOfBirth extends StatelessWidget {
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
                  'Setting date of birth.',
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
