// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import "package:flutter_demo_01/utils/utils.dart";

class GridItem extends StatefulWidget {
  final Key itemKey;
  final FavGenreItem item;
  final ValueChanged<bool> isSelected;

  const GridItem(
      {Key? key,
      required this.item,
      required this.isSelected,
      required this.itemKey})
      : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();

    isSelected = widget.item.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          // isSelected = widget.item.isSelected;
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  height: 350.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.item.imageUrl),
                          fit: BoxFit.cover))),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.grey.withOpacity(0.0),
                      Colors.black.withOpacity(0.6),
                    ],
                        stops: const [
                      0.0,
                      1.0
                    ])),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(widget.item.name.capitalize(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)))
                ],
              )
            ],
          ),
          widget.item.isSelected
              ? const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
