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

  final List<String> profilePhotoPaths;

  const FullScreenImageViewer(
      {Key? key,
      required this.url,
      required this.photoNumber,
      required this.profilePhotoPaths})
      : super(key: key);

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late List<String> imgList = [];

  String reason = '';

  int indexOfItem = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final CarouselController _controller = CarouselController();

  late UserProvider _userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);

    // TODO Remove ALL IMAGES THAT DON'T EXIST

    for (var i = 0; i < widget.profilePhotoPaths.length; i++) {
      if (widget.profilePhotoPaths[i].isEmpty) continue;
      imgList.add(widget.profilePhotoPaths[i]);
    }

    indexOfItem = imgList.indexOf(widget.url);
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
      indexOfItem = index;
    });

    print("LOG indexOfItem $indexOfItem");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Image slider demo')),
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                final double height = MediaQuery.of(context).size.height;

                return CustomModalProgressHUD(
                    inAsyncCall: userProvider.isLoading,
                    child: userSnapshot.hasData
                        ? Stack(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                    height: height,
                                    viewportFraction: 1.0,
                                    enlargeCenterPage: true,
                                    aspectRatio: 16 / 9,
                                    onPageChanged: onPageChange,
                                    enableInfiniteScroll: false,
                                    initialPage: indexOfItem),
                                carouselController: _controller,
                                items: imgList
                                    .map((item) => Stack(
                                          children: [
                                            GestureDetector(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                item),
                                                            fit: BoxFit
                                                                .contain))),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ))
                                    .toList(),
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
                                                leading: Text(
                                                    "Upload new photo",
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                onTap: () async {
                                                  print(
                                                      "LOG rf Uploaded new photo");

                                                  int updateImageNum = widget
                                                      .profilePhotoPaths
                                                      .indexOf(
                                                          imgList[indexOfItem]);

                                                  print(
                                                      "LOG jotain updateImageNum $updateImageNum");

                                                  print(
                                                      "LOG jotain profilePhotoPaths ${widget.profilePhotoPaths.length}");

                                                  final pickedFile =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  if (pickedFile != null) {
                                                    _userProvider
                                                        .updateUserProfilePhoto(
                                                            pickedFile.path,
                                                            _scaffoldKey,
                                                            updateImageNum)
                                                        .then((response) {
                                                      if (response is Success) {
                                                        print(
                                                            "LOG jotain ${response.value}");
                                                        // TODO userProvider.isLoading
                                                        setState(() {
                                                          imgList[indexOfItem] =
                                                              response.value;
                                                        });

                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: Text("Delete",
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                onTap: () async {
                                                  // print("LOG indexOf ${widget.profilePhotoPaths.indexOf(item)}");
                                                  // int indexOfItem = imgList.indexOf(item);
                                                  // setState(() {
                                                  //   imgList[indexOfItem] = "";
                                                  // });
                                                  int deleteImageNum =
                                                      userSnapshot.data!
                                                          .profilePhotoPaths
                                                          .indexOf(imgList[
                                                              indexOfItem]);

                                                  print(
                                                      "LOG jotain does It exist ${deleteImageNum}");

                                                  userProvider
                                                      .deleteUserProfilePhoto(
                                                          _scaffoldKey,
                                                          deleteImageNum)
                                                      .then((response) {
                                                    if (response is Success) {
                                                      // TODO userProvider.isLoading
                                                      // setState(() {
                                                      //   imgList[indexOfItem] =
                                                      //       response.value;
                                                      // });
                                                      print(
                                                          "LOG jotain deleteUserProfilePhoto ${response.value}");
                                                      // TODO Remove ALL IMAGES THAT DON'T EXIST
                                                      // for (var i = 0; i < userSnapshot.data!.profilePhotoPaths.length; i++) {

                                                      // }

                                                      setState(() {
                                                        imgList[indexOfItem] =
                                                            "";
                                                        imgList.removeAt(
                                                            indexOfItem);
                                                      });

                                                      for (var i = 0;
                                                          i < imgList.length;
                                                          i++) {
                                                        if (imgList
                                                            .isNotEmpty) {
                                                          _controller
                                                              .jumpToPage(i);
                                                          break;
                                                        }
                                                      }
                                                    }
                                                  });
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
                          )
                        : Container());
              });
        }));
  }
}
