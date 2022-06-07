import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/ui/widgets/bg_mechanic_list_tile_widget.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:provider/provider.dart';

class ProfilePageBgMechanicsEditSecond extends StatefulWidget {
  static const String id = 'profile_page_bg_genre_edit';
  final Function() notifyParent;
  final AppUser? userSnapshot;

  const ProfilePageBgMechanicsEditSecond(
      {Key? key, this.userSnapshot, required this.notifyParent})
      : super(key: key);

  @override
  _ProfilePageBgMechanicsEditStateSecond createState() =>
      _ProfilePageBgMechanicsEditStateSecond();
}

class _ProfilePageBgMechanicsEditStateSecond
    extends State<ProfilePageBgMechanicsEditSecond> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<FavBgMechanicItem> itemList;
  late List<FavBgMechanicItem> selectedList;

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

    itemList.add(FavBgMechanicItem(name: "Co-op"));
    itemList.add(FavBgMechanicItem(name: "Team"));
    itemList.add(FavBgMechanicItem(name: "Social Deduction"));
    itemList.add(FavBgMechanicItem(name: "Euro"));
    itemList.add(FavBgMechanicItem(name: "Card"));
    itemList.add(FavBgMechanicItem(name: "Resource Management"));
    itemList.add(FavBgMechanicItem(name: "Bidding"));
    itemList.add(FavBgMechanicItem(name: "Worker Placement"));

    // for (var i = 0; i < itemList.length; i++) {
    //   if (_userSnapshot.favBoardGameGenres.contains(itemList[i].name)) {
    //     itemList[i].isSelected = true;

    //     selectedList.add(itemList[i]);
    //   }
    // }
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
                      ? DefaultTabController(
                          length: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TabBar(tabs: [
                                  Tab(
                                      child: Text("Game Mechanics",
                                          style:
                                              TextStyle(color: Colors.black))),
                                  Tab(
                                      child: Text("Themes",
                                          style:
                                              TextStyle(color: Colors.black)))
                                ]),
                                Expanded(
                                    child: TabBarView(
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Text(
                                            "Here are your favourite game mechanics",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 24)),
                                        SizedBox(height: 26),
                                        Expanded(
                                            child: ListView(
                                                children:
                                                    itemList.map((bgMechanic) {
                                          final isSelected =
                                              selectedList.contains(bgMechanic);

                                          return BgMechanicListTileWidget(
                                              bgMechanic: bgMechanic,
                                              isSelected: isSelected,
                                              onSelectedBgMechanic:
                                                  selectBgMechanic);
                                        }).toList()))
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "Here are your favorite themes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        SizedBox(height: 26),
                                        Container(
                                          height: 73,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              24,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: kAccentColor,
                                              border: Border.all(
                                                width: 0.5,
                                                color: Colors.redAccent,
                                              )),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: TextField(
                                              maxLength: 30,
                                              enableInteractiveSelection: false,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(height: 1.6),
                                              cursorColor: Colors.green[800],
                                              textAlign: TextAlign.center,
                                              autofocus: false,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Credit",
                                                  counterText: ""),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ))
                      // ListView(
                      //     children: itemList.map((bgMechanic) {
                      //     final isSelected = selectedList.contains(bgMechanic);

                      //     return BgMechanicListTileWidget(
                      //         bgMechanic: bgMechanic,
                      //         isSelected: isSelected,
                      //         onSelectedBgMechanic: selectBgMechanic);
                      //   }).toList())
                      // ? GridView.builder(
                      //     itemCount: itemList.length,
                      //     gridDelegate:
                      //         const SliverGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisCount: 3,
                      //             childAspectRatio: 0.56,
                      //             crossAxisSpacing: 0,
                      //             mainAxisSpacing: 0),
                      //     itemBuilder: (context, index) {
                      //       return GridItem(
                      //         item: itemList[index],
                      //         // selectedItem: selectedList[index],
                      //         isSelected: (bool value) {
                      //           setState(() {
                      //             if (value) {
                      //               selectedList.add(itemList[index]);
                      //               itemList[index].isSelected = true;
                      //             } else {
                      //               selectedList.remove(itemList[index]);
                      //               itemList[index].isSelected = false;
                      //             }
                      //           });
                      //         },
                      //         itemKey: Key(itemList[index].rank.toString()),
                      //       );
                      //     },
                      //   )
                      : Container());
            },
          );
        }));
  }

  void selectBgMechanic(FavBgMechanicItem bgMechanic) {
    print("Is multiselection");

    // setState(() {
    //   _allBgMechanics = [];
    // });

    // setState(() {
    //   selectedBgMechanics = [];
    // });

    final isSelected = selectedList.contains(bgMechanic);
    setState(() => isSelected
        ? selectedList.remove(bgMechanic)
        : selectedList.add(bgMechanic));

    // setState(() {
    //   widget.notifyParent();
    // });
    print("selectedList, ${selectedList.length}");
  }

  getAppBar(AppUser? userSnapshot, errorScaffoldKey) {
    var itemText = selectedList.length > 1 ? "items" : "item";

    return AppBar(
      title: Text(selectedList.isEmpty
          ? "Select favourite mechanics"
          : "${selectedList.length} $itemText selected"),
      actions: <Widget>[
        selectedList.isEmpty
            ? Container()
            : InkWell(
                onTap: () {
                  _userProvider.updateFavouriteBgMechanics(
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
