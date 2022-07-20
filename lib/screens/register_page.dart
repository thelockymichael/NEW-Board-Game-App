import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/google_sign_in.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/login_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/email_and_password.dart';
import 'package:flutter_demo_01/screens/setup_screens/first_name_bgg_page.dart';
import 'package:flutter_demo_01/screens/v1_register_page.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late UserProvider _userProvider;

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  bool _isLoaderVisible = false;

  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  int intInRange(Random source, int min, int max) =>
      min + source.nextInt(max - min);

  Future createFiftyUsers() async {
    // print("LOG ${doubleInRange(random, 20, 60)}");

    int amount = 50;

    List<String> randomNames = [
      "Jaska",
      "Kalle",
      "Sanna",
      "Suvi",
      "Mervi",
      "Kalevi",
      "Elena",
      "Mirja",
      "Salla",
      "Sanni"
    ];

    for (var i = 0; i <= amount; i++) {
      // TODO 1. Random name
      // TODO 2. Random currentGeoLocation, latitude & longitude

      // Timestamp

// 1. DateTime
      Random intRandom = Random();

      int year = intInRange(intRandom, 1981, 2021);

      int day = intInRange(intRandom, 1, 31);
      int month = intInRange(intRandom, 1, 12);

      int createdAtYear = intInRange(intRandom, 1970, 1980);
      int createdAtDay = intInRange(intRandom, 1, 31);
      int createdAtMonth = intInRange(intRandom, 1, 12);

      DateTime dateTime = new DateTime(
        year,
        month,
        day,
      );
      DateTime createdAtDateTime = new DateTime(
        createdAtYear,
        createdAtMonth,
        createdAtDay,
      );
      Timestamp timestamp = Timestamp.fromDate(dateTime);
      Timestamp createdAtTimestamp = Timestamp.fromDate(createdAtDateTime);
      // END Timestamp
      Random doubleRandom = Random();

      double lat = doubleInRange(doubleRandom, 20, 60);
      double long = doubleInRange(doubleRandom, 20, 60);
      GeoPoint point = GeoPoint(lat, long);

      randomNames.shuffle();
      AppUser user = AppUser(
          id: "${i}",
          createdAt: createdAtTimestamp,
          updatedAt: timestamp,
          setupIsCompleted: false,
          currentGeoLocation: point,
          name: "${randomNames[0]}",
          email: "${randomNames[0]}@gmail.com",
          languages: [],
          favBoardGameGenres: [],
          favBgMechanics: [],
          favBgThemes: [],
          profilePhotoPaths: ["", "", "", "", "", ""],
          favBoardGames: FavBoardGames(familyGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], dexterityGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], partyGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], thematicGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], strategyGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], abstractGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], warGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ]));

      _databaseSource.addUser(user);
    }
  }

  @override
  void initState() {
    super.initState();
    // createFiftyUsers();
    _userProvider = Provider.of(context, listen: false);
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: SingleChildScrollView(
                      child: SizedBox(
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Center(
                              child: Text(
                            'Board game friends',
                            style: Theme.of(context).textTheme.headline2,
                          )),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40), // NEW
                          ),
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EmailAndPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign up with email',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40), // NEW
                          ),
                          onPressed: () async {
                            context.loaderOverlay
                                .show(widget: CreateNewUserOverlay());

                            setState(() {
                              _isLoaderVisible = context.loaderOverlay.visible;
                            });

                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);

                            await provider
                                .googleRegister()
                                .then((response) async {
                              if (response is Success) {
                                UserCredential userCreds = response.value;
                                String id = userCreds.user!.uid;
                                print(
                                    "LOG signup register uid ${userCreds.user!.uid}");

                                await SharedPreferencesUtil.setUserId(id);

                                Timer(Duration(seconds: 10), () async {
                                  if (_isLoaderVisible) {
                                    context.loaderOverlay.hide();
                                  }
                                  var _snapshot =
                                      await _databaseSource.getUser(id);
                                  AppUser appUser =
                                      AppUser.fromSnapshot(_snapshot);

                                  if (appUser.setupIsCompleted) {
                                    Navigator.pop(context);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        MainNavigation.id, (route) => false);
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        FirstNameBggPage.id, (route) => false);
                                  }
                                });
                              } else {
                                if (_isLoaderVisible) {
                                  context.loaderOverlay.hide();
                                }
                              }
                            });
                          },
                          icon: FaIcon(FontAwesomeIcons.google,
                              color: Colors.red),
                          label: const Text(
                            'Sign up with Google',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                              ) =>
                                  LoginPage(color: Colors.black),
                              transitionsBuilder: (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                              ) =>
                                  SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            ));
                          },
                          child: Text("Already have an account? Log in here",
                              style: TextStyle(
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  )));
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<void> signUpWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credentials
      UserCredential result = await auth.signInWithCredential(authCredential);

      User? user = result.user;

      if (result != null) {
        print("LOG register google GREAT SUCCESS!");
      }
    }
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
                  'Logging in to Google',
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