import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/db/remote/firebase_storage_source.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/model/chat_with_user.dart';
import 'package:flutter_demo_01/model/user_bio_edit.dart';
import 'package:flutter_demo_01/model/user_profile_edit.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/utils/fire_auth.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';

class UserProvider extends ChangeNotifier {
  final FireAuth _authSource = FireAuth();
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  bool isLoading = false;
  AppUser _user = AppUser(
      id: "test id",
      name: "test name",
      email: "test@gmail.com",
      favBoardGameGenres: [],
      favBgMechanics: []);

  Future<AppUser> get user => _getUser();

  Future<Response> loginUser(String email, String password,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.signIn(email, password);

    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;

      SharedPreferencesUtil.setUserId(id);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }

    return response;
  }

  // RegisterUser
  Future<Response> registerUser(UserRegistration userRegistration,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.register(
        userRegistration.email, userRegistration.password);

    if (response is Success<UserCredential>) {
      String id = (response).value.user!.uid;

      AppUser user = AppUser(
          id: id,
          name: userRegistration.name,
          age: userRegistration.age,
          profilePhotoPath:
              "https://metropolia.imgix.net/tinder-profile-imgs/man_board_game.jpeg",
          favBoardGameGenres: [],
          favBgMechanics: []);

      _databaseSource.addUser(user);

      SharedPreferencesUtil.setUserId(id);
      _user = _user;
      return Response.success(user);
    }
    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<void> logoutUser() async {
    await SharedPreferencesUtil.removeUserId();
  }

  Future<AppUser> _getUser() async {
    String? id = await SharedPreferencesUtil.getUserId();

    if (id != null) {
      _user = AppUser.fromSnapshot(await _databaseSource.getUser(id));
    }

    return _user;
  }

  Future<List<ChatWithUser>> getChatsWithUser(String userId) async {
    var matches = await _databaseSource.getMatches(userId);
    List<ChatWithUser> chatWithUserList = [];

    for (var i = 0; i < matches.size; i++) {
      Match match = Match.fromSnapshot(matches.docs[i]);
      AppUser matchedUser =
          AppUser.fromSnapshot(await _databaseSource.getUser(match.id));

      String chatId = compareAndCombineIds(match.id, userId);

      Chat chat = Chat.fromSnapshot(await _databaseSource.getChat(chatId));
      ChatWithUser chatWithUser = ChatWithUser(chat, matchedUser);
      chatWithUserList.add(chatWithUser);
    }
    return chatWithUserList;
  }

  void updateUserProfilePhoto(
      String localFilePath, GlobalKey<ScaffoldState> errorScaffoldKey) async {
    isLoading = true;
    notifyListeners();
    Response<dynamic> response =
        await _storageSource.uploadUserProfilePhoto(localFilePath, _user.id);
    isLoading = false;
    if (response is Success<String>) {
      _user.profilePhotoPath = response.value;
      _databaseSource.updateUser(_user);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }
    notifyListeners();
  }

  // Future<Response> updateUserBasicInfo(UserProfileEdit userProfile,
  Future<Response> updateUserBasicInfo(
      AppUser userSnapshot,
      UserProfileEdit userProfile,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    AppUser user = AppUser(
        id: userSnapshot.id,
        name: userProfile.name,
        bggName: userProfile.bggName,
        currentLocation: userProfile.currentLocation,
        gender: userProfile.gender,
        age: userProfile.birthDay,
        bio: userSnapshot.bio,
        email: userSnapshot.email,
        favBoardGameGenres: userSnapshot.favBoardGameGenres,
        favBgMechanics: userSnapshot.favBgMechanics,
        profilePhotoPath: userSnapshot.profilePhotoPath);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<Response> updateFavouriteBoardGameGenres(
      AppUser userSnapshot,
      List<FavGenreItem> favBoardGameGenres,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    final mappedGenres = <String>[];

    for (var element in favBoardGameGenres) {
      mappedGenres.add(element.name);
    }

    AppUser user = AppUser(
        id: userSnapshot.id,
        name: userSnapshot.name,
        bggName: userSnapshot.bggName,
        currentLocation: userSnapshot.currentLocation,
        gender: userSnapshot.gender,
        age: userSnapshot.age,
        bio: userSnapshot.bio,
        email: userSnapshot.email,
        favBoardGameGenres: mappedGenres,
        favBgMechanics: userSnapshot.favBgMechanics,
        profilePhotoPath: userSnapshot.profilePhotoPath);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<Response> updateFavouriteBgMechanics(
      AppUser userSnapshot,
      List<FavBgMechanicItem> favBgMechanics,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    final mappedBgMechanics = <String>[];

    for (var element in favBgMechanics) {
      mappedBgMechanics.add(element.name);
    }

    AppUser user = AppUser(
        id: userSnapshot.id,
        name: userSnapshot.name,
        bggName: userSnapshot.bggName,
        currentLocation: userSnapshot.currentLocation,
        gender: userSnapshot.gender,
        age: userSnapshot.age,
        bio: userSnapshot.bio,
        email: userSnapshot.email,
        favBoardGameGenres: userSnapshot.favBoardGameGenres,
        favBgMechanics: mappedBgMechanics,
        profilePhotoPath: userSnapshot.profilePhotoPath);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  // Future<Response> updateUserBasicInfo(UserProfileEdit userProfile,
  Future<Response> updateUserBio(AppUser userSnapshot, UserBioEdit userBioEdit,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    // print("userProfile ${userProfile.name}");
    // print("userProfile ${userProfile.bggName}");
    // print("userProfile ${userProfile.birthDay}");
    // print("userProfile ${userProfile.currentLocation}");
    // print("userProfile ${userProfile.gender}");

    AppUser user = AppUser(
        id: userSnapshot.id,
        name: userSnapshot.name,
        bggName: userSnapshot.bggName,
        currentLocation: userSnapshot.currentLocation,
        gender: userSnapshot.gender,
        age: userSnapshot.age,
        bio: userBioEdit.bio,
        email: userSnapshot.email,
        favBoardGameGenres: userSnapshot.favBoardGameGenres,
        favBgMechanics: userSnapshot.favBgMechanics,
        profilePhotoPath: userSnapshot.profilePhotoPath);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }
}
