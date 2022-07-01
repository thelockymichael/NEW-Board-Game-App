import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/components/widgets/rounded_icon_button.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FullScreenImageViewer extends StatelessWidget {
  FullScreenImageViewer(this.url, this.photoNumber, this.userProvider,
      {Key? key})
      : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final String url;

  final int photoNumber;

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GestureDetector(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Hero(
              tag: 'imageHero',
              child: Image.network(url),
            ),
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
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          onTap: () async {
                            final pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              userProvider.updateUserProfilePhoto(
                                  pickedFile.path, _scaffoldKey, 0);
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
    ));
  }
}
