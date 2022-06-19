// ignore_for_file: must_be_immutable

import 'dart:math';
import "package:flutter_demo_01/utils/utils.dart";
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TinderCard extends StatefulWidget {
  final AppUser? user;
  final Function resetState;
  final AppUser? myUser;
  final bool isFront;

  const TinderCard({
    Key? key,
    required this.user,
    required this.resetState,
    required this.myUser,
    required this.isFront,
  }) : super(key: key);

  @override
  _TinderCardState createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: widget.isFront ? buildFrontCard() : buildCard());

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: Stack(
              children: [buildCard(), buildStamps()],
            ),
          );
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.endPosition(context, widget.myUser!);
          print("!!! END POSITION !!!");

          print("-----------------");
          print("Provider onPandEnd");
          provider.users.forEach((user) => print("USER NAME: ${user.name}"));

          print("-----------------");

/**
    required this.user,
    required this.resetState,
    required this.myUser,
    required this.isFront,
 */

          if (provider.users[0] == widget.user) {
            // TIME TO RESET

            print("TIME TO RESTARTEE");
            widget.resetState();
          }
          // widget.resetState();
        },
      );

  Widget buildCard() => ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.user!.profilePhotoPath),
                        fit: BoxFit.cover,
                        alignment: const Alignment(-0.3, 0))),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.7, 1])),
                ),
              ),

// BIO

              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "About me",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.user!.bio,
                            style: const TextStyle(fontSize: 20),
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),

              // BOARD GAME GENRES

              buildFavGameGenres(),

              // BOARD GAME MECHANIS

              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "My favourite game mechanics",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Wrap(
                                children: widget.user!.favBgMechanics
                                    .map((gameGenre) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 10),
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Text(
                                      gameGenre.capitalize(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),

              // BOARD GAME THEMES
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "My favourite game themes",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Wrap(
                                children: widget.user!.favBgMechanics
                                    .map((gameGenre) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 10),
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Text(
                                      gameGenre.capitalize(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),

              // FAVOURITE BOARD GAMES

              Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My favourite board games",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SafeArea(
                          child: SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: new ListView.builder(
                                  itemCount: listHeader.length,
                                  itemBuilder: (context, index) {
                                    var tempBoardGames = <SelectedBoardGame>[];

                                    switch (listHeader[index]) {
                                      case "Family Games":
                                        tempBoardGames = widget
                                            .user!.favBoardGames.familyGames;
                                        break;

                                      case "Dexterity Games":
                                        tempBoardGames = widget
                                            .user!.favBoardGames.dexterityGames;
                                        break;

                                      case "Party Games":
                                        tempBoardGames = widget
                                            .user!.favBoardGames.partyGames;
                                        break;

                                      case "Abstracts":
                                        tempBoardGames = widget
                                            .user!.favBoardGames.abstractGames;
                                        break;

                                      case "Thematic":
                                        tempBoardGames = widget
                                            .user!.favBoardGames.thematicGames;
                                        break;

                                      case "Strategy":
                                        tempBoardGames = widget
                                            .user!.favBoardGames.strategyGames;
                                        break;

                                      case "Wargames":
                                        tempBoardGames =
                                            widget.user!.favBoardGames.warGames;
                                        break;

                                      default:
                                        tempBoardGames = widget
                                            .user!.favBoardGames.familyGames;
                                        break;
                                    }
                                    return new StickyHeader(
                                        header: new Container(
                                          height: 38.0,
                                          color: Colors.white,
                                          padding: new EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          alignment: Alignment.centerLeft,
                                          child: new Text(
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
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: listTitle.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 180,
                                                  childAspectRatio: 2 / 3,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                          height: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                                  image: tempBoardGames[
                                                                              index]
                                                                          .boardGame
                                                                          .imageUrl[
                                                                              0]
                                                                          .isEmpty
                                                                      ? null
                                                                      : DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image: NetworkImage(tempBoardGames[index]
                                                                              .boardGame
                                                                              .imageUrl[0]),
                                                                        ))),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.0),
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.6)
                                                            ],
                                                                stops: const [
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
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Center(
                                                                child: Text(
                                                              tempBoardGames[
                                                                      index]
                                                                  .rank
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 32),
                                                            )),
                                                          )),
                                                      Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          //you can use "right" and "bottom" too
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                child: Column(
                                                                    children: [
                                                                      Text(
                                                                        "#${tempBoardGames[index].boardGame.recRank.toString()}",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        "(${tempBoardGames[index].boardGame.recRating.toStringAsFixed(1)})",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w200,
                                                                            color: Colors.white,
                                                                            fontSize: 18),
                                                                      )
                                                                    ])),
                                                          )),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                              child: Text(
                                                                  tempBoardGames[
                                                                              index]
                                                                          .boardGame
                                                                          .name
                                                                          .isEmpty
                                                                      ? "Not selected"
                                                                      : tempBoardGames[
                                                                              index]
                                                                          .boardGame
                                                                          .name,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)))
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                })));
                                  })))
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(20),
            child: Align(child: Column(children: [buildName()]))),
      ]));

  Widget buildFavGameGenres() {
    final favBoardGameGenres = widget.user!.favBoardGameGenres;

    if (favBoardGameGenres.isEmpty) {
      return Container();
    }

    return Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "I'm interested in...",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Wrap(
                        children: favBoardGameGenres.map((gameGenre) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: Text(
                              gameGenre.capitalize(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ]),
            )
          ],
        ));
  }

  Widget buildName() => Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 8),
          Text(widget.user!.name.capitalize(),
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const Text(
            ',',
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            widget.user!.age,
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ],
      );

  inform(String bggName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BggWebView(
                "https://boardgamegeek.com/collection/user/Zuxi?rated=1&subtype=boardgame&ff=1")));
  }

  Widget buildBGGName() {
    if (widget.user!.bggName.isEmpty) {
      return Container();
    }

    return GestureDetector(
        onTap: () {
          inform(widget.user!.bggName);
        },
        child: Row(
          children: [
            const Icon(Icons.gamepad_rounded, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              widget.user!.bggName,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget buildStatus() => Row(children: [
        Container(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 8),
        const Text('Recently Active',
            style: TextStyle(fontSize: 20, color: Colors.white))
      ]);

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();

    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
            angle: -0.5, color: Colors.green, text: "LIKE", opacity: opacity);

        return Positioned(
          top: 64,
          left: 50,
          child: child,
        );
      case CardStatus.dislike:
        final child = buildStamp(
            angle: 0.5, color: Colors.red, text: "NOPE!", opacity: opacity);

        return Positioned(
          top: 64,
          right: 50,
          child: child,
        );
      case CardStatus.superLike:
        // BACKUP
        final child = buildStamp(
            color: Colors.blue, text: "SUPER\nLIKE", opacity: opacity);

        return Positioned(
          bottom: 128,
          right: 50,
          left: 50,
          child: child,
        );
      default:
        return Container();
    }
  }

  Widget buildStamp(
      {double angle = 0,
      required Color color,
      required String text,
      required double opacity}) {
    return Opacity(
        opacity: opacity,
        child: Transform.rotate(
            angle: angle,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color, width: 4)),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color, fontSize: 48, fontWeight: FontWeight.bold),
                ))));
  }
}

class BggWebView extends StatefulWidget {
  String url;
  BggWebView(this.url, {Key? key}) : super(key: key);

  @override
  State<BggWebView> createState() => _BggWebViewState();
}

class _BggWebViewState extends State<BggWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Board Game Geek"),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
        );
      }),
    );
  }
}
