import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_profile_edit.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/fullscreen_image_viewer.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_bg_genre_edit.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_bio_edit.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_fav_board_games_edit.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "package:flutter_demo_01/utils/utils.dart";
import 'package:sticky_headers/sticky_headers.dart';

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

  List<String> listHeader = [
    'Family Games',
    'Dexterity Games',
    'Party Games',
    'Abstracts',
    'Thematic',
    'Strategy',
    'Wargames',
  ];

  List<String> listTitle = [
    'title1',
    'title2',
    'title3',
  ];

  String? _currentAddress;
  // Position? _currentPosition;

// 3. Select Date of Birth
  DateTime defaultSelectedDate = DateTime.now();

  TextEditingController _birthdayTextController = TextEditingController();

// END Select Date of Birth

// 4. Available Genders
  List<String> availableGenders = ["male", "female", "other"];

  late List<String> defaultSelectedGender;

  TextEditingController _genderTextController = TextEditingController();

// END Select Date of Birth

  // void _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();

  //   if (!hasPermission) return;

  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() => _currentPosition = position);

  //     _getAddressFromLatLng(_currentPosition!);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   AppUser userSnapshot = await _userProvider.user;

  //   print("SDF ${userSnapshot.name}");
  //   await placemarkFromCoordinates(
  //           _currentPosition!.latitude, _currentPosition!.longitude,
  //           localeIdentifier: "fi")
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];

  //     setState(() {
  //       _currentAddress = '${place.locality}';
  //       _userProvider.updateCurrentLocationAddress(
  //           userSnapshot, _currentAddress!, _scaffoldKey);
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content:
  //           Text("Location services are disabled. Please enable the services"),
  //     ));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Location permissions are denied")));
  //       return false;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text(
  //           "Location permissions are permanently denied, we cannot request permissions."),
  //     ));
  //     return false;
  //   }

  //   return true;
  // }

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    // _getCurrentPosition();

    super.initState();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                              createProfileImages(
                                  userSnapshot.data!, userProvider),
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
                                                            "${userSnapshot.data?.name.capitalize()}, ${convertToAge(userSnapshot.data!.age)}",
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
                                                              "Mechanics and Themes",
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
                                                      userSnapshot.data!),
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
                                                      SafeArea(
                                                          child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 300,
                                                              child: new ListView
                                                                      .builder(
                                                                  itemCount:
                                                                      listHeader
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    var tempBoardGames =
                                                                        <SelectedBoardGame>[];

                                                                    switch (listHeader[
                                                                        index]) {
                                                                      case "Family Games":
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .familyGames;
                                                                        break;

                                                                      case "Dexterity Games":
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .dexterityGames;
                                                                        break;

                                                                      case "Party Games":
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .partyGames;
                                                                        break;

                                                                      case "Abstracts":
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .abstractGames;
                                                                        break;

                                                                      case "Thematic":
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .thematicGames;
                                                                        break;

                                                                      case "Strategy":
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .strategyGames;
                                                                        break;

                                                                      case "Wargames":
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .warGames;
                                                                        break;

                                                                      default:
                                                                        tempBoardGames = userSnapshot
                                                                            .data!
                                                                            .favBoardGames
                                                                            .familyGames;
                                                                        break;
                                                                    }
                                                                    return new StickyHeader(
                                                                        header:
                                                                            new Container(
                                                                          height:
                                                                              38.0,
                                                                          color:
                                                                              Colors.white,
                                                                          padding:
                                                                              new EdgeInsets.symmetric(horizontal: 12.0),
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              new Text(
                                                                            listHeader[index],
                                                                            style: const TextStyle(
                                                                                color: Colors.purple,
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                        content: Container(
                                                                            child: GridView.builder(
                                                                                shrinkWrap: true,
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                itemCount: listTitle.length,
                                                                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                                                  maxCrossAxisExtent: 180,
                                                                                  childAspectRatio: 2 / 3,
                                                                                ),
                                                                                itemBuilder: (context, index) {
                                                                                  return Stack(
                                                                                    children: [
                                                                                      Container(
                                                                                          height: 200,
                                                                                          decoration: BoxDecoration(
                                                                                              image: tempBoardGames[index].boardGame.imageUrl[0].isEmpty
                                                                                                  ? null
                                                                                                  : DecorationImage(
                                                                                                      fit: BoxFit.cover,
                                                                                                      image: NetworkImage(tempBoardGames[index].boardGame.imageUrl[0]),
                                                                                                    ))),
                                                                                      Container(
                                                                                        decoration: BoxDecoration(
                                                                                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                                          Colors.grey.withOpacity(0.0),
                                                                                          Colors.black.withOpacity(0.6)
                                                                                        ], stops: const [
                                                                                          0.0,
                                                                                          1.0
                                                                                        ])),
                                                                                      ),
                                                                                      Positioned(
                                                                                          top: 0,
                                                                                          left: 0,
                                                                                          //you can use "right" and "bottom" too
                                                                                          child: Container(
                                                                                            height: 40,
                                                                                            width: 40,
                                                                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              tempBoardGames[index].rank.toString(),
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32),
                                                                                            )),
                                                                                          )),
                                                                                      Positioned(
                                                                                          top: 0,
                                                                                          right: 0,
                                                                                          //you can use "right" and "bottom" too
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                                                                                            child: Padding(
                                                                                                padding: EdgeInsets.all(6),
                                                                                                child: Column(children: [
                                                                                                  Text(
                                                                                                    "#${tempBoardGames[index].boardGame.recRank.toString()}",
                                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "(${tempBoardGames[index].boardGame.recRating.toStringAsFixed(1)})",
                                                                                                    style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 18),
                                                                                                  )
                                                                                                ])),
                                                                                          )),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Center(child: Text(tempBoardGames[index].boardGame.name.isEmpty ? "Not selected" : tempBoardGames[index].boardGame.name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)))
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  );
                                                                                })));
                                                                  })))
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

  void _showBgMechanicAndThemeModal(
      BuildContext context, AppUser userSnapshot) {
    /* Board Game Mechanics  */
    List<String> bgMechanicsList = Utils.bgMechanicsList;

    List<String> bgMechanicsSelectedList = [];
    for (var i = 0; i < userSnapshot.favBgMechanics.length; i++) {
      bgMechanicsSelectedList.add(userSnapshot.favBgMechanics[i]);
    }

    /* END Board Game Mechanics END */

    /* Board Game Themes  */
    List<String> bgThemesList = Utils.bgThemesList;

    List<String> bgThemesSelectedList = [];
    for (var i = 0; i < userSnapshot.favBgThemes.length; i++) {
      bgThemesSelectedList.add(userSnapshot.favBgThemes[i]);
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
          print("BOOL $b");

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
                                title: Text(
                                  bgMechanic,
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
                                title: Text(
                                  bgTheme,
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

  void _changeDateOfBirth(BuildContext context, StateSetter setModalState) {
    print("LOG STEP 1. ${this.defaultSelectedDate}");

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: CupertinoDatePicker(
                      initialDateTime: this.defaultSelectedDate,
                      maximumYear: DateTime.now().year,
                      mode: CupertinoDatePickerMode.date,
                      dateOrder: DatePickerDateOrder.dmy,
                      onDateTimeChanged: (val) {
                        setModalState(() {
                          this.defaultSelectedDate = val;
                          this._birthdayTextController = TextEditingController(
                              text: formatDateTime(defaultSelectedDate));
                        });
                      },
                    ),
                  ),
                  // Close the modal
                  ElevatedButton(
                    child: const Text("Apply",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          });
        });
  }

  void _changeGender(BuildContext context, StateSetter setModalState) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Column(
                  children: [
                    Text("Show me",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text("Which genders(s) would you like to see?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black54)),
                    SizedBox(height: 16),
                    Expanded(
                        child: ListView(
                            children: availableGenders.map((gender) {
                      final isSelected =
                          this.defaultSelectedGender.contains(gender);

                      print(
                          "LOG defaultSelectedGender ${this.defaultSelectedGender}");

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
                          this.defaultSelectedGender.clear();
                          print("LOG selected gender $gender");

                          final isSelected =
                              this.defaultSelectedGender.contains(gender);

                          print(
                              "LOG part 1. DOES IT CONTAIN GENDER $isSelected");

                          setModalState(() {
                            isSelected
                                ? this.defaultSelectedGender.remove(gender)
                                : this.defaultSelectedGender.add(gender);

                            this._genderTextController = TextEditingController(
                                text:
                                    this.defaultSelectedGender[0].capitalize());
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
                  ],
                ));
          });
        });
  }

  void _basicInfoEditModalBottomSheet(context, AppUser userSnapshot) {
    final _nameTextController =
        TextEditingController(text: userSnapshot.name.capitalize());
    final _bggNameTextController =
        TextEditingController(text: userSnapshot.bggName);

    // 3. Date of birth
    defaultSelectedDate = convertToDateTime(userSnapshot.age);

    _birthdayTextController =
        TextEditingController(text: formatDateTime(defaultSelectedDate));

    // END dateOfBirth

    // 4. Select Gender
    defaultSelectedGender = [userSnapshot.gender];

    _genderTextController =
        TextEditingController(text: defaultSelectedGender[0].capitalize());
    // END Select Gender

    final _focusName = FocusNode();
    final _focusBggName = FocusNode();

    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 15),
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
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return GestureDetector(
                            onTap: () {
                              _changeDateOfBirth(context, setState);
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: _birthdayTextController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black87),
                                labelText: "Date of birth",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return GestureDetector(
                            onTap: () {
                              _changeGender(context, setState);
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: _genderTextController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black87),
                                labelText: "Gender",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      TextFormField(
                        readOnly: true,
                        enabled: false,
                        style: TextStyle(color: Colors.grey),
                        initialValue: userSnapshot.currentLocation.isEmpty
                            ? _currentAddress
                            : userSnapshot.currentLocation,
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

                                      // Date of birth
                                      _userProfileEdit.dateOfBirth =
                                          convertToEpoch(defaultSelectedDate);

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
            )).whenComplete(() {
      setState(() {
        _isProcessing = true;
      });
      if (_userFormKey.currentState!.validate()) {
        // First name
        _userProfileEdit.name = _nameTextController.text;

        // BGG Name
        _userProfileEdit.bggName = _bggNameTextController.text;

        // Gender
        _userProfileEdit.gender = _genderTextController.text;

        // Date of birth
        _userProfileEdit.dateOfBirth = convertToEpoch(defaultSelectedDate);

        _userProvider
            .updateUserBasicInfo(userSnapshot, _userProfileEdit, _scaffoldKey)
            .then((response) {
          if (response is Success) {
            refresh();
          }
        });

        setState(() {
          _isProcessing = false;
        });

        print("LOG IS SUCCESS?");
      } else {
        setState(() {
          _isProcessing = false;
        });

        print("LOG FAILURE ???");
      }
    });
  }

  Widget createProfileImages(AppUser user, UserProvider firebaseProvider) {
    // TODO Get Pictures
    // TODO method to filter profilePhotoPaths that have imageUrl
    // TODO Boolean to determine if contains image or NOT

    print(
        "LOG DOES EXIST ${user.profilePhotoPaths[0].isEmpty}: ${user.profilePhotoPaths[0]}");

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
          child: StaggeredGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              children: [
            StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: GestureDetector(
                  onTap: () async {
                    bool noImage = user.profilePhotoPaths[0].isEmpty;

                    if (noImage) {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        firebaseProvider.updateUserProfilePhoto(
                            pickedFile.path, _scaffoldKey, 0);
                      }
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenImageViewer(
                                  user.profilePhotoPaths[0],
                                  0,
                                  _userProvider)));
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue[200],
                            image: user.profilePhotoPaths[0].isEmpty
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        user.profilePhotoPaths[0]))),
                      ),
                      Positioned(
                          left: 0.8,
                          right: 1.0,
                          bottom: 1.0,
                          child: RoundedIconButton(
                            onPressed: () async {},
                            iconData: Icons.edit,
                            iconSize: 18,
                            buttonColor: kAccentColor,
                          ))
                    ],
                  ),
                )),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.green,
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.red,
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.pink,
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.yellow,
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.white,
              ),
            ),
          ]))
    ]);

    // List<String> profileImages = [];

    // for (var i = 0; i < user.profilePhotoPaths.length; i++) {
    //   if (user.profilePhotoPaths[i].isNotEmpty) {
    //     profileImages.add(user.profilePhotoPaths[i]);
    //   }
    // }

    // print("LOG ${profileImages.length}");

    // return GestureDetector(
    //   onTap: () async {
    //     final pickedFile =
    //         await ImagePicker().pickImage(source: ImageSource.gallery);
    //     if (pickedFile != null) {
    //       firebaseProvider.updateUserProfilePhoto(
    //           pickedFile.path, _scaffoldKey, 1);
    //     }
    //   },
    //   child: Stack(
    //     children: [
    //       Container(
    //         width: 200,
    //         height: 200,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(12),
    //             color: Colors.blue[200],
    //             image: user.profilePhotoPaths[0].isEmpty
    //                 ? null
    //                 : DecorationImage(
    //                     fit: BoxFit.contain,
    //                     image: NetworkImage(user.profilePhotoPaths[0]))),
    //       ),
    //       Positioned(
    //           left: 0.8,
    //           right: 1.0,
    //           bottom: 1.0,
    //           child: RoundedIconButton(
    //             onPressed: () async {},
    //             iconData: Icons.edit,
    //             iconSize: 18,
    //             buttonColor: kAccentColor,
    //           ))
    //     ],
    //   ),
    // );

    // return Stack(
    //   children: [
    //     Container(
    //       alignment: Alignment.bottomCenter,
    //       child: CircleAvatar(
    //         backgroundImage: NetworkImage(user.profilePhotoPaths[0]),
    //         radius: 75,
    //       ),
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //         border: Border.all(color: kAccentColor, width: 1.0),
    //       ),
    //     ),
    //     Positioned(
    //         left: 0.8,
    //         right: 1.0,
    //         bottom: 1.0,
    //         child: RoundedIconButton(
    //           onPressed: () async {
    //             final pickedFile =
    //                 await ImagePicker().pickImage(source: ImageSource.gallery);
    //             if (pickedFile != null) {
    //               firebaseProvider.updateUserProfilePhoto(
    //                   pickedFile.path, _scaffoldKey, 1);
    //             }
    //           },
    //           iconData: Icons.edit,
    //           iconSize: 18,
    //           buttonColor: kAccentColor,
    //         ))
    //   ],
    // );
  }
}
