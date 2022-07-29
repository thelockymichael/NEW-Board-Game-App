import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
  final Function callback;

  final BuildContext themeContext;

  final List<String> defaultSelectedGender;

  final List<int> defaultMinAgeValue;
  final List<int> defaultMaxAgeValue;

  final List<String> defaultDistance;

  final List<String> defaultMechanics;

  final List<String> defaultThemes;

  final List<String> defaultLanguages;

  final List<String> defaultLocality;

  SortUsers(
      {Key? key,
      required this.callback,
      required this.themeContext,
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
    selectedGender = [];

    widget.defaultSelectedGender.forEach((gender) {
      selectedGender.add(gender);
    });

    selectedMinAge = [];
    selectedMaxAge = [];

    widget.defaultMinAgeValue.forEach((age) {
      selectedMinAge.add(age);
    });

    widget.defaultMaxAgeValue.forEach((age) {
      selectedMaxAge.add(age);
    });

    selectedDistance = [];
    widget.defaultDistance.forEach((distance) {
      selectedDistance.add(distance);
    });

    selectedMechanics = [];
    widget.defaultMechanics.forEach((element) {
      selectedMechanics.add(element);
    });

    selectedThemes = [];
    widget.defaultThemes.forEach((theme) {
      selectedThemes.add(theme);
    });
    print("LOG plk selectedThemes initState ${selectedThemes}");

    selectedLanguages = [];
    widget.defaultLanguages.forEach((language) {
      selectedLanguages.add(language);
    });
    print("LOG plk selectedLanguages initState ${selectedThemes}");

    selectedLocalities = [];
    widget.defaultLocality.forEach((locality) {
      selectedLocalities.add(locality);
    });
    print("LOG plk defaultLocality initState ${selectedLocalities}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      page1(),
      _showGendersPage(),
      _showAgePage(),
      _showDistancePage(),
      _showMoreOptions(setState),
      _showGameMechanics(),
      _showGameThemes(),
      _showLanguages(),
      _showLocalities(),
    ];

    return pages[_currentView];
  }

  @override
  void deactivate() {
    print("LOG plk deactivate");

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
                  width: 120,
                  child: Text("Show me",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedGender[0].capitalize(),
                      style: TextStyle(fontSize: 16)),
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
                      style: TextStyle(fontSize: 16)),
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
                      "${selectedDistance[0].contains("Whole country") ? "Whole country" : "${selectedDistance[0]} km"}",
                      style: TextStyle(fontSize: 16)),
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
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Apply filters",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  onPressed: () async {
                    Navigator.of(context).pop();

                    widget.callback(
                      selectedGender,
                      selectedMinAge,
                      selectedMaxAge,
                      selectedDistance,
                      // More Options
                      selectedMechanics,
                      selectedThemes,
                      selectedLanguages,
                      selectedLocalities,
                    );
                  },
                ))
          ],
        ));
  }

  Widget _showGendersPage() {
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

                          setState(() {
                            // isSelected
                            //     ? widget.defaultSelectedGender.remove(gender)
                            //     : widget.defaultSelectedGender.add(gender);

                            isSelected
                                ? selectedGender.remove(gender)
                                : selectedGender.add(gender);

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

  Widget _showAgePage() {
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
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

  Widget _showDistancePage() {
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
            Text("How far are you willing to go?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: CupertinoPicker(
                itemExtent: 30,
                backgroundColor: Colors.white,
                scrollController: FixedExtentScrollController(
                    initialItem: selectedDistance[0].contains("Whole country")
                        ? 158
                        : int.parse(selectedDistance[0]) + 3),
                children: Utils.userDistance.map((item) {
                  return Text(item);
                }).toList(),
                onSelectedItemChanged: (value) {
                  var valueToSet = value;

                  if (valueToSet == 158) {
                    setState(() {
                      selectedDistance[0] = "Whole country";
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
              onPressed: () async {
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
                      onPressed: selectedMechanics.isNotEmpty ||
                              selectedThemes.isNotEmpty ||
                              selectedLanguages.isNotEmpty ||
                              selectedLocalities.isNotEmpty
                          ? () => setModalState((() {
                                selectedMechanics.clear();
                                selectedThemes.clear();
                                selectedLanguages.clear();
                                selectedLocalities.clear();
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
                            overflow: TextOverflow.ellipsis,
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
                            overflow: TextOverflow.ellipsis,
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
                            overflow: TextOverflow.ellipsis,
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
                            overflow: TextOverflow.ellipsis,
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

  Widget _showGameMechanics() {
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

                        setState(() => isSelected
                            ? selectedMechanics.remove(bgMechanic)
                            : selectedMechanics.add(bgMechanic));

                        print(
                            "LOG plk ListTile selectedMechanics ${selectedMechanics}");
                      },
                      title: Text(
                        bgMechanic.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_box_rounded,
                              color: selectedColor, size: 26)
                          : Icon(Icons.check_box_outline_blank_rounded,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Apply",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      _currentView = 4;
                    });
                  },
                ))
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 4;
          });

          return false;
        });
  }

  Widget _showGameThemes() {
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

                        setState(() => isSelected
                            ? selectedThemes.remove(theme)
                            : selectedThemes.add(theme));
                      },
                      title: Text(
                        theme.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_box_rounded,
                              color: selectedColor, size: 26)
                          : Icon(Icons.check_box_outline_blank_rounded,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Apply",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      _currentView = 4;
                    });
                  },
                ))
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 4;
          });

          return false;
        });
  }

  Widget _showLanguages() {
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

                        setState(() => isSelected
                            ? selectedLanguages.remove(language)
                            : selectedLanguages.add(language));
                      },
                      title: Text(
                        language.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_box_rounded,
                              color: selectedColor, size: 26)
                          : Icon(Icons.check_box_outline_blank,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Apply",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      _currentView = 4;
                    });
                  },
                ))
          ]),
        ),
        onWillPop: () async {
          setState(() {
            _currentView = 4;
          });

          return false;
        });
  }

  Widget _showLocalities() {
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

                        setState(() => isSelected
                            ? selectedLocalities.remove(locality)
                            : selectedLocalities.add(locality));
                      },
                      title: Text(
                        locality.capitalize(),
                        style: style,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_box_rounded,
                              color: selectedColor, size: 26)
                          : Icon(Icons.check_box_outline_blank,
                              color: selectedColor, size: 26),
                    );
                  }).toList()),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Apply",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      _currentView = 4;
                    });
                  },
                ))
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

  List<String> defaultSelectedGender = ["everyone"];

  List<int> defaultMinAgeValue = [1];
  List<int> defaultMaxAgeValue = [66];

  List<String> defaultDistance = ["Whole country"];

  List<String> defaultMechanics = [];

  List<String> defaultThemes = [];

  List<String> defaultLanguages = [];

  List<String> defaultLocality = [];

  late CardProvider cardProvider;

  AppUser _myUser = Utils.user;
  int defaultCurrentView = 0;

  late List<Widget> pages;

  bool usingFilterCriteria = false;

  @override
  void initState() {
    super.initState();
    // Utils.createFiftyUsers();

    _ignoreSwipeIds = <String>[];

    cardProvider = Provider.of<CardProvider>(context, listen: false);
  }

  Future<List<ResultAppUser>?> loadUsers() async {
    String? id = await SharedPreferencesUtil.getUserId();

    if (id != null) {
      _myUser = AppUser.fromSnapshot(await _databaseSource.getUser(id));
    }

    _ignoreSwipeIds = <String>[];

    var swipes = await _databaseSource.getSwipes(_myUser.id);
    for (var i = 0; i < swipes.size; i++) {
      Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
      _ignoreSwipeIds.add(swipe.id);
    }
    _ignoreSwipeIds.add(_myUser.id);

    print("LOG plk Load USERS ${defaultSelectedGender}");

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
      print("LOG hjk NO ${res.length}");

      cardProvider.setUsers(res.reversed.toList());

      // print("LOG fru cardProvider userList ${res.reversed.toList()[0].name}");
      // print(
      // "LOG fru _userList.reversed.toList ${_userList.reversed.toList()[0].name}");

      // return _userList.reversed.toList();

      return res.reversed.toList();
    }

    print("LOG hjk YES");

    return null;
  }

  void callback([
    List<String>? selectedGender,
    List<int>? selectedMinAge,
    List<int>? selectedMaxAge,
    List<String>? selectedDistance,
    List<String>? selectedMechanics,
    List<String>? selectedThemes,
    List<String>? selectedLanguages,
    List<String>? selectedLocality,
  ]) {
    setState(() {
      defaultSelectedGender = selectedGender!;
      defaultMinAgeValue = selectedMinAge!;
      defaultMaxAgeValue = selectedMaxAge!;
      defaultDistance = selectedDistance!;

      // More Options
      defaultMechanics = selectedMechanics!;
      defaultThemes = selectedThemes!;
      defaultLanguages = selectedLanguages!;
      defaultLocality = selectedLocality!;

      usingFilterCriteria = true;

      // _userList.clear();
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
          return SortUsers(
            callback: callback,
            themeContext: context,
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomModalProgressHUD(
                    inAsyncCall: true, child: Container());
              } else if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData &&
                  usingFilterCriteria) {
                return Center(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "No results match your search criteria",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  child: const Text("Search for all users?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    setState(() {
                                      // Filter Criteria OFF
                                      usingFilterCriteria = false;

                                      defaultSelectedGender = ["everyone"];
                                      defaultMinAgeValue = [1];
                                      defaultMaxAgeValue = [99];
                                      defaultDistance = ["Whole country"];

                                      // More Options
                                      defaultMechanics = [];
                                      defaultThemes = [];
                                      defaultLanguages = [];
                                      defaultLocality = [];
                                    });
                                  },
                                ))
                          ],
                        )));
              } else if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData &&
                  !usingFilterCriteria) {
                return Center(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "No users were found.",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Come back later.",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            )
                          ],
                        )));
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
