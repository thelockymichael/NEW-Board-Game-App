import 'package:flutter/material.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/utils/constants.dart';
import "package:flutter_demo_01/utils/utils.dart";

class ChatTopBar extends StatelessWidget {
  final AppUser user;

  const ChatTopBar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(user.profilePhotoPath)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAccentColor, width: 1.0),
              ),
            )
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name.capitalize(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ],
    );
  }
}
