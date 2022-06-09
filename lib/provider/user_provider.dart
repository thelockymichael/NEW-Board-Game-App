import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
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
            recRating: 0,
            recStars: 0,
            year: 0,
          ),
        )
      ]));

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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
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
                recRating: 0,
                recStars: 0,
                year: 0,
              ),
            )
          ]));
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
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPath: userSnapshot.profilePhotoPath,
      favBoardGames: userSnapshot.favBoardGames,
    );

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
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPath: userSnapshot.profilePhotoPath,
      favBoardGames: userSnapshot.favBoardGames,
    );

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
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPath: userSnapshot.profilePhotoPath,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<Response> updateFavouriteBgThemes(
      AppUser userSnapshot,
      List<FavBgThemeItem> favBgThemes,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    final mappedBgThemes = <String>[];

    for (var element in favBgThemes) {
      mappedBgThemes.add(element.name);
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
      favBgMechanics: userSnapshot.favBgMechanics,
      favBgThemes: mappedBgThemes,
      profilePhotoPath: userSnapshot.profilePhotoPath,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<Response> updateBgMechanicsAndThemes(
      AppUser userSnapshot,
      List<FavBgMechanicItem> favBgMechanics,
      List<FavBgThemeItem> favBgThemes,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    final mappedBgMechanics = <String>[];
    final mappedBgThemes = <String>[];

    for (var element in favBgMechanics) {
      mappedBgMechanics.add(element.name);
    }

    for (var element in favBgThemes) {
      mappedBgThemes.add(element.name);
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
      favBgThemes: mappedBgThemes,
      profilePhotoPath: userSnapshot.profilePhotoPath,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<Response> updateUserBio(AppUser userSnapshot, UserBioEdit userBioEdit,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
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
      favBgThemes: userSnapshot.favBgThemes,
      profilePhotoPath: userSnapshot.profilePhotoPath,
      favBoardGames: userSnapshot.favBoardGames,
    );

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
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
    var abstractGames = userSnapshot.favBoardGames.abstractGames;
    var warGames = userSnapshot.favBoardGames.warGames;

    FavBoardGames updateFavBoardGames = FavBoardGames(
        familyGames: familyGames,
        dexterityGames: dexterityGames,
        partyGames: partyGames,
        thematicGames: thematicGames,
        abstractGames: abstractGames,
        warGames: warGames);

    print("gameGenre ${boardGameGenre}");

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
        print("whole str ${boardGameGenre}");
        updateFavBoardGames.partyGames = _returnUpdatedGenreBoardGames(
            partyGames, boardGameRank, boardGameData);
        break;

      case "abstracts":
        print("whole str ${boardGameGenre}");
        updateFavBoardGames.abstractGames = _returnUpdatedGenreBoardGames(
            abstractGames, boardGameRank, boardGameData);
        break;
      // https://recommend.games/api/games/?game_type=4666&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1
      case "thematic & eurogames":
        print("whole str ${boardGameGenre}");
        updateFavBoardGames.thematicGames = _returnUpdatedGenreBoardGames(
            thematicGames, boardGameRank, boardGameData);
        break;
// https://recommend.games/api/games/?game_type=5496&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1
      case "wargames":
        updateFavBoardGames.warGames = _returnUpdatedGenreBoardGames(
            warGames, boardGameRank, boardGameData);
        print("whole str ${boardGameGenre}");
        break;

      // https://recommend.games/api/games/?game_type=4664&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1

      default:
        print("whole str ${boardGameGenre}");
        break;
    }

    return updateFavBoardGames;
  }

  Future<Response> updateFavouriteBoardGamesByGenre(
      AppUser userSnapshot,
      BoardGameData boardGameData,
      int boardGameRank,
      String boardGameGenre,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    List<SelectedBoardGame> temp = [];

    // userSnapshot.favBoardGames.

    // TODO
    // 1. Add item if DOES NOT EXIST
    // 2. If ITEM DOES EXIST => DO NOT ADD ITEM

    // TODO 1. Family Games
    // TODO 2. Dexterity Games

    final updateFavBoardGames = _returnFavBoardGames(
        userSnapshot, boardGameData, boardGameRank, boardGameGenre);
    // var familyGames = userSnapshot.favBoardGames.familyGames;

    // for (var i = 0; i < familyGames.length; i++) {
    //   if (familyGames[i].rank == boardGameData) {
    //     temp.add(SelectedBoardGame(rank: boardGameRank, boardGame: boardGameData));
    //   }
    // }

    // var familyGames = userSnapshot.favBoardGames.familyGames;

    // for (var i = 0; i < familyGames.length; i++) {
    //   if (familyGames[i].rank == boardGameRank) {
    //     temp.add(
    //         SelectedBoardGame(rank: boardGameRank, boardGame: boardGameData));
    //     continue;
    //   }

    //   temp.add(SelectedBoardGame(
    //       rank: familyGames[i].rank, boardGame: familyGames[i].boardGame));
    // }

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
        favBgMechanics: userSnapshot.favBgMechanics,
        favBgThemes: userSnapshot.favBgThemes,
        profilePhotoPath: userSnapshot.profilePhotoPath,
        favBoardGames: updateFavBoardGames);

    // print("AppUser ${user.favBoardGames.familyGames}");
    // user.favBoardGames.familyGames.forEach((element) {
    //   print("AppUser ${element.rank}");
    // });
    // favBoardGames:
    // {
    //  familyGames: [
    //  {
    //    rank: 1,
    //    boardGame: { BoardGameData }
    //  }
    // ],
    // }

    Response<dynamic> response = await _databaseSource.updateUser(user);

    if (response is Success<String>) {
      return Response.success(user);
    }

    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }
}
