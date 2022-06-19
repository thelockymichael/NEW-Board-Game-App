// ignore_for_file: prefer_function_declarations_over_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/discover/tinder_card.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:provider/provider.dart';

class DiscoverCard extends StatefulWidget {
  final List<AppUser> people;
  final AppUser myUser;
  late List<String> ignoreSwipeIds;
  late Function personSwiped;
  late Function resetState;

  DiscoverCard({
    Key? key,
    required this.people,
    required this.myUser,
    required this.ignoreSwipeIds,
    required this.personSwiped,
    required this.resetState,
  }) : super(key: key);

  @override
  _DiscoverCard createState() => _DiscoverCard();
}

class _DiscoverCard extends State<DiscoverCard> {
  late CardProvider cardProvider;

  @override
  void initState() {
    super.initState();
    cardProvider = Provider.of<CardProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<CardProvider>(context, listen: false);

    // widget.people.forEach((user) => print(user.name));

    // provider.setUsers(widget.people);

    return cardProvider.users.isEmpty
        ? Center(
            child: Text('No more users to swipe',
                style: Theme.of(context).textTheme.headline4),
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
                      padding: const EdgeInsets.all(16),
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

  Widget buildCards() {
    print("-----------------");
    print("Build cards");

    print("cardProviders. ${cardProvider.users.last.name}");
    print("cardProviders. ${cardProvider.users.length}");
    cardProvider.users.forEach((user) => print("NAME: ${user.name}"));
// cardProvider.users.last == user
    print("IS TRUE ??? ${cardProvider.users.last == cardProvider.users[0]}");
    print("-----------------");

    return Stack(
      children: cardProvider.users
          .map((user) => TinderCard(
                user: user,
                resetState: widget.resetState,
                myUser: widget.myUser,
                isFront: cardProvider.users.last == user,
              ))
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
              shape: MaterialStateProperty.all(const CircleBorder()),
              minimumSize: MaterialStateProperty.all(const Size.square(80)),
              elevation: MaterialStateProperty.all(8),
              foregroundColor: getColor(Colors.red, Colors.white, isDislike),
              backgroundColor: getColor(Colors.white, Colors.red, isDislike),
              side: getBorder(Colors.red, Colors.white, isDislike)),
          onPressed: () {
            provider.dislike();

            widget.personSwiped(users, widget.myUser, widget.people, false);
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
            provider.like();

            widget.personSwiped(users, widget.myUser, widget.people, true);
          },
          child: const Icon(Icons.favorite, size: 46),
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
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
