import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/model/bg_theme.dart';
import 'package:flutter_demo_01/model/user_bio_edit.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:provider/provider.dart';
import "package:flutter_demo_01/utils/utils.dart";

class ProfilePageFavTopBoardGamesEdit extends StatefulWidget {
  static const String id = 'profile_page_fav_board_games_edit';
  // final Function() notifyParent;
  final String gameGenre;
  final AppUser? userSnapshot;

  const ProfilePageFavTopBoardGamesEdit(
      {Key? key, this.userSnapshot, required this.gameGenre
      // required this.notifyParent
      })
      : super(key: key);

  @override
  _ProfilePageFavTopBoardGamesEditState createState() =>
      _ProfilePageFavTopBoardGamesEditState();
}

class _ProfilePageFavTopBoardGamesEditState
    extends State<ProfilePageFavTopBoardGamesEdit> {
  final UserBioEdit _userBioEdit = UserBioEdit();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late UserProvider _userProvider;

  final _bioFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final List<FavGenreItem> itemList = [
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Ffamily_game.jpg?alt=media&token=cd082d8c-a6d7-4720-a569-6c63d7853ecb",
        "1.",
        1,
        false),
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fdexterity_games.jpg?alt=media&token=f1ec1bf1-6af1-4290-8bde-46819674ea0c",
        "2.",
        2,
        false),
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fparty_games.jpg?alt=media&token=0ac34bd6-78b1-418e-b5d8-fe1e9121e2af",
        "3.",
        3,
        false),
  ];

  late Future<List<BoardGameData>> boardGames;

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();

    boardGames = RecommendedGamesApi().getBoardGamesData(
        '?game_type=5499&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1');
  }

  // itemList = [];
  // selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.gameGenre.capitalize(),
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser>(
            future: userProvider.user,
            builder: (context, userSnapshot) {
              return CustomModalProgressHUD(
                  inAsyncCall: userProvider.isLoading,
                  child: userSnapshot.hasData
                      ? Column(children: [
                          SizedBox(height: 26),
                          Text("Choose Top 3 Board Games",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24)),
                          SizedBox(height: 26),
                          Expanded(
                              child: ListView(
                            children: itemList.map((item) {
                              return InkWell(
                                  onTap: () {
                                    print("ON TAP");

                                    _showBoardGameModal(
                                        context, userSnapshot.data!);
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(item.imageUrl),
                                                fit: BoxFit.cover)),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                              Colors.grey.withOpacity(0.0),
                                              Colors.black.withOpacity(0.6),
                                            ],
                                                stops: const [
                                              0.0,
                                              1.0
                                            ])),
                                      ),
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          bottom: 0,
                                          //you can use "right" and "bottom" too
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Center(
                                                child: Text(
                                              item.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32),
                                            )),
                                          )),
                                    ],
                                  ));
                            }).toList(),
                          ))
                        ])
                      : Container());
            },
          );
        }));
  }

  _getBoardGames(String gameGenre) {
    // RecommendedGamesApi()
    //     .getBoardGamesData(
    //         '?game_type=5499&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1')
    //     .then((response) {
    //   print("response $response");

    //   final parsedJson = json.decode(response.body);

    //   final finalResponse = ResponseData.fromJson(parsedJson);

    //   print(finalResponse.results[0].name);
    //   print(finalResponse.results[1].name);
    //   print(finalResponse.results[0].recRank);
    //   print(finalResponse.results[1].recRank);
    //   print(finalResponse.results[0].recRating);
    //   print(finalResponse.results[1].recRating);

    //   return finalResponse.results;
    // });
  }

  void _showBoardGameModal(context, AppUser userSnapshot) {
// TODO
// 1. Make a HTTP request to recommend.games
//  https://recommend.games/api/games/?game_type=5499&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1

    // RecommendedGamesApi()
    //     .getBoardGamesData(
    //         '?game_type=5499&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1')
    //     .then((response) {
    //   print("response $response");

    //   final parsedJson = json.decode(response.body);

    //   final finalResponse = ResponseData.fromJson(parsedJson);

    //   print(finalResponse.results[0].name);
    //   print(finalResponse.results[1].name);
    //   print(finalResponse.results[0].recRank);
    //   print(finalResponse.results[1].recRank);
    //   print(finalResponse.results[0].recRating);
    //   print(finalResponse.results[1].recRating);

    //   boardGames = finalResponse.results;
    // });

/* Board Game Mechanics  */

    /* END Board Game Themes END */

    BoardGameData? boardGameSelected;

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

          return FutureBuilder<List<BoardGameData>>(
              future: boardGames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.56,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          boardGameSelected = snapshot.data![index];

                          print(
                              "THIS IS THE SELECTED BOARD GAME!!! ${boardGameSelected?.name}");
                          // Navigator.of(context).push(PageRouteBuilder(
                          //   pageBuilder: (
                          //     BuildContext context,
                          //     Animation<double> animation,
                          //     Animation<double> secondaryAnimation,
                          //   ) =>
                          //       ProfilePageFavTopBoardGamesEdit(
                          //           gameGenre: snapshot.data![index].name,
                          //           userSnapshot: userSnapshot.data!),
                          //   // ProfilePageFavBoardGamesEdit(
                          //   //     userSnapshot:
                          //   //         userSnapshot.data!,
                          //   //     notifyParent: refresh),
                          //   transitionsBuilder: (
                          //     BuildContext context,
                          //     Animation<double> animation,
                          //     Animation<double> secondaryAnimation,
                          //     Widget child,
                          //   ) =>
                          //       SlideTransition(
                          //     position: Tween<Offset>(
                          //       begin: const Offset(1, 0),
                          //       end: Offset.zero,
                          //     ).animate(animation),
                          //     child: child,
                          //   ),
                          // ));
                          // print("ON TAP");
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                                height: 350.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data![index].imageUrl[0]),
                                        fit: BoxFit.cover))),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Colors.grey.withOpacity(0.0),
                                    Colors.black.withOpacity(0.6),
                                  ],
                                      stops: const [
                                    0.0,
                                    1.0
                                  ])),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                        snapshot.data![index].name.capitalize(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)))
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              });

          return Column(
            children: [
              Text("Here are your favourite mechanics",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
              SizedBox(height: 26),
              // Expanded(
              //   child: ListView(
              //       children: boardGames.map((bgMechanic) {
              //     // final isSelected =
              //     //     bgMechanicsSelectedList.contains(bgMechanic);

              //     // final selectedColor = Theme.of(context).primaryColor;
              //     // final style = isSelected
              //     //     ? TextStyle(
              //     //         fontSize: 18,
              //     //         color: selectedColor,
              //     //         fontWeight: FontWeight.bold,
              //     //       )
              //     //     : TextStyle(fontSize: 18);

              //     return ListTile(
              //       onTap: () {
              //         print("HELLO WORLD");

              //         // final isSelected =
              //         //     bgMechanicsSelectedList.contains(bgMechanic);

              //         // setState(() => isSelected
              //         //     ? bgMechanicsSelectedList.remove(bgMechanic)
              //         //     : bgMechanicsSelectedList.add(bgMechanic));

              //         // print(
              //         //     "bgMechanicsSelectedList, ${bgMechanicsSelectedList.length}");
              //       },
              //       // leading: FlagWidget(code: BgMechanic),
              //       title: Text(
              //         bgMechanic.name,
              //         style: TextStyle(fontSize: 18),
              //       ),
              //       // trailing: isSelected
              //       //     ? Icon(Icons.check, color: selectedColor, size: 26)
              //       //     : null,
              //     );
              //   }).toList()),
              // ),
              // selectMechanicsButton(
              //     context, userSnapshot, bgMechanicsSelectedList)
            ],
          );
        });
      },
    ).whenComplete(() {
      // _userProvider.updateBgMechanicsAndThemes(userSnapshot,
      //     bgMechanicsSelectedList, bgThemesSelectedList, _scaffoldKey);

      if (boardGameSelected != null) {
        _userProvider.updateFavouriteBoardGamesByGenre(
            userSnapshot, boardGameSelected!, _scaffoldKey);
        print("boardGameSelected ${boardGameSelected?.name}");
      }

// boardGameSelected.bggId
      // refresh();
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }
}
