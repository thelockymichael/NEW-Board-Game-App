import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'container_transition.dart';
// import 'fade_scale_transition.dart';
// import 'fade_through_transition.dart';
// import 'shared_axis_transition.dart';

class SortUsers extends StatefulWidget {
  final VoidCallback callback;

  final BuildContext themeContext;
  final StateSetter setModalState;

  final List<String> defaultSelectedGender;

  final List<int> defaultMinAgeValue;
  final List<int> defaultMaxAgeValue;

  final List<String> defaultDistance;

  final List<String> defaultMechanics;

  final List<String> defaultThemes;

  final List<String> defaultLanguages;

  final List<String> defaultLocality;

  const SortUsers(
      {Key? key,
      required this.callback,
      required this.themeContext,
      required this.setModalState,
      required this.defaultSelectedGender,
      required this.defaultMinAgeValue,
      required this.defaultMaxAgeValue,
      required this.defaultDistance,
      required this.defaultMechanics,
      required this.defaultThemes,
      required this.defaultLanguages,
      required this.defaultLocality})
      : super(key: key);

  @override
  _SortUsersState createState() => _SortUsersState();
}

class _SortUsersState extends State<SortUsers> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int _currentView = 0;

  /* 1. Gender Select */

  List<String> availableGenders = ["everyone", "men", "women", "other"];

  late List<String> selectedGender;

  /** 1. END Gender Select END */

  /* 2. Select Age Range */
  late List<int> selectedMinAge;
  late List<int> selectedMaxAge;
  /* 2. END Select Age Range */

  /* 3. Select Age Range */
  late List<String> selectedDistance;
  /* 3. END Select Age Range */

  /* 4. Mechanics Select */
  late List<String> selectedMechanics;
  /* 4. END Select Mechanics Select */

  /* 55. Themes Select */
  late List<String> selectedThemes;
  /* 55. END Select Themes Select */

  /* 6. Languages Select */
  late List<String> selectedLanguages;
  /* 6. END Select Languages Select */

  /* 7. Localities Select */
  late List<String> selectedLocalities;
  /* 7. END Select Localities Select */

  late List<Widget> pages;

  @override
  void initState() {
    selectedGender = widget.defaultSelectedGender;

    selectedMinAge = widget.defaultMinAgeValue;
    selectedMaxAge = widget.defaultMaxAgeValue;

    selectedDistance = widget.defaultDistance;

    selectedMechanics = widget.defaultMechanics;

    selectedThemes = widget.defaultThemes;

    selectedLanguages = widget.defaultLanguages;

    selectedLocalities = widget.defaultLocality;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      pages = [
        page1(),
        _showGendersPage(setState),
        _showAgePage(setState),
        _showDistancePage(setState),
        _showMoreOptions(setState),
        _showGameMechanics(setState),
        _showGameThemes(setState),
        _showLanguages(setState),
        _showLocalities(setState),
      ];

      return pages[_currentView];
    });
  }

  @override
  void deactivate() {
    widget.callback();
    super.deactivate();
  }

  Widget page1() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SizedBox(
                  width: 100,
                  child: Text("Show me",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
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
                setState(() {
                  _currentView = 1;
                });
              },
            ),
            ListTile(
              leading: SizedBox(
                  width: 200,
                  child: Text("Age range",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${selectedMinAge[0]} - ${selectedMaxAge[0]}",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
                  const Icon(CustomIcons.right_open)
                ],
              ),
              onTap: () {
                setState(() {
                  _currentView = 2;
                });
              },
            ),
            ListTile(
              leading: SizedBox(
                  width: 200,
                  child: Text("Distance (km)",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "${selectedDistance[0].contains("whole country") ? "Whole country" : "${selectedDistance[0]} km"}",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
                  const Icon(CustomIcons.right_open)
                ],
              ),
              onTap: () {
                setState(() {
                  _currentView = 3;
                });
              },
            ),
            ListTile(
              leading: SizedBox(
                  width: 200,
                  child: Text("More options",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 12),
                  const Icon(CustomIcons.right_open)
                ],
              ),
              onTap: () {
                setState(() {
                  _currentView = 4;
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply filters",
                  style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  Widget _showGendersPage(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Show me",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
              "Who would you like to see?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(
              height: 16,
            ),
            LimitedBox(
                maxHeight: 300.0,
                child: ListView(
                    shrinkWrap: true,
                    children: availableGenders.map((gender) {
                      final isSelected = selectedGender.contains(gender);

                      final selectedColor =
                          Theme.of(widget.themeContext).primaryColor;

                      final style = isSelected
                          ? TextStyle(
                              fontSize: 18,
                              color: selectedColor,
                              fontWeight: FontWeight.bold,
                            )
                          : TextStyle(fontSize: 18);

                      return ListTile(
                        onTap: () {
                          selectedGender.clear();

                          final isSelected = selectedGender.contains(gender);

                          setModalState(() {
                            isSelected
                                ? widget.defaultSelectedGender.remove(gender)
                                : widget.defaultSelectedGender.add(gender);

                            _currentView = 0;
                          });
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
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 0;
          });

          return false;
        });
  }

  Widget _showAgePage(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Age range",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberPicker(
                  value: selectedMinAge[0],
                  minValue: 0,
                  maxValue: 100,
                  step: 1,
                  haptics: true,
                  onChanged: (value) =>
                      setState(() => selectedMinAge[0] = value),
                ),
                NumberPicker(
                  value: selectedMaxAge[0],
                  minValue: 0,
                  maxValue: 100,
                  step: 1,
                  haptics: true,
                  onChanged: (value) =>
                      setState(() => selectedMaxAge[0] = value),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setModalState(() {
                  widget.defaultMinAgeValue[0] = selectedMinAge[0];
                  widget.defaultMaxAgeValue[0] = selectedMaxAge[0];

                  _currentView = 0;
                });
              },
            )
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 0;
          });

          return false;
        });
  }

  Widget _showDistancePage(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Distance (km)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 16,
            ),
            Text("How far away would you like to search?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: CupertinoPicker(
                itemExtent: 30,
                backgroundColor: Colors.white,
                scrollController: FixedExtentScrollController(
                    initialItem: selectedDistance[0].contains("whole country")
                        ? 158
                        : int.parse(selectedDistance[0]) + 3),
                children: Utils.userDistance.map((item) {
                  return Text(item);
                }).toList(),
                onSelectedItemChanged: (value) {
                  var valueToSet = value;

                  if (valueToSet == 158) {
                    setState(() {
                      selectedDistance[0] = "whole country";
                    });
                  } else {
                    var sum = value + 3;
                    setState(() {
                      selectedDistance[0] = sum.toString();
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setModalState(() {
                  widget.defaultDistance[0] = selectedDistance[0];
                });

                setState(() {
                  _currentView = 0;
                });
              },
            )
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 0;
          });

          return false;
        });
  }

  Widget _showMoreOptions(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: widget.defaultMechanics.isNotEmpty ||
                              widget.defaultThemes.isNotEmpty ||
                              widget.defaultLanguages.isNotEmpty ||
                              widget.defaultLocality.isNotEmpty
                          ? () => setModalState((() {
                                widget.defaultMechanics.clear();
                                widget.defaultThemes.clear();
                                widget.defaultLanguages.clear();
                                widget.defaultLocality.clear();
                              }))
                          : null,
                      child: Text("Clear all"),
                    )),
                ListTile(
                  leading: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mechanics",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            selectedMechanics.isNotEmpty
                                ? "You're seeing: ${selectedMechanics.map((mechanic) => "${mechanic.capitalize()}")}"
                                : "What game mechanics do they like?",
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      )),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 12),
                      const Icon(CustomIcons.right_open)
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _currentView = 5;
                    });
                  },
                ),
                ListTile(
                  leading: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Themes",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            selectedThemes.isNotEmpty
                                ? "You're seeing: ${selectedThemes.map((theme) => "${theme.capitalize()}")}"
                                : "What game themes do they like?",
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      )),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 12),
                      const Icon(CustomIcons.right_open)
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _currentView = 6;
                    });
                  },
                ),
                ListTile(
                  leading: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Languages",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            selectedLanguages.isNotEmpty
                                ? "You're seeing: ${selectedLanguages.map((language) => "${language.capitalize()}")}"
                                : "Will you understand each other?",
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      )),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 12),
                      const Icon(CustomIcons.right_open)
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _currentView = 7;
                    });
                  },
                ),
                ListTile(
                  leading: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Locality",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            selectedLocalities.isNotEmpty
                                ? "You're seeing: ${selectedLocalities.map((locality) => "${locality.capitalize()}")}"
                                : "Where are they based?",
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      )),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 12),
                      const Icon(CustomIcons.right_open)
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _currentView = 8;
                    });
                  },
                )
              ],
            )),
        onWillPop: () async {
          setState(() {
            _currentView = 0;
          });

          return false;
        });
  }

  Widget _showGameMechanics(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Mechanics",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            LimitedBox(
              maxHeight: 300.0,
              child: ListView(
                  shrinkWrap: true,
                  children: Utils.bgMechanicsList.map((bgMechanic) {
                    final isSelected = selectedMechanics.contains(bgMechanic);

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
                        final isSelected =
                            selectedMechanics.contains(bgMechanic);

                        setModalState(() => isSelected
                            ? selectedMechanics.remove(bgMechanic)
                            : selectedMechanics.add(bgMechanic));
                      },
                      title: Text(
                        bgMechanic.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.radio_button_checked,
                              color: selectedColor, size: 26)
                          : Icon(Icons.radio_button_unchecked,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setState(() {
                  _currentView = 4;
                });
              },
            )
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 4;
          });

          return false;
        });
  }

  Widget _showGameThemes(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Themes",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            LimitedBox(
              maxHeight: 300.0,
              child: ListView(
                  shrinkWrap: true,
                  children: Utils.bgThemesList.map((theme) {
                    final isSelected = selectedThemes.contains(theme);

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
                        final isSelected = selectedThemes.contains(theme);

                        setModalState(() => isSelected
                            ? widget.defaultThemes.remove(theme)
                            : widget.defaultThemes.add(theme));
                      },
                      title: Text(
                        theme.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.radio_button_checked,
                              color: selectedColor, size: 26)
                          : Icon(Icons.radio_button_unchecked,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setState(() {
                  _currentView = 4;
                });
              },
            )
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 4;
          });

          return false;
        });
  }

  Widget _showLanguages(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Languages",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            LimitedBox(
              maxHeight: 300.0,
              child: ListView(
                  shrinkWrap: true,
                  children: Utils.languages.map((language) {
                    final isSelected = selectedLanguages.contains(language);

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
                        final isSelected = selectedLanguages.contains(language);

                        setModalState(() => isSelected
                            ? widget.defaultLanguages.remove(language)
                            : widget.defaultLanguages.add(language));
                      },
                      title: Text(
                        language.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.radio_button_checked,
                              color: selectedColor, size: 26)
                          : Icon(Icons.radio_button_unchecked,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setState(() {
                  _currentView = 4;
                });
              },
            )
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 4;
          });

          return false;
        });
  }

  Widget _showLocalities(StateSetter setModalState) {
    return WillPopScope(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Locality",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            LimitedBox(
              maxHeight: 300.0,
              child: ListView(
                  shrinkWrap: true,
                  children: Utils.localities.map((locality) {
                    final isSelected = selectedLocalities.contains(locality);

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
                        final isSelected =
                            selectedLocalities.contains(locality);

                        setModalState(() => isSelected
                            ? widget.defaultLocality.remove(locality)
                            : widget.defaultLocality.add(locality));
                      },
                      title: Text(
                        locality.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.radio_button_checked,
                              color: selectedColor, size: 26)
                          : Icon(Icons.radio_button_unchecked,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setState(() {
                  _currentView = 4;
                });
              },
            )
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 4;
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

  List<String> defaultSelectedGender = ["everyone"];

  List<int> defaultMinAgeValue = [1];
  List<int> defaultMaxAgeValue = [66];

  List<String> defaultDistance = ["whole country"];

  List<String> defaultMechanics = [];

  List<String> defaultThemes = [];

  List<String> defaultLanguages = [];

  List<String> defaultLocality = [];

  late CardProvider cardProvider;

  AppUser _myUser = Utils.user;
  int defaultCurrentView = 0;

  late List<Widget> pages;

  bool _slowAnimations = false;

  @override
  void initState() {
    super.initState();
    // Utils.createFiftyUsers();

    _ignoreSwipeIds = <String>[];
    _userList = <ResultAppUser>[];

    cardProvider = Provider.of<CardProvider>(context, listen: false);
  }

  Future<List<ResultAppUser>?> loadUsers() async {
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

    var res = await GetNearestUsers().getNearestUsers(
      limit: 50,
      myUser: _myUser,
      gender: defaultSelectedGender[0],
      minAge: defaultMinAgeValue[0],
      maxAge: defaultMaxAgeValue[0],
      distance: defaultDistance[0],
      mechanics: defaultMechanics,
      themes: defaultThemes,
      languages: defaultLanguages,
      localities: defaultLocality,
      ignoreSwipeIds: _ignoreSwipeIds,
    );

    if (res.isNotEmpty) {
      cardProvider.setUsers(res.reversed.toList());

      return _userList.reversed.toList();
    }

    return null;
  }

  void callback() {
    setState(() {
      _userList = [];
    });
  }

  void _filterSwipableUsersModalBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: (context),
        enableDrag: true,
        isDismissible: true,
        barrierColor: Colors.black54,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return SortUsers(
              callback: callback,
              themeContext: context,
              setModalState: setModalState,
              defaultSelectedGender: defaultSelectedGender,
              defaultMinAgeValue: defaultMinAgeValue,
              defaultMaxAgeValue: defaultMaxAgeValue,
              defaultDistance: defaultDistance,
              defaultMechanics: defaultMechanics,
              defaultThemes: defaultThemes,
              defaultLanguages: defaultLanguages,
              defaultLocality: defaultLocality,
            );
          });
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
            future: loadUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData) {
                return Center(
                  child: Text('No users found.',
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
