// ignore_for_file: prefer_function_declarations_over_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  static const String id = 'discover_page';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPage createState() => _DiscoverPage();
}

class _DiscoverPage extends State<DiscoverPage> {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<String> _ignoreSwipeIds;
  late List<AppUser> _userList;

  @override
  void initState() {
    super.initState();
    _ignoreSwipeIds = <String>[];
    _userList = <AppUser>[];
  }

  Future<List<AppUser>?> loadPerson(AppUser myUser) async {
    print("VMK");

    _ignoreSwipeIds = <String>[];
    _userList = <AppUser>[];

    var swipes = await _databaseSource.getSwipes(myUser.id);
    for (var i = 0; i < swipes.size; i++) {
      Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
      _ignoreSwipeIds.add(swipe.id);
    }
    _ignoreSwipeIds.add(myUser.id);

    // TODO Create dictionary
    // Map<String, dynamic> map = {"ignoreSwipeIds": _ignoreSwipeIds};

    // print("KJH ${map["ignoreSwipeIds"]}");

    // var jot = calculateAge(DateTime(1998, 5, 21));

    List<UserQuery> userQuery = [
      UserQuery("age", "isGreaterThanOrEqualTo", 20),
      UserQuery("age", "isLessThanOrEqualTo", 26),
      UserQuery("gender", "isEqualTo", "female")
    ];

    var res = await _databaseSource.getPersonsToMatchWith(
        2, _ignoreSwipeIds, userQuery);

    // TODO Implement showBottomModal

    // var res = await _databaseSource.getPersonsToMatchWith(2, tempQuery);

    if (res.docs.isNotEmpty) {
      _userList = [];
      for (var element in res.docs) {
        _userList.add(AppUser.fromSnapshot(element));
      }

      final provider = Provider.of<CardProvider>(context, listen: false);

      print("HASTA provider setUser ${_userList.reversed.toList().length}");

      provider.setUsers(_userList.reversed.toList());

      return _userList.reversed.toList();
    }

    return null;
  }

  void _filterSwipableUsersModalBottomSheet(context) {
    showModalBottomSheet(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Column(
                children: [
                  Text("Here are your favourite mechanics",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24)),
                  SizedBox(height: 26),
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
                              Text("Everyone", style: TextStyle(fontSize: 20)),
                              SizedBox(width: 12),
                              const Icon(CustomIcons.right_open)
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            print("JOTAIN dasdjas");
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  void personSwiped(List<AppUser> users, AppUser myUser,
      List<AppUser> otherUsers, bool isLiked) async {
    print("PERSONSWIPED ${myUser.id}");

    print("PERSONSWIPED ${otherUsers.last.id}");
    print("PERSONSWIPED $isLiked");
    print("PERSONSWIPED usr");
    print(await isMatch(myUser, otherUsers.last) == true);

    _databaseSource.addSwipedUser(
        myUser.id, Swipe(otherUsers.last.id, isLiked));
    _ignoreSwipeIds.add(otherUsers.last.id);
    // widget.ignoreSwipeIds.add(otherUsers.last.id);

    if (isLiked = true) {
      if (await isMatch(myUser, otherUsers.last) == true) {
        _databaseSource.addMatch(myUser.id, Match(otherUsers.last.id));
        _databaseSource.addMatch(otherUsers.last.id, Match(myUser.id));

        String chatId = compareAndCombineIds(myUser.id, otherUsers.last.id);

        _databaseSource
            .addChat(Chat(chatId, myUser.id, otherUsers.last.id, null));

        Navigator.pushNamed(context, MatchedScreen.id, arguments: {
          "my_user_id": myUser.id,
          "my_profile_photo_path": myUser.profilePhotoPath,
          "other_user_profile_photo_path": otherUsers.last.profilePhotoPath,
          "other_user_id": otherUsers.last.id,
          "other_user_name": otherUsers.last.name
        });
      }
    }

    print("PERSONSWIPED ${users.length}");
    // otherUsers.removeLast();

    // print("otherUsers length ${otherUsers.length}");
    if (users.isEmpty) {
      setState(() {});
    }
  }

  void resetState() {
    setState(() {});
  }

  Future<bool> isMatch(AppUser myUser, AppUser otherUser) async {
    DocumentSnapshot swipeSnapshot =
        await _databaseSource.getSwipe(otherUser.id, myUser.id);

    if (swipeSnapshot.exists) {
      Swipe swipe = Swipe.fromSnapshot(swipeSnapshot);

      if (swipe.liked) {
        return true;
      }
    }
    return false;
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
                print("JOTAIN");

                _filterSwipableUsersModalBottomSheet(context);
              },
            )
          ],
        ),
        key: _scaffoldKey,
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  child: (userSnapshot.hasData)
                      ? FutureBuilder<List<AppUser>?>(
                          future: loadPerson(userSnapshot.data!),
                          // future: loadPerson(userSnapshot.data!.id),
                          // future: userProvider.user,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                !snapshot.hasData) {
                              return Center(
                                child: Text('No more users to swipe',
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              );
                            }
                            if (!snapshot.hasData) {
                              return CustomModalProgressHUD(
                                inAsyncCall: true,
                                child: Container(),
                              );
                            }

                            return DiscoverCard(
                              people: snapshot.data!,
                              myUser: userSnapshot.data!,
                              ignoreSwipeIds: _ignoreSwipeIds,
                              personSwiped: personSwiped,
                              resetState: resetState,
                              // isMatch: isMatch,
                            );
                          })
                      : Container(),
                );
              },
            );
          },
        ));
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
