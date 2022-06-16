import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';
import 'package:flutter_demo_01/components/widgets/search_widget.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /** Search for Board Game  */
  String text = '';
  /** END Search for Board Game END */

  late UserProvider _userProvider;

  late Future<List<BoardGameData>> boardGames;
  late Future<List<BoardGameData>> defaultBoardGames;

  late FavBoardGames favBoardGames;

  List<SelectedBoardGame> _returnGenreOfBoardGames(
      FavBoardGames favBoardGames) {
    switch (widget.gameGenre) {
      case "family games":
        return favBoardGames.familyGames;

      case "dexterity games":
        return favBoardGames.dexterityGames;

      case "party games":
        return favBoardGames.partyGames;

      case "abstracts":
        return favBoardGames.abstractGames;

      case "thematic":
        return favBoardGames.thematicGames;

      case "strategy":
        return favBoardGames.strategyGames;

      case "wargames":
        return favBoardGames.warGames;

      default:
        return favBoardGames.familyGames;
    }
  }

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    boardGames = RecommendedGamesApi().getBoardGamesData(widget.gameGenre,
        '&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1');

    defaultBoardGames = boardGames;

    // defaultBoardGames = RecommendedGamesApi().getBoardGamesData(
    //     widget.gameGenre,
    //     '&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1');

    // widget.gameGenre,
    //   '?game_type=5499&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1');
  }

  // itemList = [];
  // selectedList = [];

  var _loadImage = new AssetImage('assets/images/white-background.jpg');

  bool _checkLoaded = true;

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
                            children: _returnGenreOfBoardGames(
                                    userSnapshot.data!.favBoardGames)
                                .map((item) {
                              return InkWell(
                                  onTap: () {
                                    print("ON TAP");

                                    _showBoardGameModal(
                                        context, userSnapshot.data!, item.rank);
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180.0,
                                        decoration: BoxDecoration(
                                            image: item.boardGame.imageUrl[0]
                                                    .isEmpty
                                                ? null
                                                : DecorationImage(
                                                    image: NetworkImage(item
                                                        .boardGame.imageUrl[0]),
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
                                      Container(
                                          child: Positioned(
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                              bottom: 0,
                                              child: Center(
                                                  child: Text(
                                                "${item.boardGame.name == "" ? "NO BOARD GAME SELECTED" : ""}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              )))),
                                      Positioned(
                                          bottom: 0,
                                          child: Container(
                                            child: Center(
                                                child: Text(
                                              item.boardGame.name.capitalize(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 32),
                                            )),
                                          )),
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          //you can use "right" and "bottom" too
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                                child: Text(
                                              item.rank.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 32),
                                            )),
                                          )),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          //you can use "right" and "bottom" too
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Row(children: [
                                                  Text(
                                                    "#${item.boardGame.recRank.toString()} ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                  Text(
                                                    "(${item.boardGame.recRating.toString()})",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: Colors.white,
                                                        fontSize: 24),
                                                  )
                                                ])),
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

  void _showBoardGameModal(context, AppUser userSnapshot, int boardGameRank) {
// TODO
// 1. Make a HTTP request to recommend.games
//  https://recommend.games/api/games/?game_type=5499&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1

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
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return FutureBuilder<List<BoardGameData>>(
              future: boardGames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchWidget(
                              text: text,
                              onEditingComplete: (searchStr) {
                                print("THIS IS TEXT $searchStr");

                                if (searchStr.isNotEmpty) {
                                  print("STR jotain $searchStr");
                                  setState(() {
                                    boardGames = RecommendedGamesApi()
                                        .getBoardGamesData(widget.gameGenre,
                                            '&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1&search=$searchStr');
                                  });
                                }

                                if (searchStr.isEmpty) {
                                  print("THIS IS EMPTY TEXT");

                                  setState(() {
                                    print("THIS IS ${defaultBoardGames}");
                                    boardGames = defaultBoardGames;
                                  });
                                }
                              },
                              onChanged: (text) {
                                setState(() {
                                  if (text.isEmpty) {
                                    print("THIS IS EMPTY TEXT");

                                    setState(() {
                                      print("THIS IS ${text}");
                                      boardGames = defaultBoardGames;
                                    });
                                  }

                                  this.text = text;
                                });
                              },
                              hintText: 'Search for a board game',
                            ),
                            Expanded(
                                child: snapshot.data!.isEmpty
                                    ? Text(
                                        "No results",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      )
                                    : GridView.builder(
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
                                              boardGameSelected =
                                                  snapshot.data![index];
                                              Navigator.of(context).pop();
                                              print(
                                                  "THIS IS THE SELECTED BOARD GAME!!! ${boardGameSelected?.name}");
                                            },
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                    height: 350.0,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .imageUrl[0]),
                                                            fit: BoxFit.cover))),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                        Colors.grey
                                                            .withOpacity(0.0),
                                                        Colors.black
                                                            .withOpacity(0.6),
                                                      ],
                                                          stops: const [
                                                        0.0,
                                                        1.0
                                                      ])),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .name
                                                                .capitalize(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20)))
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ))
                          ]));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              });
        });
      },
    ).whenComplete(() {
      if (boardGameSelected != null) {
        print("boardGame Rank $boardGameRank");
        _userProvider.updateFavouriteBoardGamesByGenre(userSnapshot,
            boardGameSelected!, boardGameRank, widget.gameGenre, _scaffoldKey);

        print("boardGameSelected ${boardGameSelected?.name}");
      }

      setState(() {
        boardGames = defaultBoardGames;
      });
      // refresh();
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }
}
