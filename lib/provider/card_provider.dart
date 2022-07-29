import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_demo_01/api/get_nearest_users_api.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/utils/utils.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  late final List<String> _ignoreSwipeIds = <String>[];

  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<ResultAppUser> _users = [];
  List<ResultAppUser> get users => _users;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  Size get size => _screenSize;

  void setUsers(List<ResultAppUser> users) {
    _users = [];
    _users = users;
  }

  Future<bool> isMatch(AppUser myUser, ResultAppUser otherUser) async {
    DocumentSnapshot swipeSnapshot =
        await _databaseSource.getSwipe(otherUser.id, myUser.id);

    // TODO Get swipe from Sanna with your id
    print("LOG FRU isMatch.id  myUser.id ${myUser.id}");
    print("LOG FRU isMatch.id  otherUser.id ${otherUser.id}");

    if (swipeSnapshot.exists) {
      // TODO If ID exists !
      print("LOG FRU Id exists");
      Swipe swipe = Swipe.fromSnapshot(swipeSnapshot);
      // TODO Return ID information
      print("LOG FRU swipe information ID: ${swipe.id} LIKED: ${swipe.liked}");

      if (swipe.liked) {
        print(
            "LOG FRU !!LIKED!! swipe information ID: ${swipe.id} LIKED: ${swipe.liked}");

        return true;
      }
    }
    return false;
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    // Update UI
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    // Update UI
    notifyListeners();
  }

  void endPosition(BuildContext context, AppUser myUser, Function refresh) {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.like:
        like(context, myUser, refresh);
        break;
      case CardStatus.dislike:
        dislike(context, myUser, refresh);
        break;
      case CardStatus.superLike:
        if (Utils.inDevelopment) {
          return resetPosition();
        }

        superLike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    // Update UI
    notifyListeners();
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    if (force) {
      const delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    } else {
      const delta = 20;

      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.superLike;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
    return null;
  }

  void like(BuildContext context, AppUser myUser, Function refresh) {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);

    personSwiped(context, myUser, true);
    _nextCard(refresh);
    notifyListeners();
  }

  void personSwiped(BuildContext context, AppUser myUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(users.last.id, isLiked));
    _ignoreSwipeIds.add(users.last.id);

    print("LOG FRU personSwiped start");
    print("LOG FRU personSwiped isLiked: ${isLiked}");
    print("LOG FRU myUser.id ${myUser.id}");
    print("LOG FRU users.last.id ${users.last.id}");

    if (isLiked) {
      if (await isMatch(myUser, users.last) == true) {
        print("LOG FRU HOW IS THIS TRUE ???");
        print("LOG FRU users.last.id ${users.last.id}");

        _databaseSource.addMatch(myUser.id, Match(users.last.id));
        _databaseSource.addMatch(users.last.id, Match(myUser.id));

        String chatId = compareAndCombineIds(myUser.id, users.last.id);

        _databaseSource.addChat(Chat(chatId, myUser.id, users.last.id, null));

        Navigator.pushNamed(context, MatchedScreen.id, arguments: {
          "my_user_id": myUser.id,
          "my_profile_photo_path": myUser.profilePhotoPaths[0],
          "other_user_profile_photo_path": users.last.profilePhotoPaths[0],
          "other_user_id": users.last.id,
          "other_user_name": users.last.name
        });
      }
    }
  }

  void dislike(BuildContext context, AppUser myUser, Function refresh) {
    print("VMK DISLIKE");
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);

    personSwiped(context, myUser, false);

    _nextCard(refresh);
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard([Function? refresh]) async {
    if (_users.isEmpty) return;

    Future.delayed(const Duration(milliseconds: 200))
        .asStream()
        .listen((event) {
      resetPosition();
      _users.removeLast();

      if (_users.isEmpty) refresh!();
    });
  }
}
