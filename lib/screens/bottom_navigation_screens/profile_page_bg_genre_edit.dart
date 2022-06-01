import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePageBgGenreEdit extends StatefulWidget {
  static const String id = 'profile_page_bg_genre_edit';
  final AppUser? userSnapshot;

  const ProfilePageBgGenreEdit({this.userSnapshot});

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

    // if (_userSnapshot.favBoardGameGenres.contains(itemList[i].name)) {
    //   print("${itemList[i].name}");

    //   selectedList.add(itemList[i]);
    // }

    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Ffamily_game.jpg?alt=media&token=cd082d8c-a6d7-4720-a569-6c63d7853ecb",
        "Family Games",
        1,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fdexterity_games.jpg?alt=media&token=f1ec1bf1-6af1-4290-8bde-46819674ea0c",
        "Dexterity Games",
        2,
        false));

    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fparty_games.jpg?alt=media&token=0ac34bd6-78b1-418e-b5d8-fe1e9121e2af",
        "Party Games",
        3,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fabstract_game.jpg?alt=media&token=e020dc6f-99d0-4a93-b0cc-e59d969219a2",
        "Abstracts",
        4,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fthematic_game.jpg?alt=media&token=21ce6eac-9f08-40e6-9a0a-d8e56046977c",
        "Thematic Games",
        5,
        true));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Feurogame_game.jpg?alt=media&token=e38e0cc7-c9a4-4525-8c91-378c8444b51a",
        "Eurogames",
        6,
        false));
    itemList.add(FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fwargame.jpg?alt=media&token=e342eed7-1ca0-4fdc-b95a-560024c3b1fe",
        "Wargames",
        7,
        false));

    for (var i = 0; i < itemList.length; i++) {
      if (_userSnapshot.favBoardGameGenres.contains(itemList[i].name)) {
        itemList[i].isSelected = true;

        selectedList.add(itemList[i]);
      }
    }

    // itemList.add(Item("Dexterity Games", 2));
    // itemList.add(Item("Party Games", 3));
    // itemList.add(Item("Abstracts Games", 4));
    // itemList.add(Item("Thematic Games", 5));
    // itemList.add(Item("Eurogames Games", 6));
    // itemList.add(Item("Wargames", 7));
    // itemList.add(Item("Abstracts", 8));

    // for (var i = 0; i < itemList.length; i++) {
    //   if (_userSnapshot.favBoardGameGenres.contains(itemList[i].name)) {
    //     print("${itemList[i].name}");

    //     selectedList.add(itemList[i]);
    //   }
    // }

    // for (var i = 0; i < itemList.length; i++) {
    //   if (_userSnapshot.favBoardGameGenres.contains(itemList[i].name)) {
    //     print("${itemList[i].name}");

    //     selectedList.add(itemList[i]);
    //   }
    // }

    // setState(() {});

    // _userSnapshot.favBoardGameGenres.forEach((element) {
    //   // if (itemList.(element)) {

    //   if (itemList.contains(element)) {
    //     print("jes");
    //   }

    //   // IF favBoardGames has board game that is in list
    //   // then => add board game to selectedList
    //   //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(_userSnapshot, _scaffoldKey),
        key: _scaffoldKey,
        body: Container(
          child:
              Consumer<UserProvider>(builder: (context, userProvider, child) {
            return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                    inAsyncCall:
                        userProvider.user == null || userProvider.isLoading,
                    child: userSnapshot.hasData
                        ? GridView.builder(
                            itemCount: itemList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      print("VALUE $value");
                                      print("itemList[index] $index");
                                      print(
                                          "itemList[index] ${itemList[index].imageUrl}");
                                      print(
                                          "itemList[index] ${itemList[index].name}");
                                      print(
                                          "itemList[index] ${itemList[index].rank}");
                                      print("------------------");

                                      selectedList.add(itemList[index]);
                                      itemList[index].isSelected = true;
                                    } else {
                                      selectedList.remove(itemList[index]);
                                      itemList[index].isSelected = false;
                                    }
                                  });
                                },
                                key: Key(itemList[index].rank.toString()),
                              );
                            },
                          )
                        : Container());
              },
            );
          }),
        ));
  }

  getAppBar(AppUser? userSnapshot, errorScaffoldKey) {
    var itemText = selectedList.length > 1 ? "items" : "item";

    return AppBar(
      title: Text(selectedList.length < 1
          ? "Select favourite genres"
          : "${selectedList.length} $itemText selected"),
      actions: <Widget>[
        selectedList.length < 1
            ? Container()
            : InkWell(
                onTap: () {
                  _userProvider.updateFavouriteBoardGameGenres(
                      userSnapshot!, selectedList, errorScaffoldKey);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
