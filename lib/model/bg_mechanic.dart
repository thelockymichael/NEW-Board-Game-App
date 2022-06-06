class BgMechanic {
  final String name;
  // final String nativeName;
  // final String code;

  const BgMechanic({required this.name
      // @required this.nativeName,
      // @required this.code,
      });

  factory BgMechanic.fromJson(Map<String, dynamic> json) => BgMechanic(
        name: json['name'],
        // code: json['code'],
        // nativeName: json['native'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BgMechanic &&
          runtimeType == other.runtimeType &&
          name == other.name;
  // nativeName == other.nativeName &&
  // code == other.code;

  @override
  int get hashCode => name.hashCode;
}

//  nativeName.hashCode ^ code.hashCode;
