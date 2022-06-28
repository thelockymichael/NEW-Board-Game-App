import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';

class AppUser {
  late String id;
  late String email;
  late bool setupIsCompleted;
  late String name;
  late String bggName;
  late String currentLocation;
  late String gender;
  late int age;
  late String profilePhotoPath;
  late String bio;
  late List<String> languages;
  late List<String> favBoardGameGenres;
  late List<String> favBgMechanics;
  late List<String> favBgThemes;
  late FavBoardGames favBoardGames;

  AppUser(
      {required this.id,
      required this.setupIsCompleted,
      this.email = "",
      this.name = "",
      this.bggName = "",
      this.currentLocation = "",
      this.gender = "",
      this.age = 0,
      this.profilePhotoPath = "",
      this.bio = "",
      required this.languages,
      required this.favBoardGameGenres,
      required this.favBgMechanics,
      required this.favBgThemes,
      required this.favBoardGames});

  AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot["id"];
    setupIsCompleted = snapshot["setupIsCompleted"] ?? false;
    email = snapshot["email"] ?? '';
    name = snapshot["name"] ?? '';
    bggName = snapshot["bggName"] ?? '';
    currentLocation = snapshot["currentLocation"] ?? '';
    gender = snapshot["gender"] ?? '';
    age = snapshot["age"] ?? '';
    profilePhotoPath = snapshot["profilePhotoPath"] ?? '';
    bio = snapshot["bio"] ?? '';
    languages = List<String>.from(snapshot["languages"]);
    favBoardGameGenres = List<String>.from(snapshot["favBoardGameGenres"]);
    favBgMechanics = List<String>.from(snapshot["favBgMechanics"]);
    favBgThemes = List<String>.from(snapshot["favBgThemes"]);
    // favBoardGames = List<String>.from(snapshot["favBoardGames"]);
    favBoardGames = FavBoardGames.fromMap(snapshot["favBoardGames"]);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "setupIsCompleted": setupIsCompleted,
        "email": email,
        "name": name,
        "bggName": bggName,
        "currentLocation": currentLocation,
        "gender": gender,
        "age": age,
        "profilePhotoPath": profilePhotoPath,
        "bio": bio,
        "languages": languages,
        "favBoardGameGenres": favBoardGameGenres,
        "favBgMechanics": favBgMechanics,
        "favBgThemes": favBgThemes,
        "favBoardGames": favBoardGames.toMap(),
      };

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
        id: map['id'] ?? '',
        setupIsCompleted: map['setupIsCompleted'] ?? false,
        email: map["email"] ?? "",
        name: map["name"] ?? "",
        bggName: map["bggName"] ?? "",
        currentLocation: map["currentLocation"] ?? "",
        gender: map["gender"] ?? "",
        age: map["age"] ?? "",
        profilePhotoPath: map["profilePhotoPath"] ?? "",
        bio: map["bio"] ?? "",
        languages: List<String>.from(map["languages"]),
        favBoardGameGenres: List<String>.from(map["favBoardGameGenres"]),
        favBgMechanics: List<String>.from(map["favBgMechanics"]),
        favBgThemes: List<String>.from(map["favBgThemes"]),
        favBoardGames: FavBoardGames.fromMap(map["favBoardGames"])
        // favBoardGames: List<String>.from(map["favBoardGames"]),
        );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));
}

class FavBoardGames {
  late List<SelectedBoardGame> familyGames;
  late List<SelectedBoardGame> dexterityGames;
  late List<SelectedBoardGame> partyGames;
  late List<SelectedBoardGame> thematicGames;
  late List<SelectedBoardGame> strategyGames;
  late List<SelectedBoardGame> abstractGames;
  late List<SelectedBoardGame> warGames;

  FavBoardGames(
      {required this.familyGames,
      required this.dexterityGames,
      required this.partyGames,
      required this.thematicGames,
      required this.strategyGames,
      required this.abstractGames,
      required this.warGames});

  Map<String, dynamic> toMap() => {
        "familyGames": List<dynamic>.from(familyGames.map((x) => x.toMap())),
        "dexterityGames":
            List<dynamic>.from(dexterityGames.map((x) => x.toMap())),
        "partyGames": List<dynamic>.from(partyGames.map((x) => x.toMap())),
        "thematicGames":
            List<dynamic>.from(thematicGames.map((x) => x.toMap())),
        "strategyGames":
            List<dynamic>.from(strategyGames.map((x) => x.toMap())),
        "abstractGames":
            List<dynamic>.from(abstractGames.map((x) => x.toMap())),
        "warGames": List<dynamic>.from(warGames.map((x) => x.toMap())),
      };

  factory FavBoardGames.fromMap(Map<String, dynamic> map) {
    return FavBoardGames(
        familyGames: List<SelectedBoardGame>.from(
            map["familyGames"].map((x) => SelectedBoardGame.fromMap(x))),
        dexterityGames: List<SelectedBoardGame>.from(
            map["dexterityGames"].map((x) => SelectedBoardGame.fromMap(x))),
        partyGames: List<SelectedBoardGame>.from(
            map["partyGames"].map((x) => SelectedBoardGame.fromMap(x))),
        thematicGames: List<SelectedBoardGame>.from(
            map["thematicGames"].map((x) => SelectedBoardGame.fromMap(x))),
        strategyGames: List<SelectedBoardGame>.from(
            map["strategyGames"].map((x) => SelectedBoardGame.fromMap(x))),
        abstractGames: List<SelectedBoardGame>.from(
            map["abstractGames"].map((x) => SelectedBoardGame.fromMap(x))),
        warGames: List<SelectedBoardGame>.from(
            map["warGames"].map((x) => SelectedBoardGame.fromMap(x))));
  }

  String toJson() => json.encode(toMap());

  factory FavBoardGames.fromJson(String source) =>
      FavBoardGames.fromMap(json.decode(source));
}

class SelectedBoardGame {
  late int rank;
  late BoardGameData boardGame;

  SelectedBoardGame({this.rank = 0, required this.boardGame});

  Map<String, dynamic> toMap() => {
        "rank": rank.toInt(),
        "boardGame": boardGame.toMap(),
      };

  factory SelectedBoardGame.fromMap(Map<String, dynamic> map) {
    return SelectedBoardGame(
        rank: map["rank"] ?? 0,
        boardGame: BoardGameData.fromMap(map["boardGame"]));
  }
}
