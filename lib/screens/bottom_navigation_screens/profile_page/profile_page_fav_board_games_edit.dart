import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_bio_edit.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_fav_top_board_games_edit.dart';
import 'package:provider/provider.dart';
import "package:flutter_demo_01/utils/utils.dart";

class ProfilePageFavBoardGamesEdit extends StatefulWidget {
  static const String id = 'profile_page_fav_board_games_edit';
  final AppUser? userSnapshot;

  const ProfilePageFavBoardGamesEdit({Key? key, this.userSnapshot})
      : super(key: key);

  @override
  _ProfilePageFavBoardGamesEditState createState() =>
      _ProfilePageFavBoardGamesEditState();
}

class _ProfilePageFavBoardGamesEditState
    extends State<ProfilePageFavBoardGamesEdit> {
  final UserBioEdit _userBioEdit = UserBioEdit();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late UserProvider _userProvider;

  final _bioFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final List<FavGenreItem> itemList = [
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Ffamily_game.jpg?alt=media&token=cd082d8c-a6d7-4720-a569-6c63d7853ecb",
        "family games",
        1,
        false),
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fdexterity_games.jpg?alt=media&token=f1ec1bf1-6af1-4290-8bde-46819674ea0c",
        "dexterity games",
        2,
        false),
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fparty_games.jpg?alt=media&token=0ac34bd6-78b1-418e-b5d8-fe1e9121e2af",
        "party games",
        3,
        false),
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fabstract_game.jpg?alt=media&token=e020dc6f-99d0-4a93-b0cc-e59d969219a2",
        "abstracts",
        4,
        false),
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Feurogame_game.jpg?alt=media&token=e38e0cc7-c9a4-4525-8c91-378c8444b51a",
        "Thematic \n / \n Eurogames",
        5,
        false),
    FavGenreItem(
        "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/board_game_genres%2Fwargame.jpg?alt=media&token=e342eed7-1ca0-4fdc-b95a-560024c3b1fe",
        "wargames",
        6,
        false)
  ];

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    super.initState();
  }

  // itemList = [];
  // selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Choose favourite board games",
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
                      ? GridView.builder(
                          itemCount: itemList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.56,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                  ) =>
                                      ProfilePageFavTopBoardGamesEdit(
                                          gameGenre: itemList[index].name,
                                          userSnapshot: userSnapshot.data!),
                                  // ProfilePageFavBoardGamesEdit(
                                  //     userSnapshot:
                                  //         userSnapshot.data!,
                                  //     notifyParent: refresh),
                                  transitionsBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child,
                                  ) =>
                                      SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ));
                                print("ON TAP");
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      height: 350.0,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  itemList[index].imageUrl),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Text(
                                              itemList[index].name.capitalize(),
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
                        )
                      : Container());
            },
          );
        }));
  }
}
