import 'dart:developer';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/discover/discover_card.dart';
import 'package:flutter_demo_01/components/discover/tinder_card.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';
import 'package:flutter_demo_01/components/widgets/swipe_card.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  static const String id = 'discover_page';

  @override
  _DiscoverPage createState() => _DiscoverPage();
}

// TODO 1. Get userId of logged in user [], ignoreid in loadPerson [x]
// TODO
// TODO

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
    _ignoreSwipeIds = <String>[];
    _userList = <AppUser>[];

    var swipes = await _databaseSource.getSwipes(myUser.id);
    for (var i = 0; i < swipes.size; i++) {
      Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
      _ignoreSwipeIds.add(swipe.id);
    }
    _ignoreSwipeIds.add(myUser.id);

    var res = await _databaseSource.getPersonsToMatchWith(2, _ignoreSwipeIds);

    if (res.docs.isNotEmpty) {
      res.docs.forEach((element) {
        _userList.add(AppUser.fromSnapshot(element));
      });

      return _userList.reversed.toList();
    }

    return null;
  }

  void personSwiped(List<AppUser> users, AppUser myUser, AppUser otherUser,
      bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));
    _ignoreSwipeIds.add(otherUser.id);
    // widget.ignoreSwipeIds.add(otherUser.id);

    if (isLiked = true) {
      if (await isMatch(myUser, otherUser) == true) {
        _databaseSource.addMatch(myUser.id, Match(otherUser.id));
        _databaseSource.addMatch(otherUser.id, Match(myUser.id));
        // var uuid = Uuid();
        // var chatId = uuid.v4();
        // BACKUP
        String chatId = compareAndCombineIds(myUser.id, otherUser.id);

        print("new Chatid ${chatId}");

        print("new firstUserId ${myUser.id}");
        print("new secondUserId ${otherUser.id}");

        // var uuid = uu();
        _databaseSource.addChat(Chat(chatId, myUser.id, otherUser.id, null));
        // _databaseSource.addChat(Chat(chatId, null));

        Navigator.pushNamed(context, MatchedScreen.id, arguments: {
          "my_user_id": myUser.id,
          "my_profile_photo_path": myUser.profilePhotoPath,
          "other_user_profile_photo_path": otherUser.profilePhotoPath,
          "other_user_id": otherUser.id
        });
      }
    }

    setState(() {});
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
    print("Doing something...");

    return Scaffold(
        key: _scaffoldKey,
        body: Container(child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                  inAsyncCall:
                      userProvider.user == null || userProvider.isLoading,
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
                                child: Container(
                                    child: Text('No more users to swipe',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4)),
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
        )));
  }

  Widget buildLogo() => Row(
        children: [
          Icon(
            Icons.gamepad_rounded,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(width: 4),
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
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
