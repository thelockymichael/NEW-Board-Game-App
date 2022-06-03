import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
  static final String name = 'name';
}

class User {
  final String idUser;
  final String name;
  final String urlAvatar;

  const User({
    @required this.idUser,
    @required this.name,
    @required this.urlAvatar,
    // required this.lastMessageTime,
  });

  User copyWith({
    String idUser,
    String name,
    String urlAvatar,
    // required DateTime lastMessageTime,
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        // lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        idUser: json['idUser'],
        name: json['name'],
        urlAvatar: json['urlAvatar'],
        // lastMessageTime: Utils.toDateTime(json['lastMessageTime'])!,
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        // 'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
