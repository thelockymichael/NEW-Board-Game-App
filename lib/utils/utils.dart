// ignore_for_file: deprecated_member_use
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/api/recommend_games_api.dart';
import 'package:flutter_demo_01/db/entity/UserQuery.dart';
import 'package:flutter_demo_01/db/entity/swipe.dart';
import 'package:flutter_demo_01/db/remote/firebase_database_source.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:intl/intl.dart';
import 'dart:math' show asin, cos, pow, sqrt;

class Utils {
  static FirebaseDatabaseSource databaseSource = FirebaseDatabaseSource();

  // TODO 28.7.2022 IMPORTANT !!!
  static bool appUserTesting = false;

  // TODO 28.7.2022 IMPORTANT !!!
  static bool inDevelopment = true;

  static int ascendingSort(FavBgMechanicItem c1, FavBgMechanicItem c2) =>
      c1.name.compareTo(c2.name);
  static bool testingNewRegistration = true;

  static Future cacheImage(BuildContext context, String urlImage) {
    return precacheImage(new AssetImage(urlImage), context);
  }

  static Future cacheNetworkImage(BuildContext context, String urlImage) {
    return precacheImage(CachedNetworkImageProvider(urlImage), context);
  }

  static Future createFiftyUsers() async {
    // print("LOG ${doubleInRange(random, 20, 60)}");

    int amount = 50;

    List<String> randomNames = [
      "Jaska",
      "Kalle",
      "Sanna",
      "Suvi",
      "Mervi",
      "Kalevi",
      "Elena",
      "Mirja",
      "Salla",
      "Sanni"
    ];

    for (var i = 0; i <= amount; i++) {
      // TODO 1. Random name
      // TODO 2. Random currentGeoLocation, latitude & longitude

      // Timestamp

// 1. DateTime
      Random intRandom = Random();

      int year = intInRange(intRandom, 1981, 2021);

      int day = intInRange(intRandom, 1, 31);
      int month = intInRange(intRandom, 1, 12);

      int createdAtYear = intInRange(intRandom, 1970, 1980);
      int createdAtDay = intInRange(intRandom, 1, 31);
      int createdAtMonth = intInRange(intRandom, 1, 12);

      DateTime dateTime = new DateTime(
        year,
        month,
        day,
      );
      DateTime createdAtDateTime = new DateTime(
        createdAtYear,
        createdAtMonth,
        createdAtDay,
      );
      Timestamp timestamp = Timestamp.fromDate(dateTime);
      Timestamp createdAtTimestamp = Timestamp.fromDate(createdAtDateTime);
      // END Timestamp
      Random doubleRandom = Random();

      double lat = doubleInRange(doubleRandom, 20, 60);
      double long = doubleInRange(doubleRandom, 20, 60);
      GeoPoint point = GeoPoint(lat, long);

      // TODO Generate random pictures
      // TODO Random number
      Random randomPics = Random();

      List<String> pics = [];
      int createPic = intInRange(randomPics, 600, 800);

      for (var i = 0; i < 6; i++) {
        pics.add("https://i.pravatar.cc/${createPic.toString()}");
      }

      randomNames.shuffle();

      // TODO languages
      Random randomLanguage = Random();

      List<String> languages = [];
      int createLanguage = intInRange(randomLanguage, 0, 6);

      for (var i = 0; i < 6; i++) {
        pics.add(Utils.languages[createLanguage]);
      }

      // TODO favBoardGameGenres

      Random randomGameGenre = Random();

      List<String> gameGenres = [];
      int createGameGenre = intInRange(randomGameGenre, 0, 6);

      // for (var i = 0; i < 6; i++) {
      //   pics.add(Utils[createGameGenre]);
      // }

      // TODO favBgMechanics

      // TODO favBgThemes

      // TODO locality
      AppUser user = AppUser(
          id: "${i}",
          createdAt: createdAtTimestamp,
          updatedAt: timestamp,
          setupIsCompleted: false,
          currentGeoLocation: point,
          name: "${randomNames[0]}",
          email: "${randomNames[0]}@gmail.com",
          languages: [],
          favBoardGameGenres: [],
          favBgMechanics: [],
          favBgThemes: [],
          profilePhotoPaths: [
            pics[0],
            pics[1],
            pics[2],
            pics[3],
            pics[4],
            pics[5]
          ],
          favBoardGames: FavBoardGames(familyGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                  bggId: 266192,
                  imageUrl: [
                    "https://cf.geekdo-images.com/yLZJCVLlIx4c7eJEWUNJ7w__original/img/cI782Zis9cT66j2MjSHKJGnFPNw=/0x0/filters:format(jpeg)/pic4458123.jpg"
                  ],
                  name: "Wingspan",
                  recRank: 19,
                  recRating: 21.5874,
                  recStars: 5.0,
                  year: 1876),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                  bggId: 266192,
                  imageUrl: [
                    "https://cf.geekdo-images.com/yLZJCVLlIx4c7eJEWUNJ7w__original/img/cI782Zis9cT66j2MjSHKJGnFPNw=/0x0/filters:format(jpeg)/pic4458123.jpg"
                  ],
                  name: "Wingspan",
                  recRank: 19,
                  recRating: 21.5874,
                  recStars: 5.0,
                  year: 1876),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                  bggId: 266192,
                  imageUrl: [
                    "https://cf.geekdo-images.com/yLZJCVLlIx4c7eJEWUNJ7w__original/img/cI782Zis9cT66j2MjSHKJGnFPNw=/0x0/filters:format(jpeg)/pic4458123.jpg"
                  ],
                  name: "Wingspan",
                  recRank: 19,
                  recRating: 21.5874,
                  recStars: 5.0,
                  year: 1876),
            ),
          ], dexterityGames: [
            SelectedBoardGame(
              rank: 1,
              boardGame: BoardGameData(
                  bggId: 266192,
                  imageUrl: [
                    "https://cf.geekdo-images.com/yLZJCVLlIx4c7eJEWUNJ7w__original/img/cI782Zis9cT66j2MjSHKJGnFPNw=/0x0/filters:format(jpeg)/pic4458123.jpg"
                  ],
                  name: "Wingspan",
                  recRank: 19,
                  recRating: 21.5874,
                  recStars: 5.0,
                  year: 1876),
            ),
            SelectedBoardGame(
              rank: 2,
              boardGame: BoardGameData(
                  bggId: 266192,
                  imageUrl: [
                    "https://cf.geekdo-images.com/yLZJCVLlIx4c7eJEWUNJ7w__original/img/cI782Zis9cT66j2MjSHKJGnFPNw=/0x0/filters:format(jpeg)/pic4458123.jpg"
                  ],
                  name: "Wingspan",
                  recRank: 19,
                  recRating: 21.5874,
                  recStars: 5.0,
                  year: 1876),
            ),
            SelectedBoardGame(
              rank: 3,
              boardGame: BoardGameData(
                  bggId: 266192,
                  imageUrl: [
                    "https://cf.geekdo-images.com/yLZJCVLlIx4c7eJEWUNJ7w__original/img/cI782Zis9cT66j2MjSHKJGnFPNw=/0x0/filters:format(jpeg)/pic4458123.jpg"
                  ],
                  name: "Wingspan",
                  recRank: 19,
                  recRating: 21.5874,
                  recStars: 5.0,
                  year: 1876),
            ),
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

      databaseSource.addSwipedUser(user.id, Swipe("appUserTesting", true));

      databaseSource.addUser(user);
    }
  }

  static getGender(String gender) {
    switch (gender) {
      case "women":
        return 'female';
      case "men":
        return 'male';
      case "everyone":
        return 'everyone';
      case "other":
        return 'other';
      default:
        return 'everyone';
    }
  }

  static double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  static int intInRange(Random source, int min, int max) =>
      min + source.nextInt(max - min);

  static String stockUserProfileUrl =
      "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/dummy-photos%2Fdummy_placeholder.jpg?alt=media&token=21a05460-362d-4691-a4a9-78b6ff18228e";
  static List<String> userDistance = [
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40",
    "41",
    "42",
    "43",
    "44",
    "45",
    "46",
    "47",
    "48",
    "49",
    "50",
    "51",
    "52",
    "53",
    "54",
    "55",
    "56",
    "57",
    "58",
    "59",
    "61",
    "62",
    "63",
    "64",
    "65",
    "66",
    "67",
    "68",
    "69",
    "70",
    "71",
    "72",
    "73",
    "74",
    "75",
    "76",
    "77",
    "78",
    "79",
    "80",
    "81",
    "82",
    "83",
    "84",
    "85",
    "86",
    "87",
    "88",
    "89",
    "90",
    "91",
    "92",
    "93",
    "94",
    "95",
    "96",
    "97",
    "98",
    "99",
    "100",
    "101",
    "102",
    "103",
    "104",
    "105",
    "106",
    "107",
    "108",
    "109",
    "110",
    "111",
    "112",
    "113",
    "114",
    "115",
    "116",
    "117",
    "118",
    "119",
    "120",
    "121",
    "122",
    "123",
    "124",
    "125",
    "126",
    "127",
    "128",
    "129",
    "130",
    "131",
    "132",
    "133",
    "134",
    "135",
    "136",
    "137",
    "138",
    "139",
    "140",
    "141",
    "142",
    "143",
    "144",
    "145",
    "146",
    "147",
    "148",
    "149",
    "150",
    "151",
    "152",
    "153",
    "154",
    "155",
    "156",
    "157",
    "158",
    "159",
    "160",
    "Whole country"
  ];
  static List<String> bgMechanicsList = [
    "dice rolling",
    "roll / spin and move",
    "hand management",
    "set collection",
    "open drafting",
    "hexagon grid",
    "simulation",
    "variable player powers",
    "tile placement",
    "cooperative game",
    "memory",
    "grid movement",
    "point to point movement",
    "modular board",
    "area / majority / influence",
    "auction / bidding",
    "simultaneous action selection",
    "trading",
    "area movement",
    "player elimination",
    "take that",
    "pattern building",
    "action points",
    "team-based game",
    "push your luck",
    "pattern recognition",
    "solo / solitaire game",
    "paper-and-pencil",
    "storytelling",
    "role playing",
    "betting and bluffing",
    "deck, bag and pool building",
    "pick-up and deliver",
    "trick-taking",
    "worker placement",
    "voting",
    "acting",
    "campaign / battle card driven",
    "secret unit deployment",
    "scenario / mission / campaign game",
    "network and route building",
    "race",
    "stock holding",
    "measurement movement",
    "events",
    "movement points",
    "action queue",
    "variable set-up",
    "square grid",
    "deduction",
    "rock-paper-scissors",
    "variable phase order",
    "enclosure",
    "chit-pull system",
    "commodity speculation",
    "line of sight",
    "real-time",
    "card play conflict resolution",
    "line drawing",
    "zone of control",
    "track movement",
    "end game bonuses",
    "ratio / combat results table",
    "action / event",
    "matching",
    "income",
    "deck construction",
    "semi-cooperative game",
    "singing",
    "hidden roles",
    "communication limits",
    "player judge",
    "lose a turn",
    "market",
    "negotiation",
    "contracts",
    "connections",
    "move through deck",
    "stacking and balancing",
    "area-impulse",
    "time track",
    "hidden movement",
    "grid coverage",
    "turn order: progressive",
    "speed matching",
    "chaining",
    "critical hits and failures",
    "closed drafting",
    "once-per-game abilities",
    "traitor game",
    "victory points as resource",
    "re-rolling and locking",
    "flicking",
    "command cards",
    "hidden victory points",
    "die icon resolution",
    "alliances",
    "action drafting",
    "narrative choice",
    "multiple maps",
    "ownership",
    "mancala",
    "map addition",
    "sudden death ending",
    "score-and-reset game",
    "interrupts",
    "investment",
    "moving multiple units",
    "turn order: stat based",
    "tech trees / tech tracks",
    "turn order: claim action",
    "roles with asymmetric information",
    "three dimensional movement",
    "resource to move",
    "programmed movement",
    "action timer",
    "ladder climbing",
    "layering",
    "rondel",
    "finale ending",
    "highest-lowest scoring",
    "static capture",
    "action retrieval",
    "pieces as map",
    "pattern movement",
    "turn order: pass order",
    "bingo",
    "stat check resolution",
    "slide/push",
    "catch the leader",
    "turn order: random",
    "single loser game",
    "movement template",
    "melding and splaying",
    "loans",
    "physical removal",
    "tug of war",
    "map reduction",
    "king of the hill",
    "bias",
    "i cut, you choose",
    "legacy game",
    "targeted game",
    "map deformation",
    "bribery",
    "elapsed real time ending",
    "increase value of unchosen resources",
    "kill steal",
    "follow",
    "different dice movement",
    "hot potato",
    "advantage token",
    "turn order: auction",
    "auction: sealed big",
    "minimap resolution",
    "predictive bid",
    "random production",
    "impulse movement",
    "crayon rail system",
    "prisoner's dilemma",
    "automatic resource growth",
    "force commitment",
    "auction: turn order until pass",
    "constrained bidding",
    "relative movement",
    "delayed purchase",
    "turn order: role order",
    "order counters",
    "induction",
    "auction: dutch",
    "cube tower",
    "auction: once around",
    "selection order bid",
    "auction: dexterity",
    "closed economy auction",
    "passed action token",
    "multiple-lot auction",
    "relative movement",
    "delayed purchase",
    "turn order: role order",
    "order counters",
    "induction",
    "auction: dutch",
    "cube tower",
    "auction: once around",
    "selection order bid",
    "auction: fixed placement",
  ];

  static List<String> bgThemesList = [
    "fantasy",
    "animals",
    "movies / tv",
    "science fiction",
    "fighting",
    "miniatures",
    "humor",
    "sports",
    "racing",
    "world war ii",
    "adventure",
    "word game",
    "bluffing",
    "memory",
    "negotiation",
    "medieval",
    "puzzle",
    "exploration",
    "real-time",
    "nautical",
    "ancient",
    "book",
    "horror",
    "political",
    "travel",
    "novel-based",
    "math",
    "murder / mystery",
    "modern warfare",
    "transportation",
    "comic book / strip",
    "territory building",
    "number",
    "space exploration",
    "city building",
    "collectible components",
    "mythology",
    "mature / adult",
    "pirates",
    "environmental",
    "aviation / flight",
    "napoleonic",
    "religious",
    "video game theme",
    "electronic",
    "trains",
    "american west",
    "industry / manufacturing",
    "world war i",
    "farming",
    "civilization",
    "american civil war",
    "music",
    "post-napoleonic",
    "maze",
    "zombies",
    "spies/secret agents",
    "reneissance",
    "prehistoric",
    "age of reason",
    "mafia",
    "civil war",
    "pike and shot",
    "medical",
    "american revolutionary war",
    "expansion for base-game",
    "vietnam war",
    "game system",
    "arabian",
    "american indian wars",
    "korean war",
    "fan expansion",
  ];

  static List<String> languages = [
    "finnish",
    "swedish",
    "danish",
    "norwegian",
    "english",
    "russian",
    "estonian",
    "german",
    "dutch",
    "arabic",
    "mandarin",
    "japanese",
    "somalian",
    "persian",
    "vietnamese",
  ];

  static List<String> localities = [
    "Alajärvi",
    "Alavieska",
    "Alavus",
    "Asikkala",
    "Askola",
    "Aura",
    "Akaa",
    "Brändö",
    "Eckerö",
    "Enonkoski",
    "Enontekiö",
    "Espoo",
    "Eura",
    "Eurajoki",
    "Evijärvi",
    "Finström",
    "Forssa",
    "Föglö",
    "Geta",
    "Haapajärvi",
    "Haapavesi",
    "Hailuoto",
    "Halsua",
    "Hamina",
    "Hammarland",
    "Hankasalmi",
    "Hanko",
    "Harjavalta",
    "Hartola",
    "Hattula",
    "Hausjärvi",
    "Heinävesi",
    "Helsinki",
    "Vantaa",
    "Hirvensalmi",
    "Hollola",
    "Honkajoki",
    "Huittinen",
    "Humppila",
    "Hyrynsalmi",
    "Hyvinkää",
    "Hämeenkyrö",
    "Hämeenlinna",
    "Heinola",
    "Ii",
    "Iisalmi",
    "Iitti",
    "Ikaalinen",
    "Ilmajoki",
    "Ilomantsi",
    "Inari",
    "Inkoo",
    "Isojoki",
    "Isokyrö",
    "Imatra",
    "Jalasjärvi",
    "Janakkala",
    "Joensuu",
    "Jokioinen",
    "Jomala",
    "Joroinen",
    "Joutsa",
    "Juankoski",
    "Juuka",
    "Juupajoki",
    "Juva",
    "Jyväskylä",
    "Jämijärvi",
    "Jämsä",
    "Järvenpää",
    "Kaarina",
    "Kaavi",
    "Kajaani",
    "Kalajoki",
    "Kangasala",
    "Kangasniemi",
    "Kankaanpää",
    "Kannonkoski",
    "Kannus",
    "Karijoki",
    "Karkkila",
    "Karstula",
    "Karvia",
    "Kaskinen",
    "Kauhajoki",
    "Kauhava",
    "Kauniainen",
    "Kaustinen",
    "Keitele",
    "Kemi",
    "Keminmaa",
    "Kempele",
    "Kerava",
    "Keuruu",
    "Kihniö",
    "Kinnula",
    "Kirkkonummi",
    "Kitee",
    "Kittilä",
    "Kiuruvesi",
    "Kivijärvi",
    "Kokemäki",
    "Kokkola",
    "Kolari",
    "Konnevesi",
    "Kontiolahti",
    "Korsnäs",
    "Hämeenkoski",
    "Koski Tl",
    "Kotka",
    "Kouvola",
    "Kristiinankaupunki",
    "Kruunupyy",
    "Kuhmo",
    "Kuhmoinen",
    "Kumlinge",
    "Kuopio",
    "Kuortane",
    "Kurikka",
    "Kustavi",
    "Kuusamo",
    "Outokumpu",
    "Kyyjärvi",
    "Kärkölä",
    "Kärsämäki",
    "Kökar",
    "Köyliö",
    "Kemijärvi",
    "Kemiönsaari",
    "Lahti",
    "Laihia",
    "Laitila",
    "Lapinlahti",
    "Lappajärvi",
    "Lappeenranta",
    "Lapinjärvi",
    "Lapua",
    "Laukaa",
    "Lavia",
    "Lemi",
    "Lemland",
    "Lempäälä",
    "Leppävirta",
    "Lestijärvi",
    "Lieksa",
    "Lieto",
    "Liminka",
    "Liperi",
    "Loimaa",
    "Loppi",
    "Loviisa",
    "Luhanka",
    "Lumijoki",
    "Lumparland",
    "Luoto",
    "Luumäki",
    "Luvia",
    "Lohja",
    "Parainen",
    "Maalahti",
    "Maaninka",
    "Maarianhamina",
    "Marttila",
    "Masku",
    "Merijärvi",
    "Merikarvia",
    "Miehikkälä",
    "Mikkeli",
    "Muhos",
    "Multia",
    "Muonio",
    "Mustasaari",
    "Muurame",
    "Mynämäki",
    "Myrskylä",
    "Mäntsälä",
    "Mäntyharju",
    "Mänttä-Vilppula",
    "Naantali",
    "Nakkila",
    "Nastola",
    "Nivala",
    "Nokia",
    "Nousiainen",
    "Nurmes",
    "Nurmijärvi",
    "Närpiö",
    "Orimattila",
    "Oripää",
    "Orivesi",
    "Oulainen",
    "Oulu",
    "Padasjoki",
    "Paimio",
    "Paltamo",
    "Parikkala",
    "Parkano",
    "Pelkosenniemi",
    "Perho",
    "Pertunmaa",
    "Petäjävesi",
    "Pieksämäki",
    "Pielavesi",
    "Pietarsaari",
    "Pedersören kunta",
    "Pihtipudas",
    "Pirkkala",
    "Polvijärvi",
    "Pomarkku",
    "Pori",
    "Pornainen",
    "Posio",
    "Pudasjärvi",
    "Pukkila",
    "Punkalaidun",
    "Puolanka",
    "Puumala",
    "Pyhtää",
    "Pyhäjoki",
    "Pyhäjärvi",
    "Pyhäntä",
    "Pyhäranta",
    "Pälkäne",
    "Pöytyä",
    "Porvoo",
    "Raahe",
    "Raisio",
    "Rantasalmi",
    "Ranua",
    "Rauma",
    "Rautalampi",
    "Rautavaara",
    "Rautjärvi",
    "Reisjärvi",
    "Riihimäki",
    "Ristijärvi",
    "Rovaniemi",
    "Ruokolahti",
    "Ruovesi",
    "Rusko",
    "Rääkkylä",
    "Raasepori",
    "Saarijärvi",
    "Salla",
    "Salo",
    "Saltvik",
    "Sauvo",
    "Savitaipale",
    "Savonlinna",
    "Savukoski",
    "Seinäjoki",
    "Sievi",
    "Siikainen",
    "Siikajoki",
    "Siilinjärvi",
    "Simo",
    "Sipoo",
    "Siuntio",
    "Sodankylä",
    "Soini",
    "Somero",
    "Sonkajärvi",
    "Sotkamo",
    "Sottunga",
    "Sulkava",
    "Sund",
    "Suomussalmi",
    "Suonenjoki",
    "Sysmä",
    "Säkylä",
    "Vaala",
    "Sastamala",
    "Siikalatva",
    "Taipalsaari",
    "Taivalkoski",
    "Taivassalo",
    "Tammela",
    "Tampere",
    "Tarvasjoki",
    "Tervo",
    "Tervola",
    "Teuva",
    "Tohmajärvi",
    "Toholampi",
    "Toivakka",
    "Tornio",
    "Turku",
    "Pello",
    "Tuusniemi",
    "Tuusula",
    "Tyrnävä",
    "Ulvila",
    "Urjala",
    "Utajärvi",
    "Utsjoki",
    "Uurainen",
    "Uusikaarlepyy",
    "Uusikaupunki",
    "Vaasa",
    "Valkeakoski",
    "Valtimo",
    "Varkaus",
    "Vehmaa",
    "Vesanto",
    "Vesilahti",
    "Veteli",
    "Vieremä",
    "Vihti",
    "Viitasaari",
    "Vimpeli",
    "Virolahti",
    "Virrat",
    "Vårdö",
    "Vöyri",
    "Ylitornio",
    "Ylivieska",
    "Ylöjärvi",
    "Ypäjä",
    "Ähtäri",
    "Äänekoski"
  ];

  // Stock User profile
  static String userProfileIcon =
      "https://firebasestorage.googleapis.com/v0/b/board-game-app-c1a95.appspot.com/o/dummy-photos%2Fdummy_placeholder.jpg?alt=media&token=21a05460-362d-4691-a4a9-78b6ff18228e";

  static AppUser user = AppUser(
      id: "test id",
      createdAt: new Timestamp.now(),
      updatedAt: new Timestamp.now(),
      setupIsCompleted: false,
      name: "test name",
      email: "test@gmail.com",
      languages: [],
      favBoardGameGenres: [],
      favBgMechanics: [],
      favBgThemes: [],
      profilePhotoPaths: ["", "", "", "", "", ""],
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

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  /// Rounds [n] to the nearest multiple of [multiple].
  static int roundToMultiple(int n, int multiple) {
    assert(n >= 0);
    assert(multiple > 0);
    return (n + (multiple ~/ 2)) ~/ multiple * multiple;
  }

  static int roundToMostSignificantDigit(int n) {
    assert(n >= 0);
    var numDigits = n.toString().length;
    var magnitude = pow(10, numDigits - 1) as int;
    return roundToMultiple(n, magnitude);
  }
}

void showSnackBar(BuildContext context, String message) {
  // final snackBar = SnackBar(content: Text(message));
  // globalKey.currentState?.hideCurrentSnackBar();
  // globalKey.currentState?.showSnackBar(snackBar);

  final snackBar = SnackBar(
    backgroundColor: Colors.red,
    duration: Duration(seconds: 7),
    content: Text(message, style: TextStyle(fontSize: 18)),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String compareAndCombineIds(String userID1, String userID2) {
  if (userID1.compareTo(userID2) < 0) {
    return userID2 + userID1;
  } else {
    return userID1 + userID2;
  }
}

String convertEpochMsToDateTime(int epochMs) {
  int oneDayInMs = 86400000;
  var date = DateTime.fromMillisecondsSinceEpoch(epochMs);
  int currentTimeMs = DateTime.now().millisecondsSinceEpoch;
  if ((currentTimeMs - epochMs) >= oneDayInMs) {
    return '${DateFormat("dd/MM/yyyy").format(date)}  ${DateFormat.jm().format(date)}';
  } else {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}

int convertToEpoch(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch;
}

String formatDateTime(DateTime? date) {
  return DateFormat("dd/MM/yyyy").format(date!);
}

String convertToDateOfBirth(int epochMs) {
  var date = DateTime.fromMillisecondsSinceEpoch(epochMs);
  return '${DateFormat("dd/MM/yyyy").format(date)}';
}

String convertToAge(int epochMs) {
  var date = DateTime.fromMillisecondsSinceEpoch(epochMs);

  int diff = DateTime.now().year - date.year;

  return diff.toString();
}

DateTime convertToDateTime(int epochMs) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(epochMs);

  return date;
}

extension TextStyleX on TextStyle {
  /// A method to underline a text with a customizable [distance] between the text
  /// and underline. The [color], [thickness] and [style] can be set
  /// as the decorations of a [TextStyle].
  TextStyle underlined({
    Color? color,
    double distance = 1,
    double thickness = 1,
    TextDecorationStyle style = TextDecorationStyle.solid,
  }) {
    return copyWith(
      shadows: [
        Shadow(
          color: this.color ?? Colors.black,
          offset: Offset(0, -distance),
        )
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationThickness: thickness,
      decorationColor: color ?? this.color,
      decorationStyle: style,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    List<String> strArr = split(' ');

    if (isEmpty) {
      return this;
    }

    if (strArr.length == 1) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    } else {
      List<String> moreThanOneStr = [];

      for (var element in strArr) {
        moreThanOneStr.add(
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}");
      }

      final joinedName = moreThanOneStr.join(" ");

      return joinedName;
    }
  }
}

// int calculateAge(DateTime birthDate) {
//   DateTime currentDate = DateTime.now();

//   int age = currentDate.year - birthDate.year;
//   int month1 = currentDate.month;
//   int month2 = birthDate.month;

//   if (month2 > month1) {
//     age--;
//   } else if (month1 == month2) {
//     int day1 = currentDate.day;
//     int day2 = birthDate.day;

//     if (day2 > day1) {
//       age--;
//     }
//   }

//   return age;
// }

Query<Map<String, dynamic>> filterSwipableUsers(
    Query<Map<String, dynamic>> queryRef, List<UserQuery> queries) {
  queries.forEach((query) {
    // 11 options

    // if (query.field.contains("age") &&
    //     query.condition.contains("isGreaterThanOrEqualTo")) {}

    // if (query.field.contains("age") &&
    //     query.condition.contains("isLessThanOrEqualTo")) {

    //     }

    switch (query.condition) {
      case "arrayContains":
        break;
      case "arrayContainsAny":
        // queryRef = queryRef.where(query.field, arrayContainsAny: query.value);
        break;

      case "isEqualToGender":
        if (!query.value.contains("everyone")) {
          print("VMK dsada ${query.value}");
          if (query.value.contains("women")) {
            print("VMK women");

            queryRef = queryRef.where(query.field, isEqualTo: "female");
          } else if (query.value.contains("men")) {
            print("VMK men");
            queryRef = queryRef.where(query.field, isEqualTo: "male");
          } else if (query.value.contains("other")) {
            print("VMK other");
            queryRef = queryRef.where(query.field, isEqualTo: "other");
          }
        }
        break;

      case "isEqualToCurrentLocation":
        List<String> locality = query.value as List<String>;

        if (locality.isNotEmpty) {
          queryRef =
              queryRef.where(query.field, isEqualTo: locality.first.toString());
        }

        break;

      case "isGreaterThan":
        break;

      case "isGreaterThanOrEqualTo":
        print("MNK ----------------");
        print("MNK ${query.condition}");
        print("MNK ${query.field}");
        print("MNK ${query.value}");
        print("MNK ----------------");

        // queryRef =
        //     queryRef.where(query.field, isGreaterThanOrEqualTo: query.value);
        // queryRef = queryRef.where('id', whereNotIn: ignoreIds);
        // queryRef = queryRef.where(query.field, isEqualTo: "male");
        // queryRef = queryRef.where(query.field,
        //     isGreaterThanOrEqualTo: query.value.toString());

        break;

      case "isLessThan":
        break;

      case "isLessThanOrEqualTo":
        // queryRef =
        //     queryRef.where(query.field, isLessThanOrEqualTo: query.value);
        // queryRef =
        //     queryRef.where(query.field, isLessThanOrEqualTo: query.value);

        break;

      case "isNotEqualTo":
        break;

      case "isNull":
        break;

      case "whereIn":
        // queryRef = queryRef.where(query.field, whereIn: query.value);
        break;

      case "whereNotIn":
        break;

      default:
        break;
    }
  });

  return queryRef;
}
