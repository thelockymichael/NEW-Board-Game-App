import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/model/bg_theme.dart';
import 'package:flutter_demo_01/model/user_profile_edit.dart';
import 'package:flutter_demo_01/provider/bg_mechanic_provider.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_bg_genre_edit.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_bio_edit.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_fav_board_games_edit.dart';
import 'package:flutter_demo_01/screens/login_page.dart';
import 'package:flutter_demo_01/screens/settings_page.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "package:flutter_demo_01/utils/utils.dart";

class ProfilePageEdit extends StatefulWidget {
  static const String id = 'profile_page_edit';

  const ProfilePageEdit({Key? key}) : super(key: key);

  @override
  _ProfilePageEditState createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit>
    with SingleTickerProviderStateMixin {
  final UserProfileEdit _userProfileEdit = UserProfileEdit();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _userFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  late UserProvider _userProvider;
  late BgGameMechanicProvider _bgMechanicProvider;

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    super.initState();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _bgMechanicProvider =
        Provider.of<BgGameMechanicProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.grey,
        key: _scaffoldKey,
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser>(
            future: userProvider.user,
            builder: (context, userSnapshot) {
              return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  child: userSnapshot.hasData
                      ? CustomScrollView(
                          slivers: <Widget>[
                            const SliverAppBar(
                              pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                title: Text('Edit'),
                              ),
                            ),
                            SliverList(
                                delegate: SliverChildListDelegate([
                              getProfileImage(userSnapshot.data!, userProvider),
                              const SizedBox(height: 40),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _basicInfoEditModalBottomSheet(
                                          context, userSnapshot.data!);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 12),
                                        color: Colors.white,
                                        width: double.infinity,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                            "${userSnapshot.data?.name.capitalize()}, ${userSnapshot.data?.age}",
                                                            style: const TextStyle(
                                                                fontSize: 32,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                            "${userSnapshot.data?.gender.capitalize()}, ${userSnapshot.data?.currentLocation.capitalize()}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                            )))
                                                  ],
                                                ),
                                              ),
                                            ])),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                ProfilePageBgGenreEdit(
                                                    userSnapshot:
                                                        userSnapshot.data!,
                                                    notifyParent: refresh),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 12),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                  child: Column(
                                                    children: [
                                                      const Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                              "Favourite Game Genres",
                                                              style: TextStyle(
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Wrap(
                                                          children: userSnapshot
                                                              .data!
                                                              .favBoardGameGenres
                                                              .map((gameGenre) {
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 10,
                                                                      top: 10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12.0)),
                                                              ),
                                                              child: Text(
                                                                gameGenre
                                                                    .capitalize(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]))),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(PageRouteBuilder(
                                          pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation,
                                          ) =>
                                              ProfilePageBgBioEdit(
                                                  userSnapshot:
                                                      userSnapshot.data!,
                                                  notifyParent: refresh),
                                          transitionsBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation,
                                            Widget child,
                                          ) =>
                                              SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0, 1),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          ),
                                        ));
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 12),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text("Bio",
                                                              style: TextStyle(
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            userSnapshot
                                                                .data!.bio,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ]))),
                                  GestureDetector(
                                      onTap: () {
                                        _showBgMechanicAndThemeModal(
                                            context, userSnapshot.data!);
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 12),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "Interests",
                                                              style: TextStyle(
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Column(
                                                              children: [
                                                                Wrap(
                                                                  children: userSnapshot
                                                                      .data!
                                                                      .favBgMechanics
                                                                      .map(
                                                                          (gameGenre) {
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .green,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(12.0)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        gameGenre
                                                                            .capitalize(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                                Wrap(
                                                                  children: userSnapshot
                                                                      .data!
                                                                      .favBgThemes
                                                                      .map(
                                                                          (gameGenre) {
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .green,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(12.0)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        gameGenre
                                                                            .capitalize(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                )
                                                              ])),
                                                    ],
                                                  ),
                                                ),
                                              ]))),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(PageRouteBuilder(
                                          pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation,
                                          ) =>
                                              ProfilePageFavBoardGamesEdit(
                                                  userSnapshot:
                                                      userSnapshot.data!,
                                                  notifyParent: refresh),
                                          transitionsBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation,
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
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 12),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              "Favourite Board Games",
                                                              style: TextStyle(
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Column(
                                                              children: [
                                                                Wrap(
                                                                  children: userSnapshot
                                                                      .data!
                                                                      .favBgMechanics
                                                                      .map(
                                                                          (gameGenre) {
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .green,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(12.0)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        gameGenre
                                                                            .capitalize(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                                Wrap(
                                                                  children: userSnapshot
                                                                      .data!
                                                                      .favBgThemes
                                                                      .map(
                                                                          (gameGenre) {
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .green,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(12.0)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        gameGenre
                                                                            .capitalize(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                )
                                                              ])),
                                                    ],
                                                  ),
                                                ),
                                              ]))),
                                ],
                              )
                            ]))
                          ],
                        )
                      : Container());
            },
          );
        }));
  }

  void _showBgMechanicAndThemeModal(context, AppUser userSnapshot) {
/* Board Game Mechanics  */
    List<FavBgMechanicItem> bgMechanicsList = [
      FavBgMechanicItem(name: "Co-op"),
      FavBgMechanicItem(name: "Team"),
      FavBgMechanicItem(name: "Social Deduction"),
      FavBgMechanicItem(name: "Euro"),
      FavBgMechanicItem(name: "Card"),
      FavBgMechanicItem(name: "Resource Management"),
      FavBgMechanicItem(name: "Bidding"),
      FavBgMechanicItem(name: "Worker Placement")
    ];
    List<FavBgMechanicItem> bgMechanicsSelectedList = [];
    for (var i = 0; i < userSnapshot.favBgMechanics.length; i++) {
      bgMechanicsSelectedList
          .add(FavBgMechanicItem(name: userSnapshot.favBgMechanics[i]));
    }

    /* END Board Game Mechanics END */

    /* Board Game Themes  */
    List<FavBgThemeItem> bgThemesList = [
      FavBgThemeItem(name: "Fantasy"),
      FavBgThemeItem(name: "Alien"),
      FavBgThemeItem(name: "Horror"),
      FavBgThemeItem(name: "Adventure"),
      FavBgThemeItem(name: "Wild West"),
      FavBgThemeItem(name: "Winter"),
    ];
    List<FavBgThemeItem> bgThemesSelectedList = [];
    for (var i = 0; i < userSnapshot.favBgThemes.length; i++) {
      bgThemesSelectedList
          .add(FavBgThemeItem(name: userSnapshot.favBgThemes[i]));
    }
    /* END Board Game Themes END */

    showModalBottomSheet(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      context: context,
      builder: (BuildContext context) {
        bool b = false;

        return StatefulBuilder(builder: (BuildContext context, setState) {
          print("BOOL ${b}");

          return DefaultTabController(
            length: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TabBar(tabs: [
                    Tab(
                      child: Text("Game Mechanics",
                          style: TextStyle(color: Colors.black)),
                    ),
                    Tab(
                      child:
                          Text("Themes", style: TextStyle(color: Colors.black)),
                    ),
                  ]),
                  Expanded(
                      child: TabBarView(
                    children: [
                      Column(
                        children: [
                          Text("Here are your favourite mechanics",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24)),
                          SizedBox(height: 26),
                          Expanded(
                            child: ListView(
                                children: bgMechanicsList.map((bgMechanic) {
                              final isSelected =
                                  bgMechanicsSelectedList.contains(bgMechanic);

                              final selectedColor =
                                  Theme.of(context).primaryColor;
                              final style = isSelected
                                  ? TextStyle(
                                      fontSize: 18,
                                      color: selectedColor,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : TextStyle(fontSize: 18);

                              return ListTile(
                                onTap: () {
                                  print("HELLO WORLD");

                                  final isSelected = bgMechanicsSelectedList
                                      .contains(bgMechanic);

                                  setState(() => isSelected
                                      ? bgMechanicsSelectedList
                                          .remove(bgMechanic)
                                      : bgMechanicsSelectedList
                                          .add(bgMechanic));

                                  print(
                                      "bgMechanicsSelectedList, ${bgMechanicsSelectedList.length}");
                                },
                                // leading: FlagWidget(code: BgMechanic),
                                title: Text(
                                  bgMechanic.name,
                                  style: style,
                                ),
                                trailing: isSelected
                                    ? Icon(Icons.check,
                                        color: selectedColor, size: 26)
                                    : null,
                              );
                            }).toList()),
                          ),
                          // selectMechanicsButton(
                          //     context, userSnapshot, bgMechanicsSelectedList)
                        ],
                      ),
                      Column(
                        children: [
                          Text("Here are your favourite themes",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24)),
                          SizedBox(height: 26),
                          Expanded(
                            child: ListView(
                                children: bgThemesList.map((bgTheme) {
                              final isSelected =
                                  bgThemesSelectedList.contains(bgTheme);

                              final selectedColor =
                                  Theme.of(context).primaryColor;
                              final style = isSelected
                                  ? TextStyle(
                                      fontSize: 18,
                                      color: selectedColor,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : TextStyle(fontSize: 18);

                              return ListTile(
                                onTap: () {
                                  print("HELLO WORLD");

                                  final isSelected =
                                      bgThemesSelectedList.contains(bgTheme);

                                  setState(() => isSelected
                                      ? bgThemesSelectedList.remove(bgTheme)
                                      : bgThemesSelectedList.add(bgTheme));

                                  print(
                                      "bgThemesSelectedList, ${bgThemesSelectedList.length}");
                                },
                                // leading: FlagWidget(code: BgMechanic),
                                title: Text(
                                  bgTheme.name,
                                  style: style,
                                ),
                                trailing: isSelected
                                    ? Icon(Icons.check,
                                        color: selectedColor, size: 26)
                                    : null,
                              );
                            }).toList()),
                          ),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
        });
      },
    ).whenComplete(() {
      _userProvider.updateBgMechanicsAndThemes(userSnapshot,
          bgMechanicsSelectedList, bgThemesSelectedList, _scaffoldKey);

      refresh();
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }

  void _basicInfoEditModalBottomSheet(context, AppUser userSnapshot) {
    final _nameTextController = TextEditingController(text: userSnapshot.name);
    final _bggNameTextController =
        TextEditingController(text: userSnapshot.bggName);
    final _birthdayTextController =
        TextEditingController(text: userSnapshot.age);
    final _genderTextController =
        TextEditingController(text: userSnapshot.gender);
    final _currentLocationTextController =
        TextEditingController(text: userSnapshot.currentLocation);

    final _focusName = FocusNode();
    final _focusBggName = FocusNode();
    final _focusBirthday = FocusNode();
    final _focusGender = FocusNode();
    final _focusCurrentLocation = FocusNode();

    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        context: context,
        builder: (ctx) => Padding(
              padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Basic info",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32)),
                  Form(
                    key: _userFormKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        controller: _bggNameTextController,
                        focusNode: _focusBggName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          labelText: "BGG Name",
                          hintText: "BGG Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        controller: _birthdayTextController,
                        focusNode: _focusBirthday,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          labelText: "Birthday",
                          hintText: "Birthday",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        controller: _genderTextController,
                        focusNode: _focusGender,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          labelText: "Gender",
                          hintText: "Gender",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        controller: _currentLocationTextController,
                        focusNode: _focusCurrentLocation,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          labelText: "Current location",
                          hintText: "Current location",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isProcessing = true;
                                    });
                                    if (_userFormKey.currentState!.validate()) {
                                      // First name
                                      _userProfileEdit.name =
                                          _nameTextController.text;

                                      // BGG Name
                                      _userProfileEdit.bggName =
                                          _bggNameTextController.text;

                                      // Gender
                                      _userProfileEdit.gender =
                                          _genderTextController.text;

                                      // Current Location
                                      _userProfileEdit.currentLocation =
                                          _currentLocationTextController.text;

                                      // Birthday
                                      _userProfileEdit.birthDay =
                                          _birthdayTextController.text;

                                      await _userProvider
                                          .updateUserBasicInfo(userSnapshot,
                                              _userProfileEdit, _scaffoldKey)
                                          .then((response) {
                                        if (response is Success) {}
                                      });

                                      setState(() {
                                        _isProcessing = false;
                                      });
                                    } else {
                                      setState(() {
                                        _isProcessing = false;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                              ],
                            ),
                    ]),
                  )
                ],
              ),
            ));
  }

  Widget getProfileImage(AppUser user, UserProvider firebaseProvider) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.profilePhotoPath),
            radius: 75,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kAccentColor, width: 1.0),
          ),
        ),
        Positioned(
            left: 0.8,
            right: 1.0,
            bottom: 1.0,
            child: RoundedIconButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  firebaseProvider.updateUserProfilePhoto(
                      pickedFile.path, _scaffoldKey);
                }
              },
              iconData: Icons.edit,
              iconSize: 18,
              buttonColor: kAccentColor,
            ))
      ],
    );
  }
}
