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
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/setup_screens/email_and_password.dart';
import 'package:flutter_demo_01/screens/v1_register_page.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:provider/provider.dart';

class LoginWithEmail extends StatefulWidget {
  static const String id = 'login_with_email';
  final Color? color;

  const LoginWithEmail({Key? key, this.color}) : super(key: key);

  @override
  _LoginWithEmailState createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late UserProvider _userProvider;

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

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
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
          leading: new IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_rounded, size: 40, color: Colors.black),
          ),
          backgroundColor:
              Colors.redAccent.withOpacity(0.0), //You can make this transparent
          elevation: 0.0, //No
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Center(
                      child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(
                                  email: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: true,
                                validator: (value) =>
                                    Validator.validatePassword(value!),
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24.0),
                              _isProcessing
                                  ? const CircularProgressIndicator()
                                  : Utils.testingNewRegistration
                                      // NEW REGISTRATION
                                      ? Column(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size.fromHeight(
                                                        40), // NEW
                                              ),
                                              onPressed: () async {
                                                _focusEmail.unfocus();
                                                _focusPassword.unfocus();

                                                if (_formKey.currentState!
                                                    .validate()) {
// TODO LOGIN
// TODO Login wrong credentials => Show message: "Incorrect password or email"

                                                  setState(() {
                                                    _isProcessing = true;
                                                  });

                                                  await _userProvider.loginUser(
                                                      _emailTextController.text,
                                                      _passwordTextController
                                                          .text,
                                                      context);

                                                  setState(() {
                                                    _isProcessing = false;
                                                  });
                                                }
                                              },
                                              child: const Text(
                                                'Login',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  _focusEmail.unfocus();
                                                  _focusPassword.unfocus();

                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      _isProcessing = true;
                                                    });

                                                    await _userProvider
                                                        .loginUser(
                                                            _emailTextController
                                                                .text,
                                                            _passwordTextController
                                                                .text,
                                                            context)
                                                        .then((response) {
                                                      if (response is Success<
                                                          UserCredential>) {
                                                        Navigator.of(context)
                                                            .pushNamedAndRemoveUntil(
                                                                MainNavigation
                                                                    .id,
                                                                (route) =>
                                                                    false);
                                                      }
                                                    });

                                                    setState(() {
                                                      _isProcessing = false;
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 24.0),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const V1RegisterPage(),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'Register',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
}
