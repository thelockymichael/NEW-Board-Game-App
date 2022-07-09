import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';

import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/setup_screens/enable_location_page.dart';
import 'package:flutter_demo_01/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPhotosPage extends StatefulWidget {
  static const String id = 'add_photos_page';

  final List<String> profilePhotoPaths;

  const AddPhotosPage({
    Key? key,
    required this.profilePhotoPaths,
  }) : super(key: key);

  @override
  AddPhotosPageState createState() => AddPhotosPageState();
}

class AddPhotosPageState extends State<AddPhotosPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /* 1. Gender Select */
  // 1. Default Selected Gender

  late List<String> selectedPhotos;

  bool errorMessageEnabled = false;

  // String selectedGender = defaultSelectedGender;

  /// 1. END Gender Select END */
  @override
  void initState() {
    super.initState();

    selectedPhotos = widget.profilePhotoPaths;

    for (var i = 0; i < selectedPhotos.length; i++) {
      print("LOG ALL PROFILE PHOTOS ${selectedPhotos[0]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                    inAsyncCall: userProvider.isLoading,
                    child: userSnapshot.hasData
                        ? Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Add Photos",
                                        style: TextStyle(fontSize: 32),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 300,
                                            child: GridView.count(
                                              crossAxisCount: 3,
                                              children:
                                                  List.generate(6, (index) {
                                                return GestureDetector(
                                                    onTap: () async {
                                                      final pickedFile =
                                                          await ImagePicker()
                                                              .pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                      if (pickedFile != null) {
                                                        await userProvider
                                                            .updateUserProfilePhoto(
                                                                pickedFile.path,
                                                                context,
                                                                index)
                                                            .then((response) {
                                                          if (response
                                                              is Success) {
                                                            print(
                                                                "LOG response is success ${response.value}");

                                                            setState(() {
                                                              selectedPhotos[
                                                                      index] =
                                                                  response
                                                                      .value;

                                                              errorMessageEnabled =
                                                                  false;
                                                            });

                                                            print(
                                                                "LOG selectedPhotos[0] ${selectedPhotos[0]}");
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              color: Colors
                                                                  .blue[200],
                                                              image: userSnapshot
                                                                      .data!
                                                                      .profilePhotoPaths[
                                                                          index]
                                                                      .isEmpty
                                                                  ? null
                                                                  : DecorationImage(
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      image: NetworkImage(userSnapshot
                                                                          .data!
                                                                          .profilePhotoPaths[index]))),
                                                        ),
                                                        Positioned(
                                                            top: 1.0,
                                                            right: 1.0,
                                                            child:
                                                                RoundedIconButton(
                                                              onPressed:
                                                                  () async {},
                                                              iconData:
                                                                  Icons.add,
                                                              iconSize: 18,
                                                              buttonColor:
                                                                  Colors.blue,
                                                            ))
                                                      ],
                                                    ));
                                              }),
                                            ),
                                          ),
                                          errorMessageEnabled
                                              ? Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 8, 0, 8),
                                                  child: Text(
                                                    "At least one photo must be uploaded.",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                )
                                              : Container(),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    bool isValidGender = Validator
                                                        .validatePhotosArray(
                                                            photosArray:
                                                                selectedPhotos);
                                                    if (isValidGender) {
                                                      print(
                                                          "LOG photos are valid");

                                                      Navigator.of(context)
                                                          .push(
                                                              PageRouteBuilder(
                                                        pageBuilder: (
                                                          BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secondaryAnimation,
                                                        ) =>
                                                            EnableLocationPage(),
                                                        transitionsBuilder: (
                                                          BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secondaryAnimation,
                                                          Widget child,
                                                        ) =>
                                                            SlideTransition(
                                                          position:
                                                              Tween<Offset>(
                                                            begin: const Offset(
                                                                1, 0),
                                                            end: Offset.zero,
                                                          ).animate(animation),
                                                          child: child,
                                                        ),
                                                      ));
                                                    } else {
                                                      setState(() {
                                                        errorMessageEnabled =
                                                            true;
                                                      });
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Next',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container());
              });
        }));
  }
}

class UpdatePhotos extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
          child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue[300]),
        height: 100,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Uploading photos.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Please wait...',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ));
}
