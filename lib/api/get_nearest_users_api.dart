import 'dart:convert';

import 'package:http/http.dart' as http;

class GetNearestUsers {
// http://recommend.games/api/games/?ordering=-rec_rating,-bayes_rating,-avg_rating&page=1

  final String _url = "http://recommend.games/api/games/";

  Future<List<BoardGameData>> getNearestUsers(
      List<String> ignoreSwipeIds, gameGenre, apiUrl) async {
    // TODO ignoreId
    // TODO myUser lat & long
    // TODO distance e.g. 20 km

    // String gameType = _returnGameType(gameGenre);

    // http.Response response =
    //     await http.get(Uri.parse(_url + gameType + apiUrl));

    // //'?game_type=5499&ordering=-rec_rating,-bayes_rating,-avg_rating&page=1');

    // if (response.statusCode == 200) {
    //   final parsedJson = json.decode(response.body);
    //   final finalResponse = ResponseData.fromJson(parsedJson);

    //   // print("JOTAIN ${finalResponse.results[0].name}");
    //   return finalResponse.results;
    //   // return response;
    // } else {
    //   throw Exception('Failed to load board games');
    // }
  }
}

ResponseData responseDataFromJson(String str) =>
    ResponseData.fromJson(json.decode(str));

String responseDataToJson(ResponseData data) => json.encode(data.toJson());

class ResponseData {
  ResponseData({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String? next;
  String? previous;
  List<BoardGameData> results;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<BoardGameData>.from(
            json["results"].map((x) => BoardGameData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class BoardGameData {
  BoardGameData({
    required this.bggId,
    required this.imageUrl,
    required this.year,
    required this.recRank,
    required this.recRating,
    required this.recStars,
    required this.name,
  });

  int bggId;
  List<String> imageUrl;
  int year;
  int recRank;
  double recRating;
  double recStars;
  String name;

  Map<String, dynamic> toMap() => {
        "bggId": bggId,
        "imageUrl": imageUrl,
        "year": year,
        "recRank": recRank,
        "recRating": recRating,
        "recStars": recStars,
        "name": name,
      };

  factory BoardGameData.fromMap(Map<String, dynamic> map) {
    return BoardGameData(
        bggId: map['bggId'] ?? 0,
        year: map['year'] ?? 0,
        recRank: map['recRank'] ?? 0,
        recRating: map['recRating'] ?? 0.0,
        recStars: map['recStars'] ?? 0.0,
        name: map['name'] ?? "0",
        imageUrl: List<String>.from(map["imageUrl"]));
  }
  // favBoardGames: List<String>.from(map["favBoardGames"]),

  factory BoardGameData.fromJson(Map<String, dynamic> json) => BoardGameData(
        bggId: json["bgg_id"],
        imageUrl: List<String>.from(json["image_url"].map((x) => x)),
        year: json["year"] ?? 0,
        recRank: json["rec_rank"] ?? 0,
        recRating: json["rec_rating"].toDouble(),
        recStars: json["rec_stars"].toDouble(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "bgg_id": bggId,
        "image_url": List<dynamic>.from(imageUrl.map((x) => x)),
        "year": year,
        "rec_rank": recRank,
        "rec_rating": recRating,
        "rec_stars": recStars,
        "name": name,
      };
}
