// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/get_nearest_users_api.dart';
import 'package:flutter_demo_01/components/discover/discover_card.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/UserQuery.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/my_flutter_app_icons.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Page1 extends StatefulWidget {
  final VoidCallback callback;

  const Page1({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  int _currentView = 0;
  late List<Widget> pages;

  @override
  void initState() {
    pages = [
      page1(),
      page2(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("LOG build _currentView ${_currentView}");
    return pages[_currentView];
  }

  @override
  void deactivate() {
    debugPrint('>>> bottom sheet closing');
    widget
        .callback(); // This will be trigger when the bottom sheet finishes closing
    super.deactivate();
  }

  Widget page1() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(60), topLeft: Radius.circular(60))),
      height: 400,
      width: double.maxFinite,
      child: Center(
          child: Column(
        children: [
          Text("Hsajfoas"),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentView = 1;
                print("LOG page1 _currentView ${_currentView}");
              });
            },
            child: Text("click to navigate"),
          ),
        ],
      )),
    );
  }

  Widget page2() {
    return WillPopScope(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60), topLeft: Radius.circular(60))),
          height: 400,
          width: double.maxFinite,
          child: Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentView = 0;
                  print("LOG page2 _currentView ${_currentView}");
                });
              },
              child: Text("click to navigate"),
            ),
          ),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 0;
            print("LOG page2 _currentView ${_currentView}");
          });

          return false;
        });
  }
}

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
  late List<ResultAppUser> _userList;

  // 1. Default Selected Gender
  List<String> defaultSelectedGender = ["everyone"];
  // END

  // 2. Min Age Value
  int defaultMinAgeValue = 17;
  // END

  // 2. Max Age Value
  int defaultMaxAgeValue = 27;
  // END

  // 3. Default Selected Bg Mechanics
  List<String> defaultMechanics = [];
  // END

  // 3. Default Selected Bg Themes
  List<String> defaultThemes = [];
  // END

  // 4. Default Selected Languages
  List<String> defaultLanguages = [];
  // END

  // 5. Default Selected Locality
  List<String> defaultLocality = [];
  // END

  List<UserQuery> userQuery = [];

  late CardProvider cardProvider;

  AppUser _myUser = Utils.user;
  int defaultCurrentView = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // getFunction();

    _ignoreSwipeIds = <String>[];
    _userList = <ResultAppUser>[];

    cardProvider = Provider.of<CardProvider>(context, listen: false);

    // initControllers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<ResultAppUser>?> loadUsers(List<UserQuery> userQuery) async {
    String? id = await SharedPreferencesUtil.getUserId();

    if (id != null) {
      _myUser = AppUser.fromSnapshot(await _databaseSource.getUser(id));
    }

    _ignoreSwipeIds = <String>[];
    _userList = <ResultAppUser>[];

    var swipes = await _databaseSource.getSwipes(_myUser.id);
    for (var i = 0; i < swipes.size; i++) {
      Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
      _ignoreSwipeIds.add(swipe.id);
    }
    _ignoreSwipeIds.add(_myUser.id);

    // BACKUP 11.7.22
    var res = await GetNearestUsers().getNearestUsers(
      // TODO !!! userQuery (e.g. distance, gender, age range, mechanics, themes, languages, locality) !!!
      limit: 10,
      myUser: _myUser,
      distance: 2000,
      ignoreSwipeIds: _ignoreSwipeIds,
    );

    if (res.isNotEmpty) {
      print("LOG guf juk ${res}");
      //   for (var element in res.docs) {
      //     _userList.add(AppUser.fromSnapshot(element));
      //   }

      // print("LOG gufus ${res[0].distance}");
      // print("LOG gufus ${res[0].user.name}");
      // print("LOG gufus ${res[0].distance}");
      cardProvider.setUsers(res.reversed.toList());

      return _userList.reversed.toList();
    }

    // var res = await _databaseSource.getPersonsToMatchWith(
    //     100, _ignoreSwipeIds, userQuery);

    // if (res.docs.isNotEmpty) {
    //   for (var element in res.docs) {
    //     _userList.add(AppUser.fromSnapshot(element));
    //   }

    //   print("CVB MIN: $defaultMinAgeValue");
    //   print("CVB MAX: $defaultMaxAgeValue");

    //   // 1. Age Range
    //   // _userList.removeWhere(((element) =>
    //   //     element.age < defaultMinAgeValue ||
    //   //     element.age > defaultMaxAgeValue));

    //   // END 1. Age Range

    //   // 2. Bg Mechanics
    //   List<AppUser> _usersToRemove = [];

    //   if (defaultMechanics.isNotEmpty) {
    //     for (var i = 0; i < _userList.length; i++) {
    //       for (var j = 0; j < defaultMechanics.length; j++) {
    //         bool doesExist =
    //             _userList[i].favBgMechanics.contains(defaultMechanics[j]);

    //         if (doesExist == false) {
    //           _usersToRemove.add(_userList[i]);
    //         }
    //       }
    //     }
    //   }
    //   // END 2. Bg Mechanics

    //   // 3. Bg Themes
    //   if (defaultThemes.isNotEmpty) {
    //     for (var i = 0; i < _userList.length; i++) {
    //       for (var j = 0; j < defaultThemes.length; j++) {
    //         bool doesExist =
    //             _userList[i].favBgThemes.contains(defaultThemes[j]);

    //         if (doesExist == false) {
    //           _usersToRemove.add(_userList[i]);
    //         }
    //       }
    //     }
    //   }
    //   // END 3. Bg Themes

    //   // 4. Languages
    //   if (defaultLanguages.isNotEmpty) {
    //     for (var i = 0; i < _userList.length; i++) {
    //       for (var j = 0; j < defaultLanguages.length; j++) {
    //         bool doesExist =
    //             _userList[i].languages.contains(defaultLanguages[j]);

    //         if (doesExist == false) {
    //           _usersToRemove.add(_userList[i]);
    //         }
    //       }
    //     }
    //   }
    //   // END 4. Languages

    //   _usersToRemove.forEach((element) {
    //     _userList.remove(element);
    //   });

    //   print("VMK FINAL ${_userList.length}");

    //   print(
    //       "VMK !!LOAD PERSON!! length of users ${_userList.reversed.toList().length}");

    //   cardProvider.setUsers(_userList.reversed.toList());

    //   return _userList.reversed.toList();
    // }

    return null;
  }

  void callback() {
    debugPrint('>>> my callback triggered');
  }

  void _filterSwipableUsersModalBottomSheet() {
    showModalBottomSheet(
        context: (context),
        enableDrag: true,
        isDismissible: true,
        barrierColor: Colors.black54,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        builder: (context) {
          return Page1(callback: callback);
        });
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
                _filterSwipableUsersModalBottomSheet();
              },
            )
          ],
        ),
        key: _scaffoldKey,
        body: FutureBuilder<List<ResultAppUser>?>(
            future: loadUsers(userQuery),
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


 // void _showGendersModal(BuildContext filterContext,
  //     List<String> availableGenders, List<String> selectedGender) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.black54,
  //     transitionAnimationController: genderMenuController,
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     context: filterContext,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             child: Column(
  //               children: [
  //                 Text("Show me",
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 16),
  //                 Text("Distance",
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 16),
  //                 Text("Which genders(s) would you like to see?",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontSize: 18, color: Colors.black54)),
  //                 SizedBox(height: 16),
  //                 Expanded(
  //                     child: ListView(
  //                         children: availableGenders.map((gender) {
  //                   final isSelected = selectedGender.contains(gender);

  //                   final selectedColor = Theme.of(context).primaryColor;
  //                   final style = isSelected
  //                       ? TextStyle(
  //                           fontSize: 18,
  //                           color: selectedColor,
  //                           fontWeight: FontWeight.bold,
  //                         )
  //                       : TextStyle(fontSize: 18);

  //                   return ListTile(
  //                     onTap: () {
  //                       Navigator.of(context).pop();

  //                       selectedGender.clear();

  //                       final isSelected = selectedGender.contains(gender);

  //                       setState(() => isSelected
  //                           ? this.defaultSelectedGender.remove(gender)
  //                           : this.defaultSelectedGender.add(gender));

  //                       print("selectedGender, ${selectedGender[0]}");

  //                       _filterSwipableUsersModalBottomSheet(
  //                           context, filterMenuController);

  //                       /*
  //                         _filterSwipableUsersModalBottomSheet(
  //                         context, selectedGender[0], controller);
  //                       */
  //                     },
  //                     title: Text(
  //                       gender.capitalize(),
  //                       style: style,
  //                     ),
  //                     trailing: isSelected
  //                         ? Icon(Icons.radio_button_checked,
  //                             color: selectedColor, size: 26)
  //                         : Icon(Icons.radio_button_unchecked,
  //                             color: selectedColor, size: 26),
  //                   );
  //                 }).toList()))
  //               ],
  //             ));
  //       });
  //     },
  //   );
  // }

  // void _showLocalityModal(
  //     BuildContext localityContext, List<String> selectedLocality) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.black54,
  //     transitionAnimationController: localityController,
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     context: localityContext,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             child: Column(
  //               children: [
  //                 Text("Show me",
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 16),
  //                 Text("Which genders(s) would you like to see?",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontSize: 18, color: Colors.black54)),
  //                 SizedBox(height: 16),
  //                 Expanded(
  //                     child: ListView(
  //                         children: Utils.localities.map((locality) {
  //                   final isSelected = selectedLocality.contains(locality);

  //                   final selectedColor = Theme.of(context).primaryColor;
  //                   final style = isSelected
  //                       ? TextStyle(
  //                           fontSize: 18,
  //                           color: selectedColor,
  //                           fontWeight: FontWeight.bold,
  //                         )
  //                       : TextStyle(fontSize: 18);

  //                   return ListTile(
  //                     onTap: () {
  //                       Navigator.of(context).pop();

  //                       selectedLocality.clear();

  //                       final isSelected = selectedLocality.contains(locality);

  //                       setState(() => isSelected
  //                           ? this.defaultLocality.remove(locality)
  //                           : this.defaultLocality.add(locality));

  //                       print("selectedLocality, ${selectedLocality[0]}");

  //                       _filterSwipableUsersModalBottomSheet(
  //                           context, filterMenuController);

  //                       /*
  //                         _filterSwipableUsersModalBottomSheet(
  //                         context, selectedlocality[0], controller);
  //                       */
  //                     },
  //                     title: Text(
  //                       locality.capitalize(),
  //                       style: style,
  //                     ),
  //                     trailing: isSelected
  //                         ? Icon(Icons.radio_button_checked,
  //                             color: selectedColor, size: 26)
  //                         : Icon(Icons.radio_button_unchecked,
  //                             color: selectedColor, size: 26),
  //                   );
  //                 }).toList()))
  //               ],
  //             ));
  //       });
  //     },
  //   );
  // }

  // void _showAgeModal(
  //     BuildContext ageContext, int selectedMinAge, int selectedMaxAge) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.black54,
  //     transitionAnimationController: ageMenuController,
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     context: ageContext,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             child: Column(
  //               children: [
  //                 Text("Age range",
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 16),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     NumberPicker(
  //                       value: selectedMinAge,
  //                       minValue: 0,
  //                       maxValue: 100,
  //                       step: 1,
  //                       haptics: true,
  //                       onChanged: (value) =>
  //                           setState(() => selectedMinAge = value),
  //                     ),
  //                     NumberPicker(
  //                       value: selectedMaxAge,
  //                       minValue: 0,
  //                       maxValue: 100,
  //                       step: 1,
  //                       haptics: true,
  //                       onChanged: (value) =>
  //                           setState(() => selectedMaxAge = value),
  //                     )
  //                   ],
  //                 ),
  //                 ElevatedButton(
  //                   child: const Text("Apply",
  //                       style: TextStyle(color: Colors.white)),
  //                   onPressed: () async {
  //                     Navigator.of(context).pop();
  //                     print("VMK $selectedMinAge");
  //                     print("VMK $selectedMaxAge");

  //                     setState(() {
  //                       this.defaultMinAgeValue = selectedMinAge;
  //                       this.defaultMaxAgeValue = selectedMaxAge;
  //                     });

  //                     _filterSwipableUsersModalBottomSheet(
  //                         context, filterMenuController);
  //                   },
  //                 )
  //               ],
  //             ));
  //       });
  //     },
  //   );
  // }

  // void _showGameMechanics(
  //     BuildContext mechanicsContext, List<String> selectedMechanics) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.black54,
  //     transitionAnimationController: mechanicsController,
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     context: mechanicsContext,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             child: Column(
  //               children: [
  //                 Text("Mechanics",
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 16),
  //                 Expanded(
  //                   child: ListView(
  //                       children: Utils.bgMechanicsList.map((bgMechanic) {
  //                     final isSelected = selectedMechanics.contains(bgMechanic);

  //                     final selectedColor = Theme.of(context).primaryColor;
  //                     final style = isSelected
  //                         ? TextStyle(
  //                             fontSize: 18,
  //                             color: selectedColor,
  //                             fontWeight: FontWeight.bold,
  //                           )
  //                         : TextStyle(fontSize: 18);

  //                     return ListTile(
  //                       onTap: () {
  //                         final isSelected =
  //                             selectedMechanics.contains(bgMechanic);

  //                         setState(() => isSelected
  //                             ? selectedMechanics.remove(bgMechanic)
  //                             : selectedMechanics.add(bgMechanic));

  //                         print(
  //                             "selectedMechanics, ${selectedMechanics.length}");
  //                       },
  //                       title: Text(
  //                         bgMechanic,
  //                         style: style,
  //                       ),
  //                       trailing: isSelected
  //                           ? Icon(Icons.check, color: selectedColor, size: 26)
  //                           : null,
  //                     );
  //                   }).toList()),
  //                 ),
  //                 ElevatedButton(
  //                   child: const Text("Apply",
  //                       style: TextStyle(color: Colors.white)),
  //                   onPressed: () async {
  //                     Navigator.of(context).pop();

  //                     setState(() {
  //                       this.defaultMechanics = selectedMechanics;
  //                     });

  //                     print("VMK defaultMechanics: ${this.defaultMechanics}");

  //                     // _showMoreOptions(context);
  //                   },
  //                 )
  //               ],
  //             ));
  //       });
  //     },
  //   );
  // }

  // void _showGameThemes(
  //     BuildContext themesContext, List<String> selectedThemes) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.black54,
  //     transitionAnimationController: themesController,
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     context: themesContext,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             child: Column(
  //               children: [
  //                 Text("Themes",
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 16),
  //                 Expanded(
  //                   child: ListView(
  //                       children: Utils.bgThemesList.map((bgTheme) {
  //                     final isSelected = selectedThemes.contains(bgTheme);

  //                     final selectedColor = Theme.of(context).primaryColor;
  //                     final style = isSelected
  //                         ? TextStyle(
  //                             fontSize: 18,
  //                             color: selectedColor,
  //                             fontWeight: FontWeight.bold,
  //                           )
  //                         : TextStyle(fontSize: 18);

  //                     return ListTile(
  //                       onTap: () {
  //                         final isSelected = selectedThemes.contains(bgTheme);

  //                         setState(() => isSelected
  //                             ? selectedThemes.remove(bgTheme)
  //                             : selectedThemes.add(bgTheme));

  //                         print("selectedThemes, ${selectedThemes.length}");
  //                       },
  //                       title: Text(
  //                         bgTheme,
  //                         style: style,
  //                       ),
  //                       trailing: isSelected
  //                           ? Icon(Icons.check, color: selectedColor, size: 26)
  //                           : null,
  //                     );
  //                   }).toList()),
  //                 ),
  //                 ElevatedButton(
  //                   child: const Text("Apply",
  //                       style: TextStyle(color: Colors.white)),
  //                   onPressed: () async {
  //                     Navigator.of(context).pop();

  //                     setState(() {
  //                       this.defaultThemes = selectedThemes;
  //                     });

  //                     print("VMK defaultThemes: ${this.defaultThemes}");

  //                     // _showMoreOptions(context);
  //                   },
  //                 )
  //               ],
  //             ));
  //       });
  //     },
  //   );
  // }

  // void _showLanguages(
  //     BuildContext languagesContext, List<String> selectedLanguages) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.black54,
  //     transitionAnimationController: languagesController,
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     context: languagesContext,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             child: Column(
  //               children: [
  //                 Text("Languages",
  //                     textAlign: TextAlign.center,
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 16),
  //                 Expanded(
  //                   child: ListView(
  //                       children: Utils.languages.map((language) {
  //                     final isSelected = selectedLanguages.contains(language);

  //                     final selectedColor = Theme.of(context).primaryColor;
  //                     final style = isSelected
  //                         ? TextStyle(
  //                             fontSize: 18,
  //                             color: selectedColor,
  //                             fontWeight: FontWeight.bold,
  //                           )
  //                         : TextStyle(fontSize: 18);

  //                     return ListTile(
  //                       onTap: () {
  //                         final isSelected =
  //                             selectedLanguages.contains(language);

  //                         setState(() => isSelected
  //                             ? selectedLanguages.remove(language)
  //                             : selectedLanguages.add(language));

  //                         print(
  //                             "selectedLanguages, ${selectedLanguages.length}");
  //                       },
  //                       title: Text(
  //                         language.capitalize(),
  //                         style: style,
  //                       ),
  //                       trailing: isSelected
  //                           ? Icon(Icons.check, color: selectedColor, size: 26)
  //                           : null,
  //                     );
  //                   }).toList()),
  //                 ),
  //                 ElevatedButton(
  //                   child: const Text("Apply",
  //                       style: TextStyle(color: Colors.white)),
  //                   onPressed: () async {
  //                     Navigator.of(context).pop();

  //                     setState(() {
  //                       this.defaultLanguages = selectedLanguages;
  //                     });

  //                     print("VMK defaultLanguages: ${this.defaultLanguages}");

  //                     _showMoreOptions(context);
  //                   },
  //                 )
  //               ],
  //             ));
  //       });
  //     },
  //   );
  // }

  // void _showMoreOptions(BuildContext moreOptionsContext) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.black54,
  //     transitionAnimationController: moreOptionsController,
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     context: moreOptionsContext,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (BuildContext context, setState) {
  //         return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
  //             child: Column(
  //               children: [
  //                 Align(
  //                   alignment: Alignment.topRight,
  //                   child: ElevatedButton(

  //                       // CLEAR FILTERS
  //                       onPressed: this.defaultMechanics.isNotEmpty ||
  //                               this.defaultThemes.isNotEmpty ||
  //                               this.defaultLanguages.isNotEmpty ||
  //                               this.defaultLocality.isNotEmpty
  //                           ? () => setState((() {
  //                                 this.defaultMechanics = [];
  //                                 this.defaultThemes = [];
  //                                 this.defaultLanguages = [];
  //                                 this.defaultLocality = [];
  //                               }))
  //                           : null,
  //                       child: Text("Clear all")),
  //                 ),
  //                 Expanded(
  //                   child: ListView(
  //                     children: [
  //                       ListTile(
  //                         leading: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               "Mechanics",
  //                               textAlign: TextAlign.start,
  //                               style: TextStyle(
  //                                 fontSize: 24,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             Text(
  //                                 defaultMechanics.isNotEmpty
  //                                     ? "You're seeing: ${defaultMechanics.map((mechanic) => "$mechanic")}"
  //                                     : "What game mechanics do they like?",
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                 )),
  //                           ],
  //                         ),
  //                         trailing: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             SizedBox(width: 12),
  //                             const Icon(CustomIcons.right_open)
  //                           ],
  //                         ),
  //                         onTap: () {
  //                           Navigator.of(context).pop();

  //                           _showGameMechanics(context, this.defaultMechanics);
  //                         },
  //                       ),
  //                       ListTile(
  //                         leading: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               "Themes",
  //                               textAlign: TextAlign.start,
  //                               style: TextStyle(
  //                                 fontSize: 24,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             Text(
  //                                 defaultThemes.isNotEmpty
  //                                     ? "You're seeing: ${defaultThemes.map((mechanic) => "$mechanic")}"
  //                                     : "What game themes do they like?",
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                 )),
  //                           ],
  //                         ),
  //                         trailing: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             SizedBox(width: 12),
  //                             const Icon(CustomIcons.right_open)
  //                           ],
  //                         ),
  //                         onTap: () {
  //                           Navigator.of(context).pop();

  //                           _showGameThemes(context, this.defaultThemes);
  //                         },
  //                       ),
  //                       ListTile(
  //                         leading: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               "Languages",
  //                               textAlign: TextAlign.start,
  //                               style: TextStyle(
  //                                 fontSize: 24,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             Text(
  //                                 defaultLanguages.isNotEmpty
  //                                     ? "You're seeing: ${defaultLanguages.map((language) => "${language.capitalize()}")}"
  //                                     : "Will you understand each other?",
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                 )),
  //                           ],
  //                         ),
  //                         trailing: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             SizedBox(width: 12),
  //                             const Icon(CustomIcons.right_open)
  //                           ],
  //                         ),
  //                         onTap: () {
  //                           Navigator.of(context).pop();

  //                           _showLanguages(context, this.defaultLanguages);
  //                         },
  //                       ),
  //                       ListTile(
  //                         leading: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               "Locality",
  //                               textAlign: TextAlign.start,
  //                               style: TextStyle(
  //                                 fontSize: 24,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             Text(
  //                                 defaultLocality.isNotEmpty
  //                                     ? "You're seeing: ${defaultLocality[0].capitalize()}"
  //                                     : "Where are they based?",
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                 )),
  //                           ],
  //                         ),
  //                         trailing: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             SizedBox(width: 12),
  //                             const Icon(CustomIcons.right_open)
  //                           ],
  //                         ),
  //                         onTap: () {
  //                           Navigator.of(context).pop();

  //                           // _showLocalityModal(context, this.defaultLocality);
  //                         },
  //                       ),
  //                       ElevatedButton(
  //                         child: const Text("Apply",
  //                             style: TextStyle(color: Colors.white)),
  //                         onPressed: () async {
  //                           // this.setState(() {
  //                           //   userQuery = updateUserQuery;
  //                           // });

  //                           Navigator.of(context).pop();

  //                           // _filterSwipableUsersModalBottomSheet(
  //                           //     context, filterMenuController);
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ));
  //       });
  //     },
  //   );
  // }




  /**
   * 
   * FILTER SWIPABLE MODAL 
   */

        // return StatefulBuilder(builder: (BuildContext context, setState) {
          //   /* 1. Gender Select */
          //   // List<String> availableGenders = [
          //   //   "everyone",
          //   //   "men",
          //   //   "women",
          //   //   "other"
          //   // ];

          //   // List<String> selectedGender = defaultSelectedGender;
          //   // /** 1. END Gender Select END */

          //   // /* 2. Select Age Range */
          //   // int selectedMinAge = defaultMinAgeValue;
          //   // int selectedMaxAge = defaultMaxAgeValue;
          //   // /* 2. END Select Age Range */

          //   return Padding(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          //       child: Column(
          //         children: [
          //           Expanded(
          //             child: ListView(
          //               children: [
          //                 ListTile(
          //                   leading: Text("Show me",
          //                       style: TextStyle(
          //                           fontSize: 24, fontWeight: FontWeight.bold)),
          //                   trailing: Row(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Text("selectedGender[0].capitalize()",
          //                           style: TextStyle(fontSize: 20)),
          //                       SizedBox(width: 12),
          //                       const Icon(CustomIcons.right_open)
          //                     ],
          //                   ),
          //                   onTap: () {
          //                     Navigator.of(context).pop();

          //                     // _showGendersModal(
          //                     //     context, availableGenders, selectedGender);
          //                   },
          //                 ),
          //                 ListTile(
          //                   leading: Text("Age range",
          //                       style: TextStyle(
          //                           fontSize: 24, fontWeight: FontWeight.bold)),
          //                   trailing: Row(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Text("fasfa",
          //                           // Text(""$selectedMinAge - $selectedMaxAge"",
          //                           style: TextStyle(fontSize: 20)),
          //                       SizedBox(width: 12),
          //                       const Icon(CustomIcons.right_open)
          //                     ],
          //                   ),
          //                   onTap: () {
          //                     Navigator.of(context).pop();

          //                     // _showAgeModal(
          //                     //     context, selectedMinAge, selectedMaxAge);
          //                   },
          //                 ),
          //                 ListTile(
          //                   leading: Text("More options",
          //                       style: TextStyle(
          //                           fontSize: 24, fontWeight: FontWeight.bold)),
          //                   trailing: Row(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       SizedBox(width: 12),
          //                       const Icon(CustomIcons.right_open)
          //                     ],
          //                   ),
          //                   onTap: () {
          //                     Navigator.of(context).pop();
          //                     // _showMoreOptions(context);
          //                   },
          //                 ),
          //                 ElevatedButton(
          //                   child: const Text("Apply filters",
          //                       style: TextStyle(color: Colors.white)),
          //                   onPressed: () async {
          //                     // List<UserQuery> updateUserQuery = [
          //                     //   UserQuery("gender", "isEqualToGender",
          //                     //       selectedGender[0]),
          //                     //   UserQuery("currentLocation",
          //                     //       "isEqualToCurrentLocation", defaultLocality)
          //                     // ];

          //                     // this.setState(() {
          //                     //   userQuery = updateUserQuery;
          //                     // });

          //                     Navigator.of(context).pop();
          //                   },
          //                 )
          //               ],
          //             ),
          //           )
          //         ],
          //       ));
          // });
      
      