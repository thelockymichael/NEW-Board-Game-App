import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String url;

  final int photoNumber;

  final UserProvider userProvider;

  final List<String> profilePhotoPaths;

  const FullScreenImageViewer(
      {Key? key,
      required this.url,
      required this.photoNumber,
      required this.userProvider,
      required this.profilePhotoPaths})
      : super(key: key);

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
// class FullScreenImageViewer extends StatelessWidget {
  // FullScreenImageViewer(
  //     this.url, this.photoNumber, this.userProvider, this.profilePhotoPaths,
  //     {Key? key})
  //     : super(key: key);

  late List<String> imgList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // TODO Remove ALL IMAGES THAT DON'T EXIST

    for (var i = 0; i < widget.profilePhotoPaths.length; i++) {
      if (widget.profilePhotoPaths[i].isEmpty) {
        continue;
      }

      imgList.add(widget.profilePhotoPaths[i]);
    }

    print("LOG widget.profilePhotoPaths ${widget.profilePhotoPaths.length}");

    // imgList = widget.profilePhotoPaths;
  }

  String reason = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final CarouselController _controller = CarouselController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    print("LOG onPageChange ${index}");
    print("LOG onPageChange ${changeReason}");

    setState(() {
      reason = changeReason.toString();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Stack(
  //     children: [
  //       GestureDetector(
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.height,
  //           child: Hero(
  //             tag: 'imageHero',
  //             child: Image.network(url),
  //           ),
  //         ),
  //         onTap: () {
  //           Navigator.pop(context);
  //         },
  //       ),
  //       Positioned(
  //         right: 1.0,
  //         bottom: 1.0,
  //         child: Padding(
  //             padding: EdgeInsets.fromLTRB(0, 0, 12, 40),
  //             child: RoundedIconButton(
  //               onPressed: () async {
  //                 showModalBottomSheet(
  //                   isScrollControlled: true,
  //                   barrierColor: Colors.black54,
  //                   elevation: 5,
  //                   context: context,
  //                   builder: (BuildContext context) {
  //                     return Wrap(children: <Widget>[
  //                       ListTile(
  //                         leading: Text("Upload new photo",
  //                             style: TextStyle(
  //                                 fontSize: 24, fontWeight: FontWeight.bold)),
  //                         onTap: () async {
  //                           final pickedFile = await ImagePicker()
  //                               .pickImage(source: ImageSource.gallery);
  //                           if (pickedFile != null) {
  //                             userProvider.updateUserProfilePhoto(
  //                                 pickedFile.path, _scaffoldKey, 0);
  //                           }
  //                         },
  //                       )
  //                     ]);
  //                   },
  //                 );
  //               },
  //               iconData: Icons.more_horiz,
  //               iconColor: Colors.white,
  //               iconSize: 24,
  //               buttonColor: Colors.black,
  //             )),
  //       )
  //     ],
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    print("LOG allProfilePhotos ${widget.profilePhotoPaths}");

    return Scaffold(
        appBar: AppBar(title: Text('Image slider demo')),
        body: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height;
            return CarouselSlider(
              options: CarouselOptions(
                height: height,
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                onPageChanged: onPageChange,
                enableInfiniteScroll: false,
              ),
              carouselController: _controller,
              items: imgList
                  .map((item) => Stack(
                        children: [
                          GestureDetector(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(item),
                                          fit: BoxFit.contain))),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Positioned(
                            right: 1.0,
                            bottom: 1.0,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 12, 40),
                                child: RoundedIconButton(
                                  onPressed: () async {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      barrierColor: Colors.black54,
                                      elevation: 5,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Wrap(children: <Widget>[
                                          ListTile(
                                            leading: Text("Upload new photo",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onTap: () async {
                                              // print("LOG indexOf ${widget.profilePhotoPaths.indexOf(item)}");
                                              int indexOfItem =
                                                  imgList.indexOf(item);

                                              final pickedFile =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (pickedFile != null) {
                                                widget.userProvider
                                                    .updateUserProfilePhoto(
                                                        pickedFile.path,
                                                        _scaffoldKey,
                                                        indexOfItem)
                                                    .then((response) {
                                                  if (response is Success) {
                                                    print(
                                                        "LOG jotain success asdas");
                                                    print(
                                                        "LOG jotain ${response.value}");
                                                    // TODO userProvider.isLoading
                                                    setState(() {
                                                      // imgList.replaceRange(
                                                      //     indexOfItem,
                                                      //     indexOfItem + 1,
                                                      //     response.value);
                                                      imgList[indexOfItem] =
                                                          response.value;
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                          )
                                        ]);
                                      },
                                    );
                                  },
                                  iconData: Icons.more_horiz,
                                  iconColor: Colors.white,
                                  iconSize: 24,
                                  buttonColor: Colors.black,
                                )),
                          )
                        ],
                      ))
                  .toList(),
            );
          },
        ));
  }
}
