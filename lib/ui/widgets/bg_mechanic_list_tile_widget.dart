import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/bg_mechanic.dart';

class BgMechanicListTileWidget extends StatelessWidget {
  final BgMechanic bgMechanic;
  // final bool isNative;
  final bool isSelected;
  final ValueChanged<BgMechanic> onSelectedBgMechanic;

  const BgMechanicListTileWidget(
      {required this.bgMechanic,
      // required this.isNative,
      required this.isSelected,
      required this.onSelectedBgMechanic});

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    final style = isSelected
        ? TextStyle(
            fontSize: 18,
            color: selectedColor,
            fontWeight: FontWeight.bold,
          )
        : TextStyle(fontSize: 18);

    return ListTile(
      onTap: () => onSelectedBgMechanic(bgMechanic),
      // leading: FlagWidget(code: BgMechanic),
      title: Text(
        bgMechanic.name,
        style: style,
      ),
      trailing:
          isSelected ? Icon(Icons.check, color: selectedColor, size: 26) : null,
    );
  }
}
