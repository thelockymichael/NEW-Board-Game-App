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

class ResponseData {
  int count = 0;
  String next = "";
  String? previous = "";
  // List<BoardGameData> results = [];

  ResponseData(
    int count,
    String next,
    String previous,
    //  List<BoardGameData> results
  ) {
    this.count = count;
    this.next = next;
    this.previous = previous;
    // this.results = results;
  }

  ResponseData.fromJson(Map json)
      : count = json['count'],
        next = json["next"],
        previous = json["previous"];
  // results;
  // results = json["results"];
  // results = json["results"];

  // ResponseData.fromJson(Map json)
  //     : count = json['count'],
  //       next = json["next"],
  //       previous = json["previous"];
  // // results = json["results"];
}

class BoardGameData {
  int bggId = 0;
  String imageUrl = "";
  int year = 0;
  int recRank = 0;
  double recRating = 0;
  int recStars = 0;
  String name = "";

  BoardGameData(
    int bggId,
    String imageUrl,
    int year,
    int recRank,
    double recRating,
    int recStarts,
    String name,
  ) {
    this.bggId = 0;
    this.imageUrl = "";
    this.year = 0;
    this.recRank = 0;
    this.recRating = 0;
    this.recStars = 0;
    this.name = "";
  }

  BoardGameData.fromJson(Map json)
      : bggId = json['bgg_id'],
        imageUrl = json["image_url"],
        year = json["year"],
        recRank = json["rec_rank"],
        recRating = json["rec_rating"],
        recStars = json["rec_stars"],
        name = json["name"];
}

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