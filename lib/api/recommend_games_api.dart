import 'dart:convert';

import 'package:http/http.dart' as http;

class RecommendedGamesApi {
// http://recommend.games/api/games/?ordering=-rec_rating,-bayes_rating,-avg_rating&page=1

  final String _url = "http://recommend.games/api/games/";
  // final String

  getBoardGamesData(apiUrl) async {
    http.Response response = await http.get(Uri.parse(_url + apiUrl));

    try {
      if (response.statusCode == 200) {
        return response;
      } else {
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
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
  String next;
  String? previous;
  List<Result> results;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
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

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        bggId: json["bgg_id"],
        imageUrl: List<String>.from(json["image_url"].map((x) => x)),
        year: json["year"],
        recRank: json["rec_rank"],
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


// class ResponseData {
//   int count = 0;
//   String next = "";
//   String? previous = "";
//   List<BoardGameData> results = [];

//   ResponseData(
//       int count, String next, String previous, List<BoardGameData> results) {
//     this.count = count;
//     this.next = next;
//     this.previous = previous;
//     this.results = results;
//   }

//   ResponseData.fromJson(Map<String, dynamic> json)
//       : count = json['count'],
//         next = json["next"],
//         previous = json["previous"],
//         results = List<BoardGameData>.from(
//             json["results"].map((x) => BoardGameData.fromJson(x)));

//   // results;
//   // results = json["results"];
//   // results = json["results"];

//   // ResponseData.fromJson(Map json)
//   //     : count = json['count'],
//   //       next = json["next"],
//   //       previous = json["previous"];
//   // // results = json["results"];
// }

// class BoardGameData {
//   int bggId = 0;
//   String imageUrl = "";
//   int year = 0;
//   int recRank = 0;
//   double recRating = 0;
//   int recStars = 0;
//   String name = "";

//   BoardGameData(
//     int bggId,
//     String imageUrl,
//     int year,
//     int recRank,
//     double recRating,
//     int recStarts,
//     String name,
//   ) {
//     this.bggId = 0;
//     this.imageUrl = "";
//     this.year = 0;
//     this.recRank = 0;
//     this.recRating = 0;
//     this.recStars = 0;
//     this.name = "";
//   }

//   BoardGameData.fromJson(Map json)
//       : bggId = json['bgg_id'],
//         imageUrl = json["image_url"],
//         year = json["year"],
//         recRank = json["rec_rank"],
//         recRating = json["rec_rating"],
//         recStars = json["rec_stars"],
//         name = json["name"];
// }

/**
 * 
 *     this.bggId = 0;
    this.imageUrl = "";
    this.year = 0;
    this.recRank = 0;
    this.recRating = 0;
    this.recStarts = 0;
    this.name = "";
 */