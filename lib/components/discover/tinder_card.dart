import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:provider/provider.dart';

class TinderCard extends StatefulWidget {
  final AppUser? user;
  final Function resetState;
  final AppUser? myUser;
  final bool isFront;

  const TinderCard(
      {Key? key,
      required this.user,
      required this.resetState,
      required this.myUser,
      required this.isFront})
      : super(key: key);

  @override
  _TinderCardState createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
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

          widget.resetState();
        },
      );

  Widget buildCard() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(widget.user!.profilePhotoPath),
            fit: BoxFit.cover,
            alignment: const Alignment(-0.3, 0),
          )),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.7, 1])),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                buildName(),
                SizedBox(height: 8),
                buildBGGName(),
                Spacer(),
                SizedBox(height: 8),
                buildFavGameGenres(),
                SizedBox(height: 16),
                buildStatus()
              ],
            ),
          ),
        ),
      );

  Widget buildFavGameGenres() {
    final favBoardGameGenres = widget.user!.favBoardGameGenres;

// TODO Change color if same interest as user

    if (favBoardGameGenres.isEmpty) {
      return Container();
    }

    return Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
            children: widget.user!.favBoardGameGenres.map((gameGenre) {
          return Container(
            margin: const EdgeInsets.only(right: 10, top: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.myUser!.favBoardGameGenres.contains(gameGenre)
                  ? Colors.green
                  : Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              // border: Border.all(width: 2, color: Colors.red)
            ),
            child: Text(gameGenre,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )),
          );
        }).toList()));
  }

  Widget buildName() => Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 8),
          Text(widget.user!.name,
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(
            ',',
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            '${widget.user!.age}',
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ],
      );

  Widget buildBGGName() => Row(
        children: [
          Icon(Icons.gamepad_rounded, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            "Zuxi",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Widget buildStatus() => Row(children: [
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 8),
        Text('Recently Active',
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
                padding: EdgeInsets.symmetric(horizontal: 8),
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
