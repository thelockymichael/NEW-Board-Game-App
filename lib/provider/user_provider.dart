import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
import 'package:flutter_demo_01/db/entity/PositionLocality.dart';
import 'package:flutter_demo_01/db/entity/chat.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/db/entity/match.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/db/remote/firebase_storage_source.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/model/bg_theme.dart';
import 'package:flutter_demo_01/model/chat_with_user.dart';
import 'package:flutter_demo_01/model/user_bio_edit.dart';
import 'package:flutter_demo_01/model/user_profile_edit.dart';
import 'package:flutter_demo_01/model/user_registration.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/screens/setup_screens/first_name_bgg_page.dart';
import 'package:flutter_demo_01/utils/fire_auth.dart';
import 'package:flutter_demo_01/utils/shared_preferences_utils.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:geolocator/geolocator.dart';

class UserProvider extends ChangeNotifier {
  final FireAuth _authSource = FireAuth();
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  bool isLoading = false;
  AppUser _user = Utils.user;

  Future<AppUser> get user => _getUser();

  Future<Response> loginUser(
      String email, String password, BuildContext context) async {
    Response<dynamic> response = await _authSource.signIn(email, password);

    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;

      SharedPreferencesUtil.setUserId(id);

      var _snapshotUser = await _databaseSource.getUser(id);

      AppUser _user = AppUser.fromSnapshot(_snapshotUser);

      print("LOG IS SETUP COMPLETED ??? ${_user.setupIsCompleted}");
      if (_user.setupIsCompleted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(MainNavigation.id, (route) => false);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const FirstNameBggPage(),
          ),
        );
      }
    } else if (response is Error) {
      showSnackBar(context, response.message);
    }

    return response;
  }

  // RegisterUser
  Future<Response> registerUser(
      UserRegistration userRegistration, BuildContext context) async {
    Response<dynamic> response = await _authSource.register(
        userRegistration.email, userRegistration.password);

    if (response is Success<UserCredential>) {
      String id = (response).value.user!.uid;

      AppUser user = AppUser(
          id: id,
          createdAt: new Timestamp.now(),
          updatedAt: Timestamp.now(),
          setupIsCompleted: false,
          // currentGeoLocation: GeoPoint(0, 0),
          name: userRegistration.name,
          email: userRegistration.email,
          age: userRegistration.age,
          profilePhotoPaths: [
            "",
            "",
            "",
            "",
            "",
            "",
          ],
          languages: [],
          favBoardGameGenres: [],
          favBgMechanics: [],
          favBgThemes: [],
          favBoardGames: FavBoardGames(familyGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], dexterityGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], partyGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], thematicGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], strategyGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], abstractGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ], warGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                bggId: 0,
                imageUrl: [""],
                name: "",
                recRank: 0,
                recRating: 0.0,
                recStars: 0.0,
                year: 0,
              ),
            )
          ]));
      _databaseSource.addUser(user);

      SharedPreferencesUtil.setUserId(id);

      _user = _user;
      return Response.success(user);
    }
    if (response is Error) showSnackBar(context, response.message);
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

  Future<Response> updateUserProfilePhoto(
      String localFilePath, BuildContext context, int imageNumber) async {
    isLoading = true;
    notifyListeners();
    Response<dynamic> response = await _storageSource.uploadUserProfilePhoto(
        localFilePath, _user.id, imageNumber);
    isLoading = false;
    if (response is Success<String>) {
      _user.profilePhotoPaths[imageNumber] = response.value;

      _databaseSource.updateUser(_user);
      notifyListeners();

      return Response.success(response.value);
    } else if (response is Error) {
      notifyListeners();
      showSnackBar(context, response.message);

      return response;
    }
    notifyListeners();
    return response;
  }

  Future<Response> deleteUserProfilePhoto(
      BuildContext context, int imageNumber) async {
    isLoading = true;
    notifyListeners();
    Response<dynamic> response =
        await _storageSource.deleteUserProfilePhoto(_user.id, imageNumber);
    isLoading = false;
    if (response is Success<String>) {
      _user.profilePhotoPaths[imageNumber] = response.value;

      _databaseSource.updateUser(_user);
      notifyListeners();

      return Response.success(response.value);
    } else if (response is Error) {
      notifyListeners();
      showSnackBar(context, response.message);

      return response;
    }
    notifyListeners();
    return response;
  }

  Future<Response> updateFirstNameAndBggUsername(AppUser userSnapshot,
      UserRegistration userProfile, BuildContext context) async {
    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userProfile.firstName,
      bggName: userProfile.bggUsername,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userSnapshot.gender,
      age: userSnapshot.age,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateDateOfBirth(AppUser userSnapshot,
      UserRegistration userProfile, BuildContext context) async {
    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userSnapshot.name,
      bggName: userSnapshot.bggName,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userSnapshot.gender,
      age: userProfile.birthDate,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateGender(AppUser userSnapshot,
      UserRegistration userProfile, BuildContext context) async {
    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userSnapshot.name,
      bggName: userSnapshot.bggName,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userProfile.gender.toLowerCase(),
      age: userSnapshot.age,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  /* END User Setup */

  Future<Response> updateUserBasicInfo(AppUser userSnapshot,
      UserProfileEdit userProfile, BuildContext context) async {
    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userProfile.name.toLowerCase(),
      bggName: userProfile.bggName,
      currentLocation: userSnapshot.currentLocation.toLowerCase(),
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userProfile.gender.toLowerCase(),
      age: userProfile.dateOfBirth,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateFavouriteBoardGameGenres(AppUser userSnapshot,
      List<FavGenreItem> favBoardGameGenres, BuildContext context) async {
    final mappedGenres = <String>[];

    for (var element in favBoardGameGenres) {
      mappedGenres.add(element.name);
    }

    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userSnapshot.name,
      bggName: userSnapshot.bggName,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userSnapshot.gender,
      age: userSnapshot.age,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: mappedGenres,
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateFavouriteBgMechanics(AppUser userSnapshot,
      List<FavBgMechanicItem> favBgMechanics, BuildContext context) async {
    final mappedBgMechanics = <String>[];

    for (var element in favBgMechanics) {
      mappedBgMechanics.add(element.name);
    }

    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userSnapshot.name,
      bggName: userSnapshot.bggName,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userSnapshot.gender,
      age: userSnapshot.age,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: mappedBgMechanics,
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateFavouriteBgThemes(AppUser userSnapshot,
      List<FavBgThemeItem> favBgThemes, BuildContext context) async {
    final mappedBgThemes = <String>[];

    for (var element in favBgThemes) {
      mappedBgThemes.add(element.name);
    }

    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userSnapshot.name,
      bggName: userSnapshot.bggName,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userSnapshot.gender,
      age: userSnapshot.age,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: mappedBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateBgMechanicsAndThemes(
      AppUser userSnapshot,
      List<String> favBgMechanics,
      List<String> favBgThemes,
      BuildContext context) async {
    final mappedBgMechanics = <String>[];
    final mappedBgThemes = <String>[];

    for (var element in favBgMechanics) {
      mappedBgMechanics.add(element);
    }

    for (var element in favBgThemes) {
      mappedBgThemes.add(element);
    }

    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userSnapshot.name,
      bggName: userSnapshot.bggName,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userSnapshot.gender,
      age: userSnapshot.age,
      bio: userSnapshot.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: mappedBgMechanics,
      favBgThemes: mappedBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateUserBio(AppUser userSnapshot, UserBioEdit userBioEdit,
      BuildContext context) async {
    AppUser user = AppUser(
      id: userSnapshot.id,
      createdAt: userSnapshot.createdAt,
      updatedAt: userSnapshot.updatedAt,
      setupIsCompleted: userSnapshot.setupIsCompleted,
      name: userSnapshot.name,
      bggName: userSnapshot.bggName,
      currentLocation: userSnapshot.currentLocation,
      currentGeoLocation: userSnapshot.currentGeoLocation,
      gender: userSnapshot.gender,
      age: userSnapshot.age,
      bio: userBioEdit.bio,
      email: userSnapshot.email,
      languages: userSnapshot.languages,
      favBoardGameGenres: userSnapshot.favBoardGameGenres,
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPaths: userSnapshot.profilePhotoPaths,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  List<SelectedBoardGame> _returnUpdatedGenreBoardGames(
      List<SelectedBoardGame> genreBoardGames,
      int boardGameRank,
      BoardGameData boardGameData) {
    List<SelectedBoardGame> updateBoardGames = [];

    for (var i = 0; i < genreBoardGames.length; i++) {
      if (genreBoardGames[i].rank == boardGameRank) {
        updateBoardGames.add(
            SelectedBoardGame(rank: boardGameRank, boardGame: boardGameData));
        continue;
      }

      updateBoardGames.add(SelectedBoardGame(
          rank: genreBoardGames[i].rank,
          boardGame: genreBoardGames[i].boardGame));
    }
    return updateBoardGames;
    // print("whole str ${boardGameGenre}");
    // updateFavBoardGames.familyGames = updateBoardGames;
  }

  // final String
  FavBoardGames _returnFavBoardGames(AppUser userSnapshot,
      BoardGameData boardGameData, int boardGameRank, String boardGameGenre) {
    // List<SelectedBoardGame> updateBoardGames = [];

    var familyGames = userSnapshot.favBoardGames.familyGames;
    var dexterityGames = userSnapshot.favBoardGames.dexterityGames;
    var partyGames = userSnapshot.favBoardGames.partyGames;
    var thematicGames = userSnapshot.favBoardGames.thematicGames;
    var strategyGames = userSnapshot.favBoardGames.strategyGames;
    var abstractGames = userSnapshot.favBoardGames.abstractGames;
    var warGames = userSnapshot.favBoardGames.warGames;

    FavBoardGames updateFavBoardGames = FavBoardGames(
        familyGames: familyGames,
        dexterityGames: dexterityGames,
        partyGames: partyGames,
        thematicGames: thematicGames,
        strategyGames: strategyGames,
        abstractGames: abstractGames,
        warGames: warGames);

    print("gameGenre $boardGameGenre");

    switch (boardGameGenre) {
      case "family games":
        updateFavBoardGames.familyGames = _returnUpdatedGenreBoardGames(
            familyGames, boardGameRank, boardGameData);
        break;

      case "dexterity games":
        updateFavBoardGames.dexterityGames = _returnUpdatedGenreBoardGames(
            dexterityGames, boardGameRank, boardGameData);
        break;

      case "party games":
        print("whole str $boardGameGenre");
        updateFavBoardGames.partyGames = _returnUpdatedGenreBoardGames(
            partyGames, boardGameRank, boardGameData);
        break;

      case "abstracts":
        print("whole str $boardGameGenre");
        updateFavBoardGames.abstractGames = _returnUpdatedGenreBoardGames(
            abstractGames, boardGameRank, boardGameData);
        break;
      // https://recommend.games/api/games/?game_type=4666&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1
      case "thematic":
        print("whole str $boardGameGenre");
        updateFavBoardGames.thematicGames = _returnUpdatedGenreBoardGames(
            thematicGames, boardGameRank, boardGameData);
        break;

      case "strategy":
        print("whole str $boardGameGenre");
        updateFavBoardGames.strategyGames = _returnUpdatedGenreBoardGames(
            strategyGames, boardGameRank, boardGameData);
        break;
// https://recommend.games/api/games/?game_type=5496&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1
      case "wargames":
        updateFavBoardGames.warGames = _returnUpdatedGenreBoardGames(
            warGames, boardGameRank, boardGameData);
        print("whole str $boardGameGenre");
        break;

      // https://recommend.games/api/games/?game_type=4664&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1

      default:
        print("whole str $boardGameGenre");
        break;
    }

    return updateFavBoardGames;
  }

  Future<Response> updateFavouriteBoardGamesByGenre(
      AppUser userSnapshot,
      BoardGameData boardGameData,
      int boardGameRank,
      String boardGameGenre,
      BuildContext context) async {
    final updateFavBoardGames = _returnFavBoardGames(
        userSnapshot, boardGameData, boardGameRank, boardGameGenre);

    AppUser user = AppUser(
        id: userSnapshot.id,
        createdAt: userSnapshot.createdAt,
        updatedAt: userSnapshot.updatedAt,
        setupIsCompleted: userSnapshot.setupIsCompleted,
        name: userSnapshot.name,
        bggName: userSnapshot.bggName,
        currentLocation: userSnapshot.currentLocation,
        currentGeoLocation: userSnapshot.currentGeoLocation,
        gender: userSnapshot.gender,
        age: userSnapshot.age,
        bio: userSnapshot.bio,
        email: userSnapshot.email,
        languages: userSnapshot.languages,
        favBoardGameGenres: userSnapshot.favBoardGameGenres,
        favBgMechanics: userSnapshot.favBgMechanics,
        favBgThemes: userSnapshot.favBgThemes,
        profilePhotoPaths: userSnapshot.profilePhotoPaths,
        favBoardGames: updateFavBoardGames);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateGeoLocationAndLocality(AppUser userSnapshot,
      Position geoLocation, String address, BuildContext context) async {
    GeoPoint point = GeoPoint(geoLocation.latitude, geoLocation.longitude);

    print("LOG geoPoint latitude ${point.latitude}");
    print("LOG geoPoint longitude ${point.longitude}");

    AppUser user = AppUser(
        id: userSnapshot.id,
        createdAt: userSnapshot.createdAt,
        updatedAt: userSnapshot.updatedAt,
        setupIsCompleted: userSnapshot.setupIsCompleted,
        name: userSnapshot.name,
        bggName: userSnapshot.bggName,
        currentLocation: address,
        currentGeoLocation: point,
        gender: userSnapshot.gender,
        age: userSnapshot.age,
        bio: userSnapshot.bio,
        email: userSnapshot.email,
        languages: userSnapshot.languages,
        favBoardGameGenres: userSnapshot.favBoardGameGenres,
        favBgMechanics: userSnapshot.favBgMechanics,
        favBgThemes: userSnapshot.favBgThemes,
        profilePhotoPaths: userSnapshot.profilePhotoPaths,
        favBoardGames: userSnapshot.favBoardGames);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateCurrentLocationAddress(
      AppUser userSnapshot, String address, BuildContext context) async {
    AppUser user = AppUser(
        id: userSnapshot.id,
        createdAt: userSnapshot.createdAt,
        updatedAt: userSnapshot.updatedAt,
        setupIsCompleted: userSnapshot.setupIsCompleted,
        name: userSnapshot.name,
        bggName: userSnapshot.bggName,
        currentLocation: address,
        currentGeoLocation: userSnapshot.currentGeoLocation,
        gender: userSnapshot.gender,
        age: userSnapshot.age,
        bio: userSnapshot.bio,
        email: userSnapshot.email,
        languages: userSnapshot.languages,
        favBoardGameGenres: userSnapshot.favBoardGameGenres,
        favBgMechanics: userSnapshot.favBgMechanics,
        favBgThemes: userSnapshot.favBgThemes,
        profilePhotoPaths: userSnapshot.profilePhotoPaths,
        favBoardGames: userSnapshot.favBoardGames);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateCurrentGeoLocation(
      AppUser userSnapshot, Position geoLocation, BuildContext context) async {
    GeoPoint point = GeoPoint(geoLocation.latitude, geoLocation.longitude);

    print("LOG geoPoint latitude ${point.latitude}");
    print("LOG geoPoint longitude ${point.longitude}");

    AppUser user = AppUser(
        id: userSnapshot.id,
        createdAt: userSnapshot.createdAt,
        updatedAt: userSnapshot.updatedAt,
        setupIsCompleted: userSnapshot.setupIsCompleted,
        name: userSnapshot.name,
        bggName: userSnapshot.bggName,
        currentLocation: userSnapshot.currentLocation,
        currentGeoLocation: point,
        gender: userSnapshot.gender,
        age: userSnapshot.age,
        bio: userSnapshot.bio,
        email: userSnapshot.email,
        languages: userSnapshot.languages,
        favBoardGameGenres: userSnapshot.favBoardGameGenres,
        favBgMechanics: userSnapshot.favBgMechanics,
        favBgThemes: userSnapshot.favBgThemes,
        profilePhotoPaths: userSnapshot.profilePhotoPaths,
        favBoardGames: userSnapshot.favBoardGames);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }

  Future<Response> updateSetupCompleted(
      bool setupIsCompleted,
      PositionLocality positionLocality,
      AppUser appUser,
      BuildContext context) async {
    GeoPoint point = GeoPoint(positionLocality.position.latitude,
        positionLocality.position.longitude);

    AppUser user = AppUser(
        id: appUser.id,
        createdAt: appUser.createdAt,
        updatedAt: appUser.updatedAt,
        setupIsCompleted: setupIsCompleted,
        name: appUser.name,
        bggName: appUser.bggName,
        currentLocation: positionLocality.placemark.locality!,
        currentGeoLocation: point,
        gender: appUser.gender,
        age: appUser.age,
        bio: appUser.bio,
        email: appUser.email,
        languages: appUser.languages,
        favBoardGameGenres: appUser.favBoardGameGenres,
        favBgMechanics: appUser.favBgMechanics,
        favBgThemes: appUser.favBgThemes,
        profilePhotoPaths: appUser.profilePhotoPaths,
        favBoardGames: appUser.favBoardGames);

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(context, response.message);
    return response;
  }
}
