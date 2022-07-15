// ignore_for_file: prefer_function_declarations_over_variables
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

class Page1 extends StatefulWidget {
  final VoidCallback callback;

  final BuildContext themeContext;
  final StateSetter setModalState;

  // 1. Gender

  final List<String> defaultSelectedGender;

  // 2. Min Age Value
  // 2. Max Age Value
  final List<int> defaultMinAgeValue;
  final List<int> defaultMaxAgeValue;
  // END

  // 3. Default Selected Bg Mechanics
  final List<String> defaultDistance;
  // END

  // 4. Default Selected Bg Mechanics
  final List<String> defaultMechanics;
  // END

  // 5. Default Selected Bg Themes
  final List<String> defaultThemes;
  // END

  // 6. Default Selected Languages
  final List<String> defaultLanguages;
  // END

  // 7. Default Selected Locality
  final List<String> defaultLocality;
  // END

  const Page1(
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
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
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
    // 1. Set initial gender
    selectedGender = widget.defaultSelectedGender;

    // 2. Set initial ages
    selectedMinAge = widget.defaultMinAgeValue;
    selectedMaxAge = widget.defaultMaxAgeValue;

    // 2. Set initial ages
    selectedDistance = widget.defaultDistance;

    // 3. Set initial mechanics
    selectedMechanics = widget.defaultMechanics;

    // 4. Set initial themes
    selectedThemes = widget.defaultThemes;

    // 5. Set inital languages
    selectedLanguages = widget.defaultLanguages;

    // 6. Set initial locality
    selectedLocalities = widget.defaultLocality;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      pages = [
        page1(),
        _showGendersPage(setState), // 1. Gender
        _showAgePage(setState), // 2. Age
        _showDistancePage(setState), // 3. Show distance
        _showMoreOptions(setState), // 4. Show more options
        _showGameMechanics(setState), // 5. Show game mechanics
        _showGameThemes(setState), // 6. Show game themes
        _showLanguages(setState), // 7. Show more options
        _showLocalities(setState), // 8. Show more options
      ];

      return pages[_currentView];
    });
  }

  @override
  void deactivate() {
    debugPrint('>>> bottom sheet closing');
    widget
        .callback(); // This will be trigger when the bottom sheet finishes closing
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
                  print("LOG page1 _currentView ${_currentView}");
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
                  print("LOG n _currentView ${_currentView}");
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
                  print("LOG page1 _currentView ${_currentView}");
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
                  print("LOG page1 _currentView ${_currentView}");
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), // NEW
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
                minimumSize: const Size.fromHeight(40), // NEW
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // Navigator.of(context).pop();

                setModalState(() {
                  widget.defaultMinAgeValue[0] = selectedMinAge[0];
                  widget.defaultMaxAgeValue[0] = selectedMaxAge[0];

                  _currentView = 0;
                  print("LOG n $selectedMinAge");
                  print("LOG n $selectedMaxAge");
                  print(
                      "LOG n defaultMinAgeValue ${widget.defaultMinAgeValue}");
                  print(
                      "LOG n defaultMaxAgeValue ${widget.defaultMaxAgeValue}");
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
                  print("LOG n $value");

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
                minimumSize: const Size.fromHeight(40), // NEW
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setModalState(() {
                  widget.defaultDistance[0] = selectedDistance[0];

                  print("LOG n $selectedDistance");
                  print(
                      "LOG n defaultMaxAgeValue ${widget.defaultDistance[0]}");
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
                      // CLEAR FILTERS
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
                    // TODO Show mechanics

                    setState(() {
                      _currentView = 5;
                      print("LOG page1 _currentView ${_currentView}");
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
                      print("LOG page1 _currentView ${_currentView}");
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
                      print("LOG page1 _currentView ${_currentView}");
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
                      print("LOG page1 _currentView ${_currentView}");
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
                minimumSize: const Size.fromHeight(40), // NEW
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
                minimumSize: const Size.fromHeight(40), // NEW
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
                minimumSize: const Size.fromHeight(40), // NEW
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
                minimumSize: const Size.fromHeight(40), // NEW
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

  // 1. Default Selected Gender
  List<String> defaultSelectedGender = ["everyone"];
  // END

  // 2. Min Age Value
  List<int> defaultMinAgeValue = [1];
  List<int> defaultMaxAgeValue = [66];
  // END

  // 3. Default Distance
  List<String> defaultDistance = ["whole country"];
  // END

  // 4. Default Selected Bg Mechanics
  List<String> defaultMechanics = [];
  // END

  // 5. Default Selected Bg Themes
  List<String> defaultThemes = [];
  // END

  // 6. Default Selected Languages
  List<String> defaultLanguages = [];
  // END

  // 7. Default Selected Locality
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
      gender: defaultSelectedGender[0],
      minAge: defaultMinAgeValue[0],
      maxAge: defaultMaxAgeValue[0],
      distance: defaultDistance[0],
      // More Options
      mechanics: defaultMechanics,
      themes: defaultThemes,
      languages: defaultLanguages,
      localities: defaultLocality,
      ignoreSwipeIds: [],

      // ignoreSwipeIds: _ignoreSwipeIds,
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
    setState(() {
      print("LOG query defaultSelectedGender $defaultSelectedGender");
      print("LOG query defaultMinAgeValue $defaultMinAgeValue");
      print("LOG query defaultMaxAgeValue $defaultMaxAgeValue");
      print("LOG query defaultDistance $defaultDistance");
      print("LOG query defaultMechanics $defaultMechanics");
      print("LOG query defaultThemes $defaultThemes");
      print("LOG query defaultLanguages $defaultLanguages");
      print("LOG query defaultLocality $defaultLocality");
    });

    debugPrint('>>> my callback triggered');
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
            return Page1(
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
