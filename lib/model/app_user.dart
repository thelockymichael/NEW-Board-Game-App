import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';

class AppUser {
  late String id;
  late String email;
  late String name;
  late String bggName;
  late String currentLocation;
  late String gender;
  late String age;
  late String profilePhotoPath;
  late String bio;
  late List<String> favBoardGameGenres;
  late List<String> favBgMechanics;
  late List<String> favBgThemes;
  late FavBoardGames favBoardGames;

  AppUser(
      {required this.id,
      this.email = "",
      this.name = "",
      this.bggName = "",
      this.currentLocation = "",
      this.gender = "",
      this.age = "",
      this.profilePhotoPath = "",
      this.bio = "",
      required this.favBoardGameGenres,
      required this.favBgMechanics,
      required this.favBgThemes,
      required this.favBoardGames});

  AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot["id"];
    email = snapshot["email"] ?? '';
    name = snapshot["name"] ?? '';
    bggName = snapshot["bggName"] ?? '';
    currentLocation = snapshot["currentLocation"] ?? '';
    gender = snapshot["gender"] ?? '';
    age = snapshot["age"] ?? '';
    profilePhotoPath = snapshot["profilePhotoPath"] ?? '';
    bio = snapshot["bio"] ?? '';
    favBoardGameGenres = List<String>.from(snapshot["favBoardGameGenres"]);
    favBgMechanics = List<String>.from(snapshot["favBgMechanics"]);
    favBgThemes = List<String>.from(snapshot["favBgThemes"]);
    // favBoardGames = List<String>.from(snapshot["favBoardGames"]);
    favBoardGames = FavBoardGames.fromMap(snapshot["favBoardGames"]);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "bggName": bggName,
        "currentLocation": currentLocation,
        "gender": gender,
        "age": age,
        "profilePhotoPath": profilePhotoPath,
        "bio": bio,
        "favBoardGameGenres": favBoardGameGenres,
        "favBgMechanics": favBgMechanics,
        "favBgThemes": favBgThemes,
        "favBoardGames": favBoardGames.toMap(),
      };

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
        id: map['id'] ?? '',
        email: map["email"] ?? "",
        name: map["name"] ?? "",
        bggName: map["bggName"] ?? "",
        currentLocation: map["currentLocation"] ?? "",
        gender: map["gender"] ?? "",
        age: map["age"] ?? "",
        profilePhotoPath: map["profilePhotoPath"] ?? "",
        bio: map["bio"] ?? "",
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
  late List<SelectedBoardGame> familyGames = [];

  FavBoardGames({
    required this.familyGames,
  });

  // FavBoardGames.fromSnapshot(DocumentSnapshot snapshot) {
  //   familyGames = snapshot["familyGames"];
  // }

  Map<String, dynamic> toMap() => {
        "familyGames": familyGames,
      };

  factory FavBoardGames.fromMap(Map<String, dynamic> map) {
    return FavBoardGames(
        familyGames: List<SelectedBoardGame>.from(map["familyGames"])
        // familyGames: map['familyGames'] ?? '',
        );
  }

  String toJson() => json.encode(toMap());

  factory FavBoardGames.fromJson(String source) =>
      FavBoardGames.fromMap(json.decode(source));
}

class SelectedBoardGame {
  late int rank;
  late BoardGameData boardGame;

  SelectedBoardGame({this.rank = 0, required this.boardGame});

  // SelectedBoardGame.fromSnapshot(DocumentSnapshot snapshot) {
  //   familyGames = snapshot["familyGames"];
  // }

  Map<String, dynamic> toMap() => {
        "rank": rank,
        "boardGame": boardGame.toMap(),
      };

  factory SelectedBoardGame.fromMap(Map<String, dynamic> map) {
    return SelectedBoardGame(
        rank: map["rank"], boardGame: BoardGameData.fromMap(map["boardGame"])
        // familyGames: map['familyGames'] ?? '',
        );
  }

  String toJson() => json.encode(toMap());

  factory SelectedBoardGame.fromJson(String source) =>
      SelectedBoardGame.fromMap(json.decode(source));
}
