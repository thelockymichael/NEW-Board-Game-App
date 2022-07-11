import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/secrets/api_urls.dart';
import 'package:http/http.dart' as http;

class GetNearestUsers {
  Future<List<Result>> getNearestUsers(List<String> ignoreSwipeIds, int limit,
      AppUser myUser, int distance) async {
    // TODO git ignore my cloud function URL STRING !
    // TODO ignoreId
    // TODO limitToUsers => limit

    // TODO myUser lat & long
    // TODO distance e.g. 20 km
    http.Response response = await http.get(Uri.parse(ApiUrls
            .getNearestUserUrl +
        "ignoreId=qyQQEUgqXYRIRRai7KUesdC9gWi1&lat=60.2034712&long=24.6560609&distance=25"));

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);

      print("LOG guf ${parsedJson.toString()}");

      print(
          "LOG guf ${ApiUrls.getNearestUserUrl + "ignoreId=qyQQEUgqXYRIRRai7KUesdC9gWi1&lat=60.2034712&long=24.6560609&distance=25"}");
      // final finalResponse = ResponseData(parsedJson);

      final finalResponse = ResponseData.fromJson(parsedJson);
      print(
          "LOG guf finalResponse ${finalResponse.results[1].user.currentGeoLocation.latitude}");

      print(
          "LOG guf finalResponse ${finalResponse.results[1].user.currentGeoLocation.longitude}");

      print("LOG guf finalResponse ${finalResponse.results[1].user.name}");

      // final finalResponse = ResponseData.fromJson(parsedJson);

      // print("LOG guf ${finalResponse}");

      // return finalResponse.results;
      return [];
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
    required this.results,
  });

  List<Result> results;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.user,
    required this.distance,
  });

  ResultAppUser user;
  double distance;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        user: ResultAppUser.fromMap(json["user"]),
        distance: json["distance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toMap(),
        "distance": distance,
      };
}

class ResultAppUser {
  late String bio;
  late String name;
  late CurrentGeoLocation currentGeoLocation;

  // late String id;
  // late String email;
  // late bool setupIsCompleted;
  // late String bggName;
  // late String currentLocation;
  // late String gender;
  // late int age;
  // late List<String> profilePhotoPaths;
  // late List<String> languages;
  // late List<String> favBoardGameGenres;
  // late List<String> favBgMechanics;
  // late List<String> favBgThemes;
  // late FavBoardGames favBoardGames;

  ResultAppUser({
    required this.currentGeoLocation,
    this.name = "",
    this.bio = "",
    // required this.id,
    // required this.setupIsCompleted,
    // this.email = "",
    // this.bggName = "",
    // this.currentLocation = "",
    // this.gender = "",
    // this.age = 0,
    // required this.profilePhotoPaths,
    // required this.languages,
    // required this.favBoardGameGenres,
    // required this.favBgMechanics,
    // required this.favBgThemes,
    // required this.favBoardGames
  });

  ResultAppUser.fromSnapshot(DocumentSnapshot snapshot) {
    currentGeoLocation = snapshot["currentGeoLocation"] ?? GeoPoint(0, 0);
    name = snapshot["name"] ?? '';
    bio = snapshot["bio"] ?? '';

    // id = snapshot["id"];
    // setupIsCompleted = snapshot["setupIsCompleted"] ?? false;
    // email = snapshot["email"] ?? '';
    // bggName = snapshot["bggName"] ?? '';
    // currentLocation = snapshot["currentLocation"] ?? '';
    // gender = snapshot["gender"] ?? '';
    // age = snapshot["age"] ?? '';
    // profilePhotoPaths = List<String>.from(snapshot["profilePhotoPaths"]);
    // languages = List<String>.from(snapshot["languages"]);
    // favBoardGameGenres = List<String>.from(snapshot["favBoardGameGenres"]);
    // favBgMechanics = List<String>.from(snapshot["favBgMechanics"]);
    // favBgThemes = List<String>.from(snapshot["favBgThemes"]);
    // favBoardGames = FavBoardGames.fromMap(snapshot["favBoardGames"]);
  }

  Map<String, dynamic> toMap() => {
        "currentGeoLocation": currentGeoLocation.toMap(),
        "name": name,
        "bio": bio,

        // "id": id,
        // "setupIsCompleted": setupIsCompleted,
        // "email": email,
        // "bggName": bggName,
        // "currentLocation": currentLocation,
        // "gender": gender,
        // "age": age,
        // "profilePhotoPaths": profilePhotoPaths,
        // "languages": languages,
        // "favBoardGameGenres": favBoardGameGenres,
        // "favBgMechanics": favBgMechanics,
        // "favBgThemes": favBgThemes,
        // "favBoardGames": favBoardGames.toMap(),
      };

  factory ResultAppUser.fromMap(Map<String, dynamic> map) {
    return ResultAppUser(
      currentGeoLocation: CurrentGeoLocation.fromMap(map["currentGeoLocation"]),
      name: map["name"] ?? "",
      bio: map["bio"] ?? "",
    );

    // id: map['id'] ?? '',
    // setupIsCompleted: map['setupIsCompleted'] ?? false,
    // email: map["email"] ?? "",
    // bggName: map["bggName"] ?? "",
    // currentLocation: map["currentLocation"] ?? "",
    // // currentGeoLocation: userSnapshot.currentGeoLocation,

    // gender: map["gender"] ?? "",
    // age: map["age"] ?? "",
    // profilePhotoPaths: List<String>.from(map["profilePhotoPaths"]),
    // languages: List<String>.from(map["languages"]),
    // favBoardGameGenres: List<String>.from(map["favBoardGameGenres"]),
    // favBgMechanics: List<String>.from(map["favBgMechanics"]),
    // favBgThemes: List<String>.from(map["favBgThemes"]),
    // favBoardGames: FavBoardGames.fromMap(map["favBoardGames"]));
  }

  String toJson() => json.encode(toMap());

  factory ResultAppUser.fromJson(String source) =>
      ResultAppUser.fromMap(json.decode(source));
}

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
