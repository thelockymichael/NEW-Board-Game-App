import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/secrets/api_urls.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:http/http.dart' as http;

class GetNearestUsers {
  // Future<List<ResultAppUser>> getNearestUsers(List<String> ignoreSwipeIds, int limit,
  Future<List<ResultAppUser>> getNearestUsers(
      {required int limit,
      required AppUser myUser,
      // TODO gender
      required String gender,
      // TODO age range
      required int minAge,
      required int maxAge,
      // TODO distance
      required String distance,

      // MORE OPTIONS
      // TODO mechanics
      required List<String> mechanics,
      // TODO themes
      required List<String> themes,
      // TODO languages
      required List<String> languages,
      // TODO localities
      required List<String> localities,
      required List<String> ignoreSwipeIds}) async {
    // TODO git ignore my cloud function URL STRING !
    // TODO ignoreId
    // TODO limitToUsers => limit

    // TODO myUser lat & long
    // TODO distance e.g. 20 km

    print("LOG guf juk ${ignoreSwipeIds}");
    print("LOG guf juk defaultMechanics ${mechanics}");

    var uri = Uri(
        scheme: "https",
        host: "us-central1-board-game-app-c1a95.cloudfunctions.net",
        path: "/getNearestUsers",
        queryParameters: {
          "gender": Utils.getGender(gender.toString().toLowerCase()),
          "minAge": minAge.toString(),
          "maxAge": maxAge.toString(),
          "distance": distance.toString().toLowerCase(),
          "limit": limit.toString(),
          "lat": myUser.currentGeoLocation.latitude.toString(),
          "long": myUser.currentGeoLocation.longitude.toString(),
          "ignoreId": ignoreSwipeIds,
          // More Options
          "bgMechanics": mechanics.map((e) => e.toLowerCase()),
          "bgThemes": themes.map((e) => e.toLowerCase()),
          "languages": languages.map((e) => e.toLowerCase()),
          "localities": localities.map((e) => e.toLowerCase())
        });

    print("LOG guf juk ${uri}");

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);

      print("LOG guf ${parsedJson.toString()}");

      // final finalResponse = ResponseData(parsedJson);

      final finalResponse = ResponseData.fromJson(parsedJson);

      print("LOG guf finalResponse count ${finalResponse.count}");

      return finalResponse.results;
    } else {
      throw Exception("Failed to load users");
    }
  }
}

ResponseData responseDataFromJson(String str) =>
    ResponseData.fromJson(json.decode(str));

String responseDataToJson(ResponseData data) => json.encode(data.toJson());

class ResponseData {
  ResponseData({
    required this.count,
    required this.results,
  });
  int count;
  List<ResultAppUser> results;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        count: json["count"],
        results: List<ResultAppUser>.from(
            json["results"].map((x) => ResultAppUser.fromMap(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class ResultAppUser {
  late int distance;
  late String id;
  late String email;
  late bool setupIsCompleted;
  late String bggName;
  late String currentLocation;
  late String gender;
  late int age;
  late List<String> profilePhotoPaths;
  late List<String> languages;
  late List<String> favBoardGameGenres;
  late List<String> favBgMechanics;
  late List<String> favBgThemes;
  late FavBoardGames favBoardGames;
  late CreatedAt createdAt;
  late UpdatedAt updatedAt;
  late String bio;
  late String name;
  late CurrentGeoLocation currentGeoLocation;

  ResultAppUser({
    required this.id,
    required this.distance,
    required this.setupIsCompleted,
    this.email = "",
    this.bggName = "",
    this.currentLocation = "",
    this.gender = "",
    this.age = 0,
    required this.profilePhotoPaths,
    required this.languages,
    required this.favBoardGameGenres,
    required this.favBgMechanics,
    required this.favBgThemes,
    required this.favBoardGames,
    required this.currentGeoLocation,
    this.name = "",
    this.bio = "",
    required this.createdAt,
    required this.updatedAt,
  });

  ResultAppUser.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot["id"];
    distance = snapshot["distance"];
    createdAt = snapshot["createdAt"] ?? new Timestamp.now();
    updatedAt = snapshot["updatedAt"] ?? new Timestamp.now();
    currentGeoLocation = snapshot["currentGeoLocation"] ?? GeoPoint(0, 0);
    name = snapshot["name"] ?? '';
    bio = snapshot["bio"] ?? '';
    setupIsCompleted = snapshot["setupIsCompleted"] ?? false;
    email = snapshot["email"] ?? '';
    bggName = snapshot["bggName"] ?? '';
    currentLocation = snapshot["currentLocation"] ?? '';
    gender = snapshot["gender"] ?? '';
    age = snapshot["age"] ?? '';
    profilePhotoPaths = List<String>.from(snapshot["profilePhotoPaths"]);
    languages = List<String>.from(snapshot["languages"]);
    favBoardGameGenres = List<String>.from(snapshot["favBoardGameGenres"]);
    favBgMechanics = List<String>.from(snapshot["favBgMechanics"]);
    favBgThemes = List<String>.from(snapshot["favBgThemes"]);
    favBoardGames = FavBoardGames.fromMap(snapshot["favBoardGames"]);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "distance": distance,
        "createdAt": createdAt.toMap(),
        "updatedAt": updatedAt.toMap(),
        "currentGeoLocation": currentGeoLocation.toMap(),
        "name": name,
        "bio": bio,
        "setupIsCompleted": setupIsCompleted,
        "email": email,
        "bggName": bggName,
        "currentLocation": currentLocation,
        "gender": gender,
        "age": age,
        "profilePhotoPaths": profilePhotoPaths,
        "languages": languages,
        "favBoardGameGenres": favBoardGameGenres,
        "favBgMechanics": favBgMechanics,
        "favBgThemes": favBgThemes,
        "favBoardGames": favBoardGames.toMap(),
      };

  factory ResultAppUser.fromMap(Map<String, dynamic> map) {
    return ResultAppUser(
        distance: map["distance"] ?? 0,
        createdAt: CreatedAt.fromMap(map["createdAt"]),
        updatedAt: UpdatedAt.fromMap(map["updatedAt"]),
        currentGeoLocation:
            CurrentGeoLocation.fromMap(map["currentGeoLocation"]),
        name: map["name"] ?? "",
        bio: map["bio"] ?? "",
        id: map['id'] ?? '',
        setupIsCompleted: map['setupIsCompleted'] ?? false,
        email: map["email"] ?? "",
        bggName: map["bggName"] ?? "",
        currentLocation: map["currentLocation"] ?? "",
        gender: map["gender"] ?? "",
        age: map["age"] ?? "",
        profilePhotoPaths: List<String>.from(map["profilePhotoPaths"]),
        languages: List<String>.from(map["languages"]),
        favBoardGameGenres: List<String>.from(map["favBoardGameGenres"]),
        favBgMechanics: List<String>.from(map["favBgMechanics"]),
        favBgThemes: List<String>.from(map["favBgThemes"]),
        favBoardGames: FavBoardGames.fromMap(map["favBoardGames"]));
  }

  String toJson() => json.encode(toMap());

  factory ResultAppUser.fromJson(String source) =>
      ResultAppUser.fromMap(json.decode(source));

  // ResultAppUser user;
  // double distance;

  // factory ResultAppUser.fromJson(Map<String, dynamic> json) => ResultAppUser(
  //       user: ResultAppUser.fromMap(json["user"]),
  //       distance: json["distance"].toDouble(),
  //     );

  // Map<String, dynamic> toJson() => {
  //       "user": user.toMap(),
  //       "distance": distance,
  //     };
}

// class ResultAppUser {
//   late int distance;
//   late String id;
//   late String email;
//   late bool setupIsCompleted;
//   late String bggName;
//   late String currentLocation;
//   late String gender;
//   late int age;
//   late List<String> profilePhotoPaths;
//   late List<String> languages;
//   late List<String> favBoardGameGenres;
//   late List<String> favBgMechanics;
//   late List<String> favBgThemes;
//   late FavBoardGames favBoardGames;
//   late CreatedAt createdAt;
//   late UpdatedAt updatedAt;
//   late String bio;
//   late String name;
//   late CurrentGeoLocation currentGeoLocation;

//   ResultAppUser({
//     required this.id,
//     required this.distance,
//     required this.setupIsCompleted,
//     this.email = "",
//     this.bggName = "",
//     this.currentLocation = "",
//     this.gender = "",
//     this.age = 0,
//     required this.profilePhotoPaths,
//     required this.languages,
//     required this.favBoardGameGenres,
//     required this.favBgMechanics,
//     required this.favBgThemes,
//     required this.favBoardGames,
//     required this.currentGeoLocation,
//     this.name = "",
//     this.bio = "",
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   ResultAppUser.fromSnapshot(DocumentSnapshot snapshot) {
//     id = snapshot["id"];
//     distance = snapshot["distance"];
//     createdAt = snapshot["createdAt"] ?? new Timestamp.now();
//     updatedAt = snapshot["updatedAt"] ?? new Timestamp.now();
//     currentGeoLocation = snapshot["currentGeoLocation"] ?? GeoPoint(0, 0);
//     name = snapshot["name"] ?? '';
//     bio = snapshot["bio"] ?? '';
//     setupIsCompleted = snapshot["setupIsCompleted"] ?? false;
//     email = snapshot["email"] ?? '';
//     bggName = snapshot["bggName"] ?? '';
//     currentLocation = snapshot["currentLocation"] ?? '';
//     gender = snapshot["gender"] ?? '';
//     age = snapshot["age"] ?? '';
//     profilePhotoPaths = List<String>.from(snapshot["profilePhotoPaths"]);
//     languages = List<String>.from(snapshot["languages"]);
//     favBoardGameGenres = List<String>.from(snapshot["favBoardGameGenres"]);
//     favBgMechanics = List<String>.from(snapshot["favBgMechanics"]);
//     favBgThemes = List<String>.from(snapshot["favBgThemes"]);
//     favBoardGames = FavBoardGames.fromMap(snapshot["favBoardGames"]);
//   }

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "distance": distance,
//         "createdAt": createdAt.toMap(),
//         "updatedAt": updatedAt.toMap(),
//         "currentGeoLocation": currentGeoLocation.toMap(),
//         "name": name,
//         "bio": bio,
//         "setupIsCompleted": setupIsCompleted,
//         "email": email,
//         "bggName": bggName,
//         "currentLocation": currentLocation,
//         "gender": gender,
//         "age": age,
//         "profilePhotoPaths": profilePhotoPaths,
//         "languages": languages,
//         "favBoardGameGenres": favBoardGameGenres,
//         "favBgMechanics": favBgMechanics,
//         "favBgThemes": favBgThemes,
//         "favBoardGames": favBoardGames.toMap(),
//       };

//   factory ResultAppUser.fromMap(Map<String, dynamic> map) {
//     return ResultAppUser(
//         distance: map["distance"] ?? 0,
//         createdAt: CreatedAt.fromMap(map["createdAt"]),
//         updatedAt: UpdatedAt.fromMap(map["updatedAt"]),
//         currentGeoLocation:
//             CurrentGeoLocation.fromMap(map["currentGeoLocation"]),
//         name: map["name"] ?? "",
//         bio: map["bio"] ?? "",
//         id: map['id'] ?? '',
//         setupIsCompleted: map['setupIsCompleted'] ?? false,
//         email: map["email"] ?? "",
//         bggName: map["bggName"] ?? "",
//         currentLocation: map["currentLocation"] ?? "",
//         gender: map["gender"] ?? "",
//         age: map["age"] ?? "",
//         profilePhotoPaths: List<String>.from(map["profilePhotoPaths"]),
//         languages: List<String>.from(map["languages"]),
//         favBoardGameGenres: List<String>.from(map["favBoardGameGenres"]),
//         favBgMechanics: List<String>.from(map["favBgMechanics"]),
//         favBgThemes: List<String>.from(map["favBgThemes"]),
//         favBoardGames: FavBoardGames.fromMap(map["favBoardGames"]));
//   }

//   String toJson() => json.encode(toMap());

//   factory ResultAppUser.fromJson(String source) =>
//       ResultAppUser.fromMap(json.decode(source));
// }

class CurrentGeoLocation {
  CurrentGeoLocation({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory CurrentGeoLocation.fromMap(Map<String, dynamic> json) =>
      CurrentGeoLocation(
        latitude: json["_latitude"].toDouble(),
        longitude: json["_longitude"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "_latitude": latitude,
        "_longitude": longitude,
      };
}

class CreatedAt {
  CreatedAt({
    required this.seconds,
    required this.nanoseconds,
  });

  int seconds;
  int nanoseconds;

  factory CreatedAt.fromMap(Map<String, dynamic> json) => CreatedAt(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toMap() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };
}

class UpdatedAt {
  UpdatedAt({
    required this.seconds,
    required this.nanoseconds,
  });

  int seconds;
  int nanoseconds;

  factory UpdatedAt.fromMap(Map<String, dynamic> json) => UpdatedAt(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toMap() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };
}
