import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePageBgGenreEdit extends StatefulWidget {
  static const String id = 'profile_page_bg_genre_edit';
  final Function() notifyParent;
  final AppUser? userSnapshot;

  const ProfilePageBgGenreEdit(
      {Key? key, this.userSnapshot, required this.notifyParent})
      : super(key: key);

  @override
  _ProfilePageBgGenreEditState createState() => _ProfilePageBgGenreEditState();
}

class _ProfilePageBgGenreEditState extends State<ProfilePageBgGenreEdit> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<FavGenreItem> itemList;
  late List<FavGenreItem> selectedList;

  late UserProvider _userProvider;
  late AppUser _userSnapshot;

  @override
  void initState() {
    _userSnapshot = widget.userSnapshot!;
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    loadList();

    super.initState();
  }

  loadList() {
    itemList = [];
    selectedList = [];

    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Ffamily_game.jpg?alt=media&token=cd082d8c-a6d7-4720-a569-6c63d7853ecb",
        "family games",
        1,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fdexterity_games.jpg?alt=media&token=f1ec1bf1-6af1-4290-8bde-46819674ea0c",
        "dexterity games",
        2,
        false));

    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fparty_games.jpg?alt=media&token=0ac34bd6-78b1-418e-b5d8-fe1e9121e2af",
        "party games",
        3,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fabstract_game.jpg?alt=media&token=e020dc6f-99d0-4a93-b0cc-e59d969219a2",
        "abstracts",
        4,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fthematic_game.jpg?alt=media&token=12a936d7-5157-4eaf-b318-1af3342f1509",
        "thematic games",
        5,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Feurogame_game.jpg?alt=media&token=e38e0cc7-c9a4-4525-8c91-378c8444b51a",
        "eurogames",
        6,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fwargame.jpg?alt=media&token=e342eed7-1ca0-4fdc-b95a-560024c3b1fe",
        "wargames",
        7,
        false));

    for (var i = 0; i < itemList.length; i++) {
      if (_userSnapshot.favBoardGameGenres.contains(itemList[i].name)) {
        itemList[i].isSelected = true;

        selectedList.add(itemList[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(_userSnapshot, _scaffoldKey),
        key: _scaffoldKey,
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser>(
            future: userProvider.user,
            builder: (context, userSnapshot) {
              return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  child: userSnapshot.hasData
                      ? GridView.builder(
                          itemCount: itemList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.56,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0),
                          itemBuilder: (context, index) {
                            return GridItem(
                              item: itemList[index],
                              // selectedItem: selectedList[index],
                              isSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    selectedList.add(itemList[index]);
                                    itemList[index].isSelected = true;
                                  } else {
                                    selectedList.remove(itemList[index]);
                                    itemList[index].isSelected = false;
                                  }
                                });
                              },
                              itemKey: Key(itemList[index].rank.toString()),
                            );
                          },
                        )
                      : Container());
            },
          );
        }));
  }

  getAppBar(AppUser? userSnapshot, errorScaffoldKey) {
    var itemText = selectedList.length > 1 ? "items" : "item";

    return AppBar(
      title: Text(selectedList.isEmpty
          ? "Select favourite genres"
          : "${selectedList.length} $itemText selected"),
      actions: <Widget>[
        selectedList.isEmpty
            ? Container()
            : InkWell(
                onTap: () {
                  _userProvider.updateFavouriteBoardGameGenres(
                      userSnapshot!, selectedList, errorScaffoldKey);

                  widget.notifyParent();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  // child: Icon(Icons.select),
                  child: Center(
                      child: Text(
                    "Apply",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  )),
                ),
              )
      ],
    );
  }
}
