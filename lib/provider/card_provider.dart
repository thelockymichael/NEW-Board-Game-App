import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:uuid/uuid.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  late final List<String> _ignoreSwipeIds = <String>[];

  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<AppUser> _users = [];
  List<AppUser> get users => _users;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  Size get size => _screenSize;

  void setUsers(List<AppUser> users) {
    _users = [];
    _users = users;

    // Update UI
    // notifyListeners();
  }

  void personSwiped(BuildContext context, List<AppUser> users, AppUser myUser,
      AppUser otherUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));
    _ignoreSwipeIds.add(otherUser.id);
    // widget.ignoreSwipeIds.add(otherUser.id);

    if (isLiked = true) {
      if (await isMatch(myUser, otherUser) == true) {
        _databaseSource.addMatch(myUser.id, Match(otherUser.id));
        _databaseSource.addMatch(otherUser.id, Match(myUser.id));

        String chatId = compareAndCombineIds(myUser.id, otherUser.id);

        print("New chat id $chatId");

        _databaseSource.addChat(Chat(chatId, myUser.id, otherUser.id, null));

        Navigator.pushNamed(context, MatchedScreen.id, arguments: {
          "my_user_id": myUser.id,
          "my_profile_photo_path": myUser.profilePhotoPath,
          "other_user_profile_photo_path": otherUser.profilePhotoPath,
          "other_user_id": otherUser.id,
          "other_user_name": otherUser.name
        });
      }
    }

    // setState(() {});
  }

  Future<bool> isMatch(AppUser myUser, AppUser otherUser) async {
    DocumentSnapshot swipeSnapshot =
        await _databaseSource.getSwipe(otherUser.id, myUser.id);

    if (swipeSnapshot.exists) {
      Swipe swipe = Swipe.fromSnapshot(swipeSnapshot);

      if (swipe.liked) {
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

  void specialLike(BuildContext context, List<AppUser> users, AppUser myUser,
      AppUser last, bool isLiked) {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _specialNextCard(context, users, myUser, last, isLiked);

    // personSwiped(context, users, myUser, users.last, true);

    notifyListeners();
  }

  void specialDislike(BuildContext context, List<AppUser> users, AppUser myUser,
      AppUser last, bool isLiked) {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _specialNextCard(context, users, myUser, last, isLiked);

    notifyListeners();
  }

  Future _specialNextCard(BuildContext context, List<AppUser> users,
      AppUser myUser, AppUser last, bool isLiked) async {
    if (_users.isEmpty) return;

    personSwiped(context, users, myUser, users.last, isLiked);
    await Future.delayed(const Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
  }

  void endPosition(BuildContext context, AppUser myUser) {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.like:
        // personSwiped(context, users, myUser, users.last, true);
        specialLike(context, users, myUser, users.last, true);
        break;
      case CardStatus.dislike:
        // dislike();
        specialDislike(context, users, myUser, users.last, false);
        break;
      case CardStatus.superLike:
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

  // void like(BuildContext context, AppUser myUser) {
  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    // personSwiped(context, users, myUser, users.last, true);

    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard() async {
    if (_users.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
  }
}
