import 'package:flutter/cupertino.dart';
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
  late CardProvider cardProvider;

  int currentIndex = 0;
  bool tutorialStarted = false;

  @override
  void initState() {
    super.initState();
    cardProvider = Provider.of<CardProvider>(context, listen: false);
  }

  Future loadAssetImages() async {
    List<String> assetImages = [
      'assets/images/tutorial/tutorial-start.jpg',
      'assets/images/tutorial/tutorial-like.jpg',
      'assets/images/tutorial/tutorial-skip.jpg',
      'assets/images/tutorial/tutorial-superlike.jpg'
    ];

    await Future.wait(
        assetImages.map((image) => Utils.cacheImage(context, image)).toList());
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
        body: Container(
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
        ));
  }

  Widget buildCardTutorialStart() {
    if (tutorialStarted) {
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
                    'assets/images/tutorial/tutorial-start.jpg',
                  ),
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
                onPressed: () {},
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
                ]))
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
                    'assets/images/tutorial/tutorial-start.jpg',
                  ),
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
                                    // _nextCard();
                                    setState(() {
                                      tutorialStarted = true;
                                      print("LOG nextCard $tutorialStarted");
                                    });
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
                          onPressed: () {},
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
                    ]),
                  )
                ]))
          ],
        ),
      );
    }
  }

  Widget buildCards() {
    return Stack(children: [buildCardTutorialStart()]);
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              minimumSize: MaterialStateProperty.all(const Size.square(80)),
              elevation: MaterialStateProperty.all(8),
              foregroundColor: getColor(Colors.red, Colors.white, isDislike),
              backgroundColor: getColor(Colors.white, Colors.red, isDislike),
              side: getBorder(Colors.red, Colors.white, isDislike)),
          onPressed: () {
            // provider.dislike(context, widget.myUser, widget.notifyParent);
          },
          child: const Icon(Icons.clear, size: 46),
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              minimumSize: MaterialStateProperty.all(const Size.square(80)),
              elevation: MaterialStateProperty.all(8),
              foregroundColor: getColor(Colors.blue, Colors.white, isSuperLike),
              backgroundColor: getColor(Colors.white, Colors.blue, isSuperLike),
              side: getBorder(Colors.blue, Colors.white, isSuperLike)),
          onPressed: () {
            provider.superLike();
          },
          child: const Icon(Icons.star, size: 46),
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              minimumSize: MaterialStateProperty.all(const Size.square(80)),
              elevation: MaterialStateProperty.all(8),
              foregroundColor: getColor(Colors.teal, Colors.white, isLike),
              backgroundColor: getColor(Colors.white, Colors.teal, isLike),
              side: getBorder(Colors.teal, Colors.white, isLike)),
          onPressed: () {
            // provider.like(context, widget.myUser, widget.notifyParent);
          },
          child: const Icon(Icons.favorite, size: 46),
        )
      ],
    );
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
