import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';
import 'package:flutter_demo_01/utils/utils.dart';

class BgGameMechanicProvider with ChangeNotifier {
  List<BgMechanic> _bgMechanics = [
    BgMechanic(name: "Co-op"),
    BgMechanic(name: "Team"),
    BgMechanic(name: "Social Deduction"),
    BgMechanic(name: "Euro"),
    BgMechanic(name: "Card"),
    BgMechanic(name: "Resource Management"),
    BgMechanic(name: "Bidding"),
    BgMechanic(name: "Worker Placement")
  ];

  List<BgMechanic> get bgMechanics => _bgMechanics;
}
