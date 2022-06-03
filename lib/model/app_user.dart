import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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
      required this.favBoardGameGenres});

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
        "favBoardGameGenres": favBoardGameGenres
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
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));
}
