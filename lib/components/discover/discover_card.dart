import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/discover/tinder_card.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:provider/provider.dart';

class DiscoverCard extends StatefulWidget {
  final List<AppUser> people;
  final AppUser myUser;
  late List<String> ignoreSwipeIds;
  late Function personSwiped;
  late Function resetState;

  DiscoverCard({
    required this.people,
    required this.myUser,
    required this.ignoreSwipeIds,
    required this.personSwiped,
    required this.resetState,
  });

  @override
  _DiscoverCard createState() => _DiscoverCard();
}

class _DiscoverCard extends State<DiscoverCard> {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context, listen: false);

    provider.setUsers(widget.people);

    return provider.users.isEmpty
        ? Center(
            child: Container(
                child: Text('No more users to swipe',
                    style: Theme.of(context).textTheme.headline4)),
          )
        : Container(
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
                      padding: EdgeInsets.all(16),
                      child: Column(children: [
                        // buildLogo(),
                        const SizedBox(height: 16),
                        Expanded(child: buildCards()),
                        const SizedBox(height: 16),
                        buildButtons()
                      ])),
                )),
          );
  }

  // Widget buildLogo() => Row(
  //       children: [
  //         const SizedBox(width: 4),
  //         FittedBox(
  //           fit: BoxFit.fitWidth,
  //           child: Text(
  //             'Board Game Friends',
  //             style: TextStyle(
  //               fontSize: 36,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //         )
  //       ],
  //     );

  Widget buildCards() {
    return Stack(
      children: widget.people
          .map((user) => TinderCard(
              user: user,
              resetState: widget.resetState,
              myUser: widget.myUser,
              isFront: widget.people.last == user))
          .toList(),
    );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              minimumSize: MaterialStateProperty.all(Size.square(80)),
              elevation: MaterialStateProperty.all(8),
              foregroundColor: getColor(Colors.red, Colors.white, isDislike),
              backgroundColor: getColor(Colors.white, Colors.red, isDislike),
              side: getBorder(Colors.red, Colors.white, isDislike)),
          onPressed: () {
            final provider = Provider.of<CardProvider>(context, listen: false);

            provider.dislike();

            widget.personSwiped(
                users, widget.myUser, widget.people.last, false);
          },
          child: Icon(Icons.clear, size: 46),
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              minimumSize: MaterialStateProperty.all(Size.square(80)),
              elevation: MaterialStateProperty.all(8),
              foregroundColor: getColor(Colors.blue, Colors.white, isSuperLike),
              backgroundColor: getColor(Colors.white, Colors.blue, isSuperLike),
              side: getBorder(Colors.blue, Colors.white, isSuperLike)),
          onPressed: () {
            provider.superLike();
          },
          child: Icon(Icons.star, size: 46),
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              minimumSize: MaterialStateProperty.all(Size.square(80)),
              elevation: MaterialStateProperty.all(8),
              foregroundColor: getColor(Colors.teal, Colors.white, isLike),
              backgroundColor: getColor(Colors.white, Colors.teal, isLike),
              side: getBorder(Colors.teal, Colors.white, isLike)),
          onPressed: () {
            // personSwiped(widget.myUser, widget.people.last, false);

            provider.like();

            // people.removeLast();

            widget.personSwiped(users, widget.myUser, widget.people.last, true);
          },
          child: Icon(Icons.favorite, size: 46),
        )
      ],
    );
  }

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
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
