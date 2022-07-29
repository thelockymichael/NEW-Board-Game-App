import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/tutorial_card_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/get_nearest_users_api.dart';
import 'package:flutter_demo_01/components/discover/discover_card.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/UserQuery.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/my_flutter_app_icons.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TutorialStart extends StatefulWidget {
  static const String id = 'tutorial_start';

  const TutorialStart({Key? key}) : super(key: key);

  @override
  _TutorialStart createState() => _TutorialStart();
}

class _TutorialStart extends State<TutorialStart>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TutorialCardProvider tutorialCardProvider;

  bool tutorialStarted = false;

  bool isLoading = false;

  int currentPage = 0;

  List<String> assetImages = [
    'assets/images/tutorial/tutorial-superlike.jpg',
    'assets/images/tutorial/tutorial-skip.jpg',
    'assets/images/tutorial/tutorial-like.jpg',
    'assets/images/tutorial/tutorial-start.jpg',
  ];

  @override
  void initState() {
    super.initState();

    tutorialCardProvider =
        Provider.of<TutorialCardProvider>(context, listen: false);

    tutorialCardProvider.setTutorialCards(assetImages);

    print("LOG nextCard ${tutorialCardProvider.tutorialCards[0]}");
  }

  Future loadAssetImages() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait(
        assetImages.map((image) => Utils.cacheImage(context, image)).toList());

    setState(() {
      isLoading = false;
    });
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
              onPressed: () {},
            )
          ],
        ),
        key: _scaffoldKey,
        body: FutureBuilder(
            future: loadAssetImages(),
            builder: (context, snapshot) {
              if (isLoading) {
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.red.shade200, Colors.black])),
                  child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SafeArea(
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              const SizedBox(height: 16),
                              Expanded(child: buildCards()),
                              const SizedBox(height: 16),
                              buildButtons()
                            ])),
                      )),
                );
              } else {
                return Container();
              }
            }));
  }

  updateTutorialStarted() {
    setState(() {
      tutorialStarted = !tutorialStarted;
    });
  }

  nextPage() {
    setState(() {
      currentPage += 1;
    });
  }

  Widget buildCards() {
    return Stack(
      children: tutorialCardProvider.tutorialCards
          .map((tutorialCard) => TutorialCard(
                tutorialStarted: tutorialStarted,
                tutorialCard: tutorialCard,
                isFront:
                    tutorialCardProvider.tutorialCards.last == tutorialCard,
                updateTutorialStarted: updateTutorialStarted,
                nextPage: nextPage,
                currentPage: currentPage,
              ))
          .toList(),
    );
  }

  Widget buildButtons() {
    final provider = Provider.of<TutorialCardProvider>(context);
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    switch (tutorialCardProvider.tutorialCards.last) {
      case 'assets/images/tutorial/tutorial-start.jpg':
        if (tutorialStarted) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 80, height: 80),
              Container(width: 80, height: 80),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    minimumSize:
                        MaterialStateProperty.all(const Size.square(80)),
                    elevation: MaterialStateProperty.all(8),
                    foregroundColor:
                        getColor(Colors.teal, Colors.white, isLike),
                    backgroundColor:
                        getColor(Colors.white, Colors.teal, isLike),
                    side: getBorder(Colors.teal, Colors.white, isLike)),
                onPressed: () {
                  nextPage();
                  provider.like();
                },
                child: const Icon(Icons.favorite, size: 46),
              )
            ],
          );
        } else
          return Container(height: 80);
      case 'assets/images/tutorial/tutorial-like.jpg':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  minimumSize: MaterialStateProperty.all(const Size.square(80)),
                  elevation: MaterialStateProperty.all(8),
                  foregroundColor:
                      getColor(Colors.red, Colors.white, isDislike),
                  backgroundColor:
                      getColor(Colors.white, Colors.red, isDislike),
                  side: getBorder(Colors.red, Colors.white, isDislike)),
              onPressed: () {
                provider.dislike();
              },
              child: const Icon(Icons.clear, size: 46),
            ),
            Container(width: 80, height: 80),
            Container(width: 80, height: 80),
          ],
        );

      case 'assets/images/tutorial/tutorial-skip.jpg':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(width: 80, height: 80),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  minimumSize: MaterialStateProperty.all(const Size.square(80)),
                  elevation: MaterialStateProperty.all(8),
                  foregroundColor:
                      getColor(Colors.blue, Colors.white, isSuperLike),
                  backgroundColor:
                      getColor(Colors.white, Colors.blue, isSuperLike),
                  side: getBorder(Colors.blue, Colors.white, isSuperLike)),
              onPressed: () {
                provider.superLike();
              },
              child: const Icon(Icons.star, size: 46),
            ),
            Container(width: 80, height: 80),
          ],
        );

      default:
        return Container(height: 80);
    }
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

class TutorialCard extends StatefulWidget {
  final bool isFront;
  final String tutorialCard;
  final bool tutorialStarted;
  final Function updateTutorialStarted;
  final Function nextPage;
  final int currentPage;

  const TutorialCard(
      {Key? key,
      required this.isFront,
      required this.tutorialCard,
      required this.tutorialStarted,
      required this.updateTutorialStarted,
      required this.nextPage,
      required this.currentPage})
      : super(key: key);

  @override
  _TutorialCardState createState() => _TutorialCardState();
}

class _TutorialCardState extends State<TutorialCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider =
          Provider.of<TutorialCardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  void skipTutorial() async {
    await SharedPreferencesUtil.setTutorialState(true);

    print("LOG cbv SKIP TUTORIAL !!!");

    await Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => MainNavigation()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tutorialStarted) {
      return SizedBox.expand(
          child: widget.isFront ? buildFrontCard() : buildCard());
    } else {
      return SizedBox.expand(child: widget.isFront ? buildCard() : buildCard());
    }
  }

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<TutorialCardProvider>(context);
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
          final provider =
              Provider.of<TutorialCardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider =
              Provider.of<TutorialCardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider =
              Provider.of<TutorialCardProvider>(context, listen: false);

          provider.endPosition();
        },
      );

  Widget buildCard() {
    switch (widget.tutorialCard) {
      case 'assets/images/tutorial/tutorial-start.jpg':
        if (widget.tutorialStarted) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                          "assets/images/tutorial/tutorial-start.jpg"),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black45, Colors.black45],
                          stops: const [1.0, 1.0]),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      skipTutorial();
                    },
                    child: Text(
                      'SKIP',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent.withOpacity(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        "Like by swiping right!",
                        style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                fontSize: 20)
                            .underlined(distance: 8),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Or using the heart icon",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "You will only get a match if you both like each other. Try it out!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      SizedBox(height: 40),
                    ])),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform.translate(
                      offset: const Offset(36, 0),
                      child: Transform.rotate(
                        angle: 240 * pi / 180,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 70,
                            color: Colors.white,
                          ),
                          onPressed: null,
                        ),
                      ),
                    ))
              ],
            ),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                          "assets/images/tutorial/tutorial-start.jpg"),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black45, Colors.black45],
                          stops: const [1.0, 1.0]),
                    ),
                  ),
                ),
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        "Let's start!",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Here is everything you need to know",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 40),
                      Padding(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        widget.updateTutorialStarted();
                                        print(
                                            "LOG nextCard ${widget.tutorialStarted}");
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text("START TUTORIAL",
                                              style: TextStyle(fontSize: 20)))))
                            ],
                          )),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                skipTutorial();
                              },
                              child: Text(
                                'SKIP',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                primary: Colors.transparent,
                                shadowColor:
                                    Colors.transparent.withOpacity(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      )
                    ]))
              ],
            ),
          );
        }
      case 'assets/images/tutorial/tutorial-like.jpg':
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image:
                        AssetImage("assets/images/tutorial/tutorial-like.jpg"),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black45, Colors.black45],
                        stops: const [1.0, 1.0]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    skipTutorial();
                  },
                  child: Text(
                    'SKIP',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      "Skip by swiping left!",
                      style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              fontSize: 20)
                          .underlined(distance: 8),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Or using the cross icon",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "If the user is not to your liking, no one needs to know you selected no.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    SizedBox(height: 40),
                  ])),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: const Offset(-50, -15.0),
                  child: Transform.rotate(
                    angle: -50 * pi / 180,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 70,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
                  ),
                ),
              )
            ],
          ),
        );

      case 'assets/images/tutorial/tutorial-skip.jpg':
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image:
                        AssetImage("assets/images/tutorial/tutorial-skip.jpg"),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black45, Colors.black45],
                        stops: const [1.0, 1.0]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    skipTutorial();
                  },
                  child: Text(
                    'SKIP',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent.withOpacity(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      "Superlike by swiping up!",
                      style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              fontSize: 20)
                          .underlined(distance: 8),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Or using the star icon",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Tap the superlike button when you like someone and want to show it.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    SizedBox(height: 40),
                  ])),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: const Offset(-20, 0),
                  child: Transform.rotate(
                    angle: 270 * pi / 180,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 70,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
                  ),
                ),
              )
            ],
          ),
        );

      case 'assets/images/tutorial/tutorial-superlike.jpg':
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                        "assets/images/tutorial/tutorial-superlike.jpg"),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black45, Colors.black45],
                        stops: const [1.0, 1.0]),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 24, right: 20, top: 24),
                  child: Column(children: [
                    Text("We have more...",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20)),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(Icons.chat, color: Colors.yellow[800]),
                          ),
                          Flexible(
                            child: Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: Text(
                                  "Chat with matched users",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(Icons.supervised_user_circle,
                                color: Colors.green[800]),
                          ),
                          Flexible(
                            child: Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: Text(
                                  "Customize your profile and choose your favourite board games, genres, gameplay mechanics and themes",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(Icons.sort, color: Colors.blue[800]),
                          ),
                          Flexible(
                            child: Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: Text(
                                  "Filter users by place, distance, language, gender, board game genres and more",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  SharedPreferencesUtil.setTutorialState(true);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MainNavigation()),
                                      (route) => false);
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text("LET'S GO",
                                        style: TextStyle(fontSize: 20)))))
                      ],
                    ),
                  ])),
            ],
          ),
        );

      default:
        return Container();
    }
  }

  Widget buildStamps() {
    final provider = Provider.of<TutorialCardProvider>(context);
    final status = provider.getStatus();

    final opacity = provider.getStatusOpacity();

    switch (status) {
      case TutorialCardStatus.like:
        final child = buildStamp(
            angle: -0.5, color: Colors.green, text: "LIKE", opacity: opacity);

        return Positioned(
          top: 64,
          left: 50,
          child: child,
        );
      case TutorialCardStatus.dislike:
        final child = buildStamp(
            angle: 0.5, color: Colors.red, text: "SKIP", opacity: opacity);

        return Positioned(
          top: 64,
          right: 50,
          child: child,
        );
      case TutorialCardStatus.superLike:
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
