class FavBgThemeItem {
  final String name;

  const FavBgThemeItem({required this.name});

  factory FavBgThemeItem.fromJson(Map<String, dynamic> json) => FavBgThemeItem(
        name: json['name'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavBgThemeItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
