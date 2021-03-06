class FavBgMechanicItem {
  final String name;

  const FavBgMechanicItem({required this.name});

  factory FavBgMechanicItem.fromJson(Map<String, dynamic> json) =>
      FavBgMechanicItem(
        name: json['name'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavBgMechanicItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
