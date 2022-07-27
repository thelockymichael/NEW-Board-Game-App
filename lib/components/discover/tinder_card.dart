// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_demo_01/api/get_nearest_users_api.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import "package:flutter_demo_01/utils/utils.dart";
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TinderCard extends StatefulWidget {
  final ResultAppUser? user;
  final Function notifyParent;
  final AppUser? myUser;
  final bool isFront;

  const TinderCard({
    Key? key,
    required this.user,
    required this.notifyParent,
    required this.myUser,
    required this.isFront,
  }) : super(key: key);

  @override
  _TinderCardState createState() => _TinderCardState();
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.height,
    this.child,
  });

  final VoidCallback? openContainer;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: null,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}

class _TinderCardState extends State<TinderCard> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  void _showMarkedAsDoneSnackbar(bool? isMarkedAsDone) {
    if (isMarkedAsDone ?? false)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Marked as done!'),
      ));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
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

          provider.endPosition(context, widget.myUser!, widget.notifyParent);
        },
      );

  // TODO Display all available images ???

  Widget buildCard() => ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: _OpenContainerWrapper(
        context: context,
        userSnapshot: widget.user!,
        onClosed: _showMarkedAsDoneSnackbar,
        transitionType: _transitionType,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return _InkWellOverlay(
              child: Stack(children: [
            CachedNetworkImage(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              imageUrl: widget.user!.profilePhotoPaths[0].isEmpty
                  // TODO Use the first profilePhoto URL user has in array
                  ? Utils.stockUserProfileUrl
                  : widget.user!.profilePhotoPaths[0],
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
                child: Align(
                    child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: buildName(),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        openContainer();
                        print("LOG yui onTap");
                      },
                      child: Container(
                          height: 180,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [recentlyActive(), userDistance()]),
                            ),
                          ))),
                ])),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.2, 0.8, 1],
                  ),
                )),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                    onTap: () {
                      print("LOG yui right");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.50 - 16,
                      color: Colors.transparent,
                    ))),
            Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                    onTap: () {
                      print("LOG yui left");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.50 - 16,
                      color: Colors.transparent,
                    )))
          ]));
        },
      ));

  Widget recentlyActive() => Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.green),
          const SizedBox(width: 8),
          Text("Recently active",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              )),
          const SizedBox(width: 8),
          const Icon(Icons.info_rounded, color: Colors.white),
        ],
      );

  Widget userDistance() {
    final geoLocation = widget.user!.currentGeoLocation;
    if (geoLocation.latitude == 0 && geoLocation.longitude == 0) {
      return Container();
    }

    return Row(
      children: [
        Text("${widget.user!.distance.toString()} kilometers away",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
      ],
    );
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
            convertToAge(widget.user!.age),
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ],
      );

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
            angle: 0.5, color: Colors.red, text: "SKIP", opacity: opacity);

        return Positioned(
          top: 64,
          right: 50,
          child: child,
        );
      case CardStatus.superLike:
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
  String username = "";
  BggWebView(this.url, this.username, {Key? key}) : super(key: key);

  @override
  State<BggWebView> createState() => _BggWebViewState();
}

class _BggWebViewState extends State<BggWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: widget.username.isEmpty
              ? Text("Board Game Geek")
              : Text(widget.username)),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
        );
      }),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper(
      {required this.closedBuilder,
      required this.transitionType,
      required this.onClosed,
      required this.context,
      required this.userSnapshot});

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool?> onClosed;
  final BuildContext context;
  final ResultAppUser userSnapshot;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return DetailsPage(userSnapshot: userSnapshot, context: context);
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class DetailsPage extends StatefulWidget {
  final ResultAppUser userSnapshot;
  final BuildContext context;

  const DetailsPage(
      {Key? key, required this.userSnapshot, required this.context})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // _DetailsPage({required this.userSnapshot, required this.context});

  // IMAGES
  int indexOfItem = 0;

  List<String> imgList = [];
  final CarouselController _controller = CarouselController();
  // END IMAGES

  // LOADING
  bool isLoading = true;

  final List<String> listHeader = [
    'Family Games',
    'Dexterity Games',
    'Party Games',
    'Abstracts',
    'Thematic',
    'Strategy',
    'Wargames',
  ];
  final List<String> listTitle = [
    'title1',
    'title2',
    'title3',
  ];

  @override
  void initState() {
    super.initState();

    final profilePhotoPaths = widget.userSnapshot.profilePhotoPaths;

    // TODO Remove ALL IMAGES THAT DON'T EXIST
    for (var i = 0; i < profilePhotoPaths.length; i++) {
      if (profilePhotoPaths[i].isEmpty) continue;
      imgList.add(profilePhotoPaths[i]);
    }

    print("LOG poi ${imgList.length}");

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => precacheNetworkImages());
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      indexOfItem = index;
    });

    print("LOG indexOfItem $indexOfItem");
  }

  Future precacheNetworkImages() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait(imgList.map((e) => Utils.cacheNetworkImage(context, e)));

    setState(() {
      isLoading = false;
    });
  }

  Widget buildImages() {
    final double height = MediaQuery.of(context).size.height * 0.6;
    print("LOG poi $isLoading");
    if (imgList.length == 0) {
      return Container();
    }

    if (isLoading) {
      return Container();
    }

    return CarouselSlider(
        options: CarouselOptions(
            height: height,
            viewportFraction: 1.0,
            onPageChanged: onPageChange,
            enableInfiniteScroll: false,
            initialPage: indexOfItem),
        carouselController: _controller,
        items: imgList
            .map((item) => CachedNetworkImage(
                  imageUrl: item,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CustomModalProgressHUD(
                          inAsyncCall: true, child: Container()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: isLoading
                ? CustomModalProgressHUD(
                    inAsyncCall: true,
                    child: Container(),
                  )
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      buildImages(),
                      // CachedNetworkImage(
                      //   alignment: Alignment.center,
                      //   height: MediaQuery.of(context).size.height,
                      //   imageUrl: userSnapshot.profilePhotoPaths[0].isEmpty
                      //       ? Utils.stockUserProfileUrl
                      //       : userSnapshot.profilePhotoPaths[0],
                      //   imageBuilder: (context, imageProvider) => Container(
                      //     decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //         image: imageProvider,
                      //         fit: BoxFit.fitHeight,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // In what city or place user is currently located
                      buildLocality(),

                      // How far away is the user
                      buildUserDistance(),

                      // Board Game Geek Username
                      buildBggName(),

                      // BIO
                      buildBio(),

                      // BOARD GAME GENRES
                      buildFavGameGenres(),

                      // BOARD GAME MECHANICS
                      buildBgMechanics(),

                      // BOARD GAME THEMES
                      buildBgThemes(),

                      // FAVOURITE BOARD GAMES
                      buildFavBoardGames(),
                    ],
                  ))));
  }

  Widget buildLocality() {
    final geoLocation = widget.userSnapshot.currentLocation;

    if (geoLocation.isEmpty) {
      return Container();
    }
    // TODO 10 miles away
    // TODO Calculate user's distance from other user

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
              Row(
                children: [
                  const Icon(Icons.location_city, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    "${geoLocation.capitalize()}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget buildUserDistance() {
    final geoLocation = widget.userSnapshot.currentGeoLocation;

    if (geoLocation.latitude == 0 && geoLocation.longitude == 0) {
      return Container();
    }
    // TODO 10 miles away
    // TODO Calculate user's distance from other user

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
              Row(
                children: [
                  const Icon(Icons.pin_drop, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    "${widget.userSnapshot.distance.toString()} kilometers away",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget buildBggName() {
    final bggName = widget.userSnapshot.bggName;

    if (bggName.isEmpty) {
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
                  "Board Game Geek User",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.gamepad_rounded, color: Colors.black),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      print("LOG tap showBggUserInWebBrowser(bggName)");
                      showBggUserInWebBrowser(bggName);
                    },
                    child: Text(
                      bggName,
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }

  showBggUserInWebBrowser(String bggName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BggWebView(
                "https://boardgamegeek.com/collection/user/$bggName?rated=1&subtype=boardgame&ff=1",
                bggName)));
  }

  Widget buildBio() {
    final bio = widget.userSnapshot.bio;

    if (bio.isEmpty) {
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
                  "About me",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  bio,
                  style: const TextStyle(fontSize: 20),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget buildFavGameGenres() {
    final favBoardGameGenres = widget.userSnapshot.favBoardGameGenres;

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

  Widget buildBgMechanics() {
    final favBgMechanics = widget.userSnapshot.favBgMechanics;

    if (favBgMechanics.isEmpty) {
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
                  "My favourite game mechanics",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Wrap(
                      children: favBgMechanics.map((gameGenre) {
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
      ),
    );
  }

  Widget buildBgThemes() {
    final favBgThemes = widget.userSnapshot.favBgThemes;

    if (favBgThemes.isEmpty) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My favourite game themes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Wrap(
                      children: favBgThemes.map((gameGenre) {
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
      ),
    );
  }

  Widget buildFavBoardGames() {
    final favBoardGames = widget.userSnapshot.favBoardGames;

    // 2.
    bool isFamGamesEmpty = favBoardGames.familyGames
        .every((element) => element.boardGame.name.isEmpty);

    bool isPartyGamesEmpty = favBoardGames.partyGames
        .every((element) => element.boardGame.name.isEmpty);

    bool isAbstrGamesEmpty = favBoardGames.abstractGames
        .every((element) => element.boardGame.name.isEmpty);

    bool isDexGamesEmpty = favBoardGames.dexterityGames
        .every((element) => element.boardGame.name.isEmpty);

    bool isThemGamesEmpty = favBoardGames.thematicGames
        .every((element) => element.boardGame.name.isEmpty);

    bool isStratGamesEmpty = favBoardGames.strategyGames
        .every((element) => element.boardGame.name.isEmpty);

    bool isWargamesEmpty = favBoardGames.warGames
        .every((element) => element.boardGame.name.isEmpty);

    if (isFamGamesEmpty &&
        isPartyGamesEmpty &&
        isAbstrGamesEmpty &&
        isDexGamesEmpty &&
        isThemGamesEmpty &&
        isStratGamesEmpty &&
        isWargamesEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My favourite board games",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
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
                              if (!isFamGamesEmpty)
                                tempBoardGames = widget
                                    .userSnapshot.favBoardGames.familyGames;
                              break;

                            case "Dexterity Games":
                              if (!isDexGamesEmpty)
                                tempBoardGames = widget
                                    .userSnapshot.favBoardGames.dexterityGames;
                              break;

                            case "Party Games":
                              if (!isPartyGamesEmpty)
                                tempBoardGames = widget
                                    .userSnapshot.favBoardGames.partyGames;
                              break;

                            case "Abstracts":
                              if (!isAbstrGamesEmpty)
                                tempBoardGames = widget
                                    .userSnapshot.favBoardGames.abstractGames;
                              break;

                            case "Thematic":
                              if (!isThemGamesEmpty)
                                tempBoardGames = widget
                                    .userSnapshot.favBoardGames.thematicGames;
                              break;

                            case "Strategy":
                              if (!isStratGamesEmpty)
                                tempBoardGames = widget
                                    .userSnapshot.favBoardGames.strategyGames;
                              break;

                            case "Wargames":
                              if (!isWargamesEmpty)
                                tempBoardGames =
                                    widget.userSnapshot.favBoardGames.warGames;
                              break;

                            default:
                              if (!isFamGamesEmpty)
                                tempBoardGames = widget
                                    .userSnapshot.favBoardGames.familyGames;
                              break;
                          }
                          return tempBoardGames.isEmpty
                              ? Container()
                              : new StickyHeader(
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
                                                    decoration: BoxDecoration(
                                                        image: tempBoardGames[
                                                                    index]
                                                                .boardGame
                                                                .imageUrl[0]
                                                                .isEmpty
                                                            ? null
                                                            : DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(
                                                                    tempBoardGames[
                                                                            index]
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
                                                            .withOpacity(0.0),
                                                        Colors.black
                                                            .withOpacity(0.6)
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
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Center(
                                                          child: Text(
                                                        tempBoardGames[index]
                                                            .rank
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 32),
                                                      )),
                                                    )),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          child:
                                                              Column(children: [
                                                            Text(
                                                              "#${tempBoardGames[index].boardGame.recRank.toString()}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              "(${tempBoardGames[index].boardGame.recRating.toStringAsFixed(1)})",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
                                                            )
                                                          ])),
                                                    )),
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
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20)))
                                                  ],
                                                )
                                              ],
                                            );
                                          })));
                        })))
          ]),
        ],
      ),
    );
  }
}
