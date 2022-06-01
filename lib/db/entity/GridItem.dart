import 'package:flutter/material.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/utils/constants.dart';

class GridItem extends StatefulWidget {
  final Key key;
  final FavGenreItem item;
  final ValueChanged<bool> isSelected;

  GridItem({required this.item, required this.isSelected, required this.key});

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
          print("IS SELECTUS ${isSelected}");
        });
      },
      /**
Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'images/bg.jpg',
              ),
            ),
          ),
          height: 350.0,
        ),
        Container(
          height: 350.0,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [Colors.grey.withOpacity(0.0),Colors.black,
                  ],stops: [
                    0.0,
                    1.0
       */
      child: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  height: 350.0,
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //     begin: FractionalOffset.topCenter,
                      //     end: FractionalOffset.bottomCenter,
                      //     colors: [Colors.grey.withOpacity(0.0), Colors.black],
                      //     stops: [0.0, 1.0]),
                      // gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     colors: [Colors.red.shade200, Colors.black]),
                      image: DecorationImage(
                          image: NetworkImage(widget.item.imageUrl),
                          fit: BoxFit.cover))),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        // begin: Alignment.topCenter,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // end: Alignment.bottomCenter,
                        colors: [
                      Colors.grey.withOpacity(0.0),
                      Colors.black.withOpacity(0.6),
                    ],
                        stops: [
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
                      child: Text(widget.item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)))
                ],
              )
            ],
          ),
          widget.item.isSelected
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
