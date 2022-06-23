// ignore_for_file: prefer_function_declarations_over_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
import 'package:flutter_demo_01/components/discover/discover_card.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/UserQuery.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/my_flutter_app_icons.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  static const String id = 'discover_page';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPage createState() => _DiscoverPage();
}

class _DiscoverPage extends State<DiscoverPage> with TickerProviderStateMixin {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<String> _ignoreSwipeIds;
  late List<AppUser> _userList;

  // Default Selected Gender
  List<String> defaultSelectedGender = ["everyone"];

  // Min Age Value
  int defaultMinAgeValue = 17;

  // Max Age Value
  int defaultMaxAgeValue = 27;

  List<UserQuery> userQuery = [];

  late CardProvider cardProvider;

  AppUser _myUser = AppUser(
      id: "test id",
      name: "test name",
      email: "test@gmail.com",
      favBoardGameGenres: [],
      favBgMechanics: [],
      favBgThemes: [],
      favBoardGames: FavBoardGames(familyGames: [
        SelectedBoardGame(
          rank: 1,
          boardGame: BoardGameData(
            bggId: 0,
            imageUrl: [""],
            name: "",
            recRank: 0,
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
            year: 0,
          ),
        )
      ]));

  // Filter Menu Controller
  late AnimationController filterMenuController;

  // Gender Menu Controller
  late AnimationController genderMenuController;

  // Age Menu Controller
  late AnimationController ageMenuController;

  @override
  void initState() {
    super.initState();
    _ignoreSwipeIds = <String>[];
    _userList = <AppUser>[];

    cardProvider = Provider.of<CardProvider>(context, listen: false);

    // Filter Menu Controller
    filterMenuController = BottomSheet.createAnimationController(this);
    filterMenuController.duration = Duration(microseconds: 0);

    // Gender Menu Controller
    genderMenuController = BottomSheet.createAnimationController(this);
    genderMenuController.duration = Duration(microseconds: 0);

    // Age Menu Controller
    ageMenuController = BottomSheet.createAnimationController(this);
    ageMenuController.duration = Duration(microseconds: 0);
  }

  @override
  void dispose() {
    filterMenuController.dispose();
    genderMenuController.dispose();
    ageMenuController.dispose();
    super.dispose();
  }

  Future<List<AppUser>?> loadPerson(List<UserQuery> userQuery) async {
    print("LOK");

    String? id = await SharedPreferencesUtil.getUserId();

    if (id != null) {
      _myUser = AppUser.fromSnapshot(await _databaseSource.getUser(id));
    }

    _ignoreSwipeIds = <String>[];
    _userList = <AppUser>[];

    var swipes = await _databaseSource.getSwipes(_myUser.id);
    for (var i = 0; i < swipes.size; i++) {
      Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
      _ignoreSwipeIds.add(swipe.id);
    }
    _ignoreSwipeIds.add(_myUser.id);

    var res = await _databaseSource.getPersonsToMatchWith(
        100, _ignoreSwipeIds, userQuery);

    if (res.docs.isNotEmpty) {
      for (var element in res.docs) {
        _userList.add(AppUser.fromSnapshot(element));
      }

      // FILTER ALL STUFFS

      print("CVB MIN: $defaultMinAgeValue");
      print("CVB MAX: $defaultMaxAgeValue");

      _userList.removeWhere(((element) =>
          element.age < defaultMinAgeValue ||
          element.age > defaultMaxAgeValue));

      print(
          "VMK !!LOAD PERSON!! length of users ${_userList.reversed.toList().length}");

      cardProvider.setUsers(_userList.reversed.toList());

      return _userList.reversed.toList();
    }

    return null;
  }

  void _filterSwipableUsersModalBottomSheet(BuildContext context,
      [controller]) {
    showModalBottomSheet(
        transitionAnimationController: controller,
        barrierColor: Colors.black54,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            /* 1. Gender Select */
            List<String> availableGenders = [
              "everyone",
              "men",
              "women",
              "other"
            ];

            List<String> selectedGender = defaultSelectedGender;

            int selectedMinAge = defaultMinAgeValue;
            int selectedMaxAge = defaultMaxAgeValue;

            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Text("Show me",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(selectedGender[0].capitalize(),
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(width: 12),
                                const Icon(CustomIcons.right_open)
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              _showGendersModal(
                                  context, availableGenders, selectedGender);
                            },
                          ),
                          ListTile(
                            leading: Text("Age range",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("$selectedMinAge - $selectedMaxAge",
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(width: 12),
                                const Icon(CustomIcons.right_open)
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              _showAgeModal(
                                  context, selectedMinAge, selectedMaxAge);
                            },
                          ),
                          ElevatedButton(
                            child: const Text("Apply filters",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              print("Selected gender $selectedGender");

                              List<UserQuery> updateUserQuery = [
                                UserQuery(
                                    "gender", "isEqualTo", selectedGender[0])
                              ];

                              bool ageQueryExists = false;

                              for (var i = 0; i < updateUserQuery.length; i++) {
                                if (updateUserQuery[i].field.contains("age") &&
                                    updateUserQuery[i]
                                        .condition
                                        .contains("isGreaterThanOrEqualTo")) {
                                  updateUserQuery.removeAt(i);

                                  updateUserQuery.add(UserQuery(
                                      "age",
                                      "isGreaterThanOrEqualTo",
                                      selectedMinAge));
                                  ageQueryExists = true;
                                  continue;
                                }
                                if (updateUserQuery[i].field.contains("age") &&
                                    updateUserQuery[i]
                                        .condition
                                        .contains("isLessThanOrEqualTo")) {
                                  updateUserQuery.removeAt(i);

                                  updateUserQuery.add(UserQuery("age",
                                      "isLessThanOrEqualTo", selectedMaxAge));
                                  ageQueryExists = true;
                                  continue;
                                }
                              }
                              if (ageQueryExists == false) {
                                updateUserQuery.add(UserQuery("age",
                                    "isGreaterThanOrEqualTo", selectedMinAge));

                                updateUserQuery.add(UserQuery("age",
                                    "isLessThanOrEqualTo", selectedMaxAge));
                              }

                              this.setState(() {
                                userQuery = updateUserQuery;
                              });

                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ));
          });
        });
  }

  void _showGendersModal(BuildContext filterContext,
      List<String> availableGenders, List<String> selectedGender) {
    showModalBottomSheet(
      barrierColor: Colors.black54,
      transitionAnimationController: genderMenuController,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      context: filterContext,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Column(
                children: [
                  Text("Show me",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text("Which genders(s) would you like to see?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black54)),
                  SizedBox(height: 16),
                  Expanded(
                      child: ListView(
                          children: availableGenders.map((gender) {
                    final isSelected = selectedGender.contains(gender);

                    final selectedColor = Theme.of(context).primaryColor;
                    final style = isSelected
                        ? TextStyle(
                            fontSize: 18,
                            color: selectedColor,
                            fontWeight: FontWeight.bold,
                          )
                        : TextStyle(fontSize: 18);

                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pop();

                        selectedGender.clear();

                        final isSelected = selectedGender.contains(gender);

                        setState(() => isSelected
                            ? this.defaultSelectedGender.remove(gender)
                            : this.defaultSelectedGender.add(gender));

                        print("selectedGender, ${selectedGender[0]}");

                        _filterSwipableUsersModalBottomSheet(
                            context, filterMenuController);

                        /*
                          _filterSwipableUsersModalBottomSheet(
                          context, selectedGender[0], controller);
                        */
                      },
                      title: Text(
                        gender.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.radio_button_checked,
                              color: selectedColor, size: 26)
                          : Icon(Icons.radio_button_unchecked,
                              color: selectedColor, size: 26),
                    );
                  }).toList()))
                ],
              ));
        });
      },
    );
  }

  void _showAgeModal(
      BuildContext ageContext, int selectedMinAge, int selectedMaxAge) {
    showModalBottomSheet(
      barrierColor: Colors.black54,
      transitionAnimationController: ageMenuController,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      context: ageContext,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Column(
                children: [
                  Text("Age range",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberPicker(
                        value: selectedMinAge,
                        minValue: 0,
                        maxValue: 100,
                        step: 1,
                        haptics: true,
                        onChanged: (value) =>
                            setState(() => selectedMinAge = value),
                      ),
                      NumberPicker(
                        value: selectedMaxAge,
                        minValue: 0,
                        maxValue: 100,
                        step: 1,
                        haptics: true,
                        onChanged: (value) =>
                            setState(() => selectedMaxAge = value),
                      )
                    ],
                  ),
                  ElevatedButton(
                    child: const Text("Apply",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      print("VMK $selectedMinAge");
                      print("VMK $selectedMaxAge");

                      setState(() {
                        this.defaultMinAgeValue = selectedMinAge;
                        this.defaultMaxAgeValue = selectedMaxAge;
                      });

                      _filterSwipableUsersModalBottomSheet(
                          context, filterMenuController);
                    },
                  )
                ],
              ));
        });
      },
    );
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              color: Colors.black,
              icon: const Icon(CustomIcons.sliders),
              onPressed: () {
                _filterSwipableUsersModalBottomSheet(
                  context,
                );
              },
            )
          ],
        ),
        key: _scaffoldKey,
        body: FutureBuilder<List<AppUser>?>(
            future: loadPerson(userQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData) {
                return Center(
                  child: Text('No more users to swipe',
                      style: Theme.of(context).textTheme.headline4),
                );
              }
              if (!snapshot.hasData) {
                return CustomModalProgressHUD(
                  inAsyncCall: true,
                  child: Container(),
                );
              }

              return DiscoverCard(
                myUser: _myUser,
                ignoreSwipeIds: _ignoreSwipeIds,
                notifyParent: refresh,
              );
            }));
  }

  Widget buildLogo() => Row(
        children: const [
          Icon(
            Icons.gamepad_rounded,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(width: 4),
          Text(
            'Board Game Buddy',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      );

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    final getBorder = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
