class FavBgMechanicItem {
  final String name;
  // final String nativeName;
  // final String code;

  const FavBgMechanicItem({required this.name
      // @required this.nativeName,
      // @required this.code,
      });

  factory FavBgMechanicItem.fromJson(Map<String, dynamic> json) =>
      FavBgMechanicItem(
        name: json['name'],
        // code: json['code'],
        // nativeName: json['native'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavBgMechanicItem &&
          runtimeType == other.runtimeType &&
          name == other.name;
  // nativeName == other.nativeName &&
  // code == other.code;

  @override
  int get hashCode => name.hashCode;
}

//  nativeName.hashCode ^ code.hashCode;
