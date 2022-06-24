// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/entity/UserQuery.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/model/bg_theme.dart';
import 'package:intl/intl.dart';

class Utils {
  static int ascendingSort(FavBgMechanicItem c1, FavBgMechanicItem c2) =>
      c1.name.compareTo(c2.name);

  static List<String> bgMechanicsList = [
    "Dice Rolling",
    "Roll / Spin and Move",
    "Hand Management",
    "Set Collection",
    "Open Drafting",
    "Hexagon Grid",
    "Simulation",
    "Variable Player Powers",
    "Tile Placement",
    "Cooperative Game",
    "Memory",
    "Grid Movement",
    "Point to Point Movement",
    "Modular Board",
    "Area / Majority / Influence",
    "Auction / Bidding",
    "Simultaneous Action Selection",
    "Trading",
    "Area Movement",
    "Player Elimination",
    "Take That",
    "Pattern Building",
    "Action Points",
    "Team-Based Game",
    "Push Your Luck",
    "Pattern Recognition",
    "Solo / Solitaire Game",
    "Paper-and-Pencil",
    "Storytelling",
    "Role Playing",
    "Betting and Bluffing",
    "Deck, Bag and Pool Building",
    "Pick-up and Deliver",
    "Trick-taking",
    "Worker Placement",
    "Voting",
    "Acting",
    "Campaign / Battle Card Driven",
    "Secret Unit Deployment",
    "Scenario / Mission / Campaign Game",
    "Network and Route Building",
    "Race",
    "Stock Holding",
    "Measurement Movement",
    "Events",
    "Movement Points",
    "Action Queue",
    "Variable Set-up",
    "Square Grid",
    "Deduction",
    "Rock-Paper-Scissors",
    "Variable Phase Order",
    "Enclosure",
    "Chit-Pull System",
    "Commodity Speculation",
    "Line of Sight",
    "Real-Time",
    "Card Play Conflict Resolution",
    "Line Drawing",
    "Zone of Control",
    "Track Movement",
    "End Game Bonuses",
    "Ratio / Combat Results Table",
    "Action / Event",
    "Matching",
    "Income",
    "Deck Construction",
    "Semi-Cooperative Game",
    "Singing",
    "Hidden Roles",
    "Communication Limits",
    "Player Judge",
    "Lose a Turn",
    "Market",
    "Negotiation",
    "Contracts",
    "Connections",
    "Move Through Deck",
    "Stacking and Balancing",
    "Area-Impulse",
    "Time Track",
    "Hidden Movement",
    "Grid Coverage",
    "Turn Order: Progressive",
    "Speed Matching",
    "Chaining",
    "Critical Hits and Failures",
    "Closed Drafting",
    "Once-Per-Game Abilities",
    "Traitor Game",
    "Victory Points as Resource",
    "Re-rolling and Locking",
    "Flicking",
    "Command Cards",
    "Hidden Victory Points",
    "Die Icon Resolution",
    "Alliances",
    "Action Drafting",
    "Narrative Choice",
    "Multiple Maps",
    "Ownership",
    "Mancala",
    "Map Addition",
    "Sudden Death Ending",
    "Score-and-Reset Game",
    "Interrupts",
    "Investment",
    "Moving Multiple Units",
    "Turn Order: Stat Based",
    "Tech Trees / Tech Tracks",
    "Turn Order: Claim Action",
    "Roles with Asymmetric Information",
    "Three Dimensional Movement",
    "Resource To Move",
    "Programmed Movement",
    "Action Timer",
    "Ladder Climbing",
    "Layering",
    "Rondel",
    "Finale Ending",
    "Highest-Lowest Scoring",
    "Static Capture",
    "Action Retrieval",
    "Pieces as Map",
    "Pattern Movement",
    "Turn Order: Pass Order",
    "Bingo",
    "Stat Check Resolution",
    "Slide/Push",
    "Catch The Leader",
    "Turn Order: Random",
    "Single Loser Game",
    "Movement Template",
    "Melding and Splaying",
    "Loans",
    "Physical Removal",
    "Tug of War",
    "Map Reduction",
    "King of the Hill",
    "Bias",
    "I Cut, You Choose",
    "Legacy Game",
    "Targeted Game",
    "Map Deformation",
    "Bribery",
    "Elapsed Real Time Ending",
    "Increase Value of Unchosen Resources",
    "Kill Steal",
    "Follow",
    "Different Dice Movement",
    "Hot Potato",
    "Advantage Token",
    "Turn Order: Auction",
    "Auction: Sealed Big",
    "Minimap Resolution",
    "Predictive Bid",
    "Random Production",
    "Impulse Movement",
    "Crayon Rail System",
    "Prisoner's Dilemma",
    "Automatic Resource Growth",
    "Force Commitment",
    "Auction: Turn Order Until Pass",
    "Constrained Bidding",
    "Relative Movement",
    "Delayed Purchase",
    "Turn Order: Role Order",
    "Order Counters",
    "Induction",
    "Auction: Dutch",
    "Cube Tower",
    "Auction: Once Around",
    "Selection Order Bid",
    "Auction: Dexterity",
    "Closed Economy Auction",
    "Passed Action Token",
    "Multiple-Lot Auction",
    "Relative Movement",
    "Delayed Purchase",
    "Turn Order: Role Order",
    "Order Counters",
    "Induction",
    "Auction: Dutch",
    "Cube Tower",
    "Auction: Once Around",
    "Selection Order Bid",
    "Auction: Fixed Placement",
  ];

  static List<String> bgThemesList = [
    "Fantasy",
    "Animals",
    "Movies / TV",
    "Science Fiction",
    "Fighting",
    "Miniatures",
    "Humor",
    "Sports",
    "Racing",
    "World War II",
    "Adventure",
    "Word Game",
    "Bluffing",
    "Memory",
    "Negotiation",
    "Medieval",
    "Puzzle",
    "Exploration",
    "Real-time",
    "Nautical",
    "Ancient",
    "Book",
    "Horror",
    "Political",
    "Travel",
    "Novel-based",
    "Math",
    "Murder / Mystery",
    "Modern Warfare",
    "Transportation",
    "Comic Book / Strip",
    "Territory Building",
    "Number",
    "Space Exploration",
    "City Building",
    "Collectible Components",
    "Mythology",
    "Mature / Adult",
    "Pirates",
    "Environmental",
    "Aviation / Flight",
    "Napoleonic",
    "Religious",
    "Video Game Theme",
    "Electronic",
    "Trains",
    "American West",
    "Industry / Manufacturing",
    "World War I",
    "Farming",
    "Civilization",
    "American Civil War",
    "Music",
    "Post-Napoleonic",
    "Maze",
    "Zombies",
    "Spies/Secret Agents",
    "Reneissance",
    "Prehistoric",
    "Age of Reason",
    "Mafia",
    "Civil War",
    "Pike and Shot",
    "Medical",
    "American Revolutionary War",
    "Expansion for Base-game",
    "Vietnam War",
    "Game System",
    "Arabian",
    "American Indian Wars",
    "Korean War",
    "Fan Expansion",
  ];

  static List<String> languages = [
    "finnish",
    "swedish",
    "english",
    "russian",
    "estonian",
    "german",
    "dutch",
    "arabian",
    "somalian",
    "chinese",
    "persian",
    "vietnamese",
  ];

  static List<String> localities = [
    "espoo",
    "helsinki",
    "kajaani",
  ];
}

void showSnackBar(GlobalKey<ScaffoldState> globalKey, String message) {
  final snackBar = SnackBar(content: Text(message));
  globalKey.currentState?.hideCurrentSnackBar();
  globalKey.currentState?.showSnackBar(snackBar);
}

String compareAndCombineIds(String userID1, String userID2) {
  if (userID1.compareTo(userID2) < 0) {
    return userID2 + userID1;
  } else {
    return userID1 + userID2;
  }
}

String convertEpochMsToDateTime(int epochMs) {
  int oneDayInMs = 86400000;
  var date = DateTime.fromMillisecondsSinceEpoch(epochMs);
  int currentTimeMs = DateTime.now().millisecondsSinceEpoch;
  if ((currentTimeMs - epochMs) >= oneDayInMs) {
    return '${DateFormat.yMd().format(date)}  ${DateFormat.jm().format(date)}';
  } else {
    return DateFormat.jm().format(date);
  }
}

extension StringExtension on String {
  String capitalize() {
    List<String> strArr = split(' ');

    if (isEmpty) {
      return this;
    }

    if (strArr.length == 1) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    } else {
      List<String> moreThanOneStr = [];

      for (var element in strArr) {
        moreThanOneStr.add(
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}");
      }

      final joinedName = moreThanOneStr.join(" ");

      return joinedName;
    }
  }
}

// TODO Calculate age by using date of birth
int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();

  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;

  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;

    if (day2 > day1) {
      age--;
    }
  }

  return age;
}

Query<Map<String, dynamic>> filterSwipableUsers(
    Query<Map<String, dynamic>> queryRef, List<UserQuery> queries) {
  queries.forEach((query) {
    // 11 options

    // if (query.field.contains("age") &&
    //     query.condition.contains("isGreaterThanOrEqualTo")) {}

    // if (query.field.contains("age") &&
    //     query.condition.contains("isLessThanOrEqualTo")) {

    //     }

    switch (query.condition) {
      case "arrayContains":
        break;
      case "arrayContainsAny":
        // queryRef = queryRef.where(query.field, arrayContainsAny: query.value);
        break;

      case "isEqualTo":
        if (query.field.contains("gender")) {
          if (!query.value.contains("everyone")) {
            print("VMK dsada ${query.value}");
            if (query.value.contains("women")) {
              print("VMK women");
              queryRef = queryRef.where(query.field, isEqualTo: "female");
            } else if (query.value.contains("men")) {
              print("VMK men");
              queryRef = queryRef.where(query.field, isEqualTo: "male");
            } else if (query.value.contains("other")) {
              print("VMK other");
              queryRef = queryRef.where(query.field, isEqualTo: "other");
            }
          }
        }

        if (query.field.contains("currentLocation")) {
          print("ZXC DOES contain");
          print("ZXC DOES contain ${query.field}");
          print("ZXC DOES contain ${query.value}");

          // TODO cast as an array
          List<String> locality = query.value as List<String>;

          if (locality.isEmpty) {
            queryRef = queryRef.where(query.field, isEqualTo: "");

            return;
          }

          queryRef =
              queryRef.where(query.field, isEqualTo: locality.first.toString());
        }

        break;

      case "isGreaterThan":
        break;

      case "isGreaterThanOrEqualTo":
        print("MNK ----------------");
        print("MNK ${query.condition}");
        print("MNK ${query.field}");
        print("MNK ${query.value}");
        print("MNK ----------------");

        // queryRef =
        //     queryRef.where(query.field, isGreaterThanOrEqualTo: query.value);
        // queryRef = queryRef.where('id', whereNotIn: ignoreIds);
        // queryRef = queryRef.where(query.field, isEqualTo: "male");
        // queryRef = queryRef.where(query.field,
        //     isGreaterThanOrEqualTo: query.value.toString());

        break;

      case "isLessThan":
        break;

      case "isLessThanOrEqualTo":
        // queryRef =
        //     queryRef.where(query.field, isLessThanOrEqualTo: query.value);
        // queryRef =
        //     queryRef.where(query.field, isLessThanOrEqualTo: query.value);

        break;

      case "isNotEqualTo":
        break;

      case "isNull":
        break;

      case "whereIn":
        // queryRef = queryRef.where(query.field, whereIn: query.value);
        break;

      case "whereNotIn":
        break;

      default:
        break;
    }
  });

  return queryRef;
}
