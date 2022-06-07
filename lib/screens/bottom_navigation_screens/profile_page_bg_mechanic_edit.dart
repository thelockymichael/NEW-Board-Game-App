import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/model/user_profile_edit.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/ui/widgets/bg_mechanic_list_tile_widget.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfilePageBgMechanicEdit extends StatefulWidget {
  final Function() notifyParent;
  List<FavBgMechanicItem> bgMechanics;
  final AppUser? userSnapshot;

  ProfilePageBgMechanicEdit(
      {required this.userSnapshot,
      required this.bgMechanics,
      required this.notifyParent});

  @override
  _ProfilePageBgMechanicEdit createState() => _ProfilePageBgMechanicEdit();
}

class _ProfilePageBgMechanicEdit extends State<ProfilePageBgMechanicEdit> {
  late List<FavBgMechanicItem> _allBgMechanics;

  late UserProvider _userProvider;
  late AppUser _userSnapshot;

  List<FavBgMechanicItem> selectedBgMechanics = [];

  @override
  initState() {
    // at the beginning, all bg mechanics are shown
    _userSnapshot = widget.userSnapshot!;
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    // selectedBgMechanics = widget.bgMechanics;

    _allBgMechanics = [
      FavBgMechanicItem(name: "Co-op"),
      FavBgMechanicItem(name: "Team"),
      FavBgMechanicItem(name: "Social Deduction"),
      FavBgMechanicItem(name: "Euro"),
      FavBgMechanicItem(name: "Card"),
      FavBgMechanicItem(name: "Resource Management"),
      FavBgMechanicItem(name: "Bidding"),
      FavBgMechanicItem(name: "Worker Placement")
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final allCountries = getPrioritizedCountries(_allBgMechanics);
    // final countries = allCountries.where(containsSearchText).toList();

    // TODO: implement build
    return GestureDetector(
        onTap: () {
          _bgInterestsEditModalBottomSheet(context, _userSnapshot);
        },
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            color: Colors.white,
            width: double.infinity,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Interests",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold))),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("jotain",
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    )
                  ],
                ),
              ),
            ])));
  }

  void _bgInterestsEditModalBottomSheet(context, AppUser userSnapshot) {
    // final _nameTextController = TextEditingController(text: userSnapshot.name);
    // final _bggNameTextController =
    //     TextEditingController(text: userSnapshot.bggName);
    // final _birthdayTextController =
    //     TextEditingController(text: userSnapshot.age);
    // final _genderTextController =
    //     TextEditingController(text: userSnapshot.gender);
    // final _currentLocationTextController =
    //     TextEditingController(text: userSnapshot.currentLocation);

    // final _focusName = FocusNode();
    // final _focusBggName = FocusNode();
    // final _focusBirthday = FocusNode();
    // final _focusGender = FocusNode();
    // final _focusCurrentLocation = FocusNode();

    // final provider =
    //     Provider.of<BgGameMechanicProvider>(context, listen: false);

    // print("before ${_bgMechanicProvider.bgMechanics.length}");
    // final allBgMechanics =
    //     getPrioritizedBgMechanics(_bgMechanicProvider.bgMechanics);
    // final bgMechanics = allBgMechanics.where(containsSearchText).toList();

    // print("bgMechanics ${bgMechanics.length}");

    // for (var i = 0; i < userSnapshot.favBgMechanics.length; i++) {
    //   final favBgMechanic = userSnapshot.favBgMechanics[i];

    //   selectedBgMechanics.add(BgMechanic(name: favBgMechanic));
    // }
    // selectedBgMechanics = userSnapshot.favBgMechanics.cast<BgMechanic>();

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: const Radius.circular(18.0),
                  ),
                ),
                child: DefaultTabController(
                    length: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TabBar(tabs: [
                            Tab(
                              child: Text(
                                "Game Mechanics",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                                child: Text(
                              "Themes",
                              style: TextStyle(color: Colors.black),
                            )),
                          ]),
                          Expanded(
                              child: TabBarView(children: <Widget>[
                            Column(
                              children: [
                                Text("Here are your favorite game mechanics",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 24)),
                                SizedBox(height: 26),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _allBgMechanics.length,
                                      itemBuilder: (BuildContext context,
                                          int itemIndex) {
                                        final isSelected =
                                            selectedBgMechanics.contains(
                                                _allBgMechanics[itemIndex]);
                                        return BgMechanicListTileWidget(
                                            bgMechanic:
                                                _allBgMechanics[itemIndex],
                                            isSelected: isSelected,
                                            onSelectedBgMechanic:
                                                selectBgMechanic);
                                      }),
                                  // child: ListView(
                                  //   children: _allBgMechanics.map((bgMechanic) {
                                  //     final isSelected =
                                  //         _allBgMechanics.contains(bgMechanic);

                                  //     return BgMechanicListTileWidget(
                                  //       bgMechanic: bgMechanic,
                                  //       isSelected: isSelected,
                                  //       onSelectedBgMechanic: selectBgMechanic,
                                  //     );
                                  //   }).toList(),
                                  // ),

                                  // child: Align(
                                  //   alignment: Alignment.center,
                                  //   child: TextField(
                                  //     maxLength: 30,
                                  //     enableInteractiveSelection: false,
                                  //     keyboardType: TextInputType.number,
                                  //     style: TextStyle(height: 1.6),
                                  //     cursorColor: Colors.green[800],
                                  //     textAlign: TextAlign.center,
                                  //     autofocus: false,
                                  //     decoration: InputDecoration(
                                  //         border: InputBorder.none,
                                  //         hintText: "Internet",
                                  //         counterText: ""),
                                  //   ),
                                  // ),
                                ),
                                buildSelectButton(context, userSnapshot)
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  "Here are your favorite themes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(height: 26),
                                Container(
                                  height: 73,
                                  width: MediaQuery.of(context).size.width - 24,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: kAccentColor,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.redAccent,
                                      )),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      maxLength: 30,
                                      enableInteractiveSelection: false,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(height: 1.6),
                                      cursorColor: Colors.green[800],
                                      textAlign: TextAlign.center,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Credit",
                                          counterText: ""),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ])),
                        ],
                      ),
                    )),
              ),
            ),
          );
        });
  }

  List<FavBgMechanicItem> getPrioritizedBgMechanics(
      List<FavBgMechanicItem> bgMechanics) {
    final notSelectedBgMechanics = List.of(bgMechanics)
      ..removeWhere((BgMechanic) => selectedBgMechanics.contains(BgMechanic));

    return [
      ...List.of(selectedBgMechanics)..sort(Utils.ascendingSort),
      ...notSelectedBgMechanics,
    ];
  }

  void selectBgMechanic(FavBgMechanicItem bgMechanic) {
    print("Is multiselection");

    // setState(() {
    //   _allBgMechanics = [];
    // });

    // setState(() {
    //   selectedBgMechanics = [];
    // });

    final isSelected = _allBgMechanics.contains(bgMechanic);
    setState(() => isSelected
        ? _allBgMechanics.remove(bgMechanic)
        : _allBgMechanics.add(bgMechanic));

    setState(() {
      widget.notifyParent();
    });
    print("_allBgMechanics, ${_allBgMechanics.length}");
  }

  Widget buildSelectButton(BuildContext context, AppUser userSnapshot) {
    final label = "Select Countries";
    // 'Select ${selectedBgMechanics.length} Countries'
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      color: Theme.of(context).primaryColor,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            minimumSize: Size.fromHeight(40),
            primary: Colors.white,
          ),
          child: Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          onPressed: () {
            _userProvider.updateFavouriteBgMechanics(
                userSnapshot, _allBgMechanics, _scaffoldKey);

            // widget.notifyParent();
          }),
    );
  }
}
