import 'dart:async';
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

enum TutorialCardStatus { like, dislike, superLike }

class TutorialCardProvider extends ChangeNotifier {
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<String> _tutorialCards = [];
  List<String> get tutorialCards => _tutorialCards;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  Size get size => _screenSize;

  void setTutorialCards(List<String> tutorialCards) {
    _tutorialCards = [];
    _tutorialCards = tutorialCards;
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

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case TutorialCardStatus.like:
        like();
        break;
      case TutorialCardStatus.dislike:
        dislike();
        break;
      case TutorialCardStatus.superLike:
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

  TutorialCardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    if (force) {
      const delta = 100;

      if (x >= delta) {
        return TutorialCardStatus.like;
      } else if (x <= -delta) {
        return TutorialCardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return TutorialCardStatus.superLike;
      }
    } else {
      const delta = 20;

      if (y <= -delta * 2 && forceSuperLike) {
        return TutorialCardStatus.superLike;
      } else if (x >= delta) {
        return TutorialCardStatus.like;
      } else if (x <= -delta) {
        return TutorialCardStatus.dislike;
      }
    }
    return null;
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);

    _nextCard();
    notifyListeners();
  }

  void dislike() {
    print("VMK DISLIKE");
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
    if (_tutorialCards.isEmpty) return;

    Future.delayed(const Duration(milliseconds: 200))
        .asStream()
        .listen((event) {
      resetPosition();
      _tutorialCards.removeLast();

      // if (_tutorialCards.isEmpty) refresh!();
    });
  }
}
