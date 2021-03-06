import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/portrait.dart';
import 'package:flutter_demo_01/components/widgets/rounded_button.dart';
import 'package:flutter_demo_01/components/widgets/rounded_outlined_button.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/chat_screen.dart';
import 'package:flutter_demo_01/utils/utils.dart';
import 'package:provider/provider.dart';

class MatchedScreen extends StatelessWidget {
  static const String id = 'matched_screen';

  final String myProfilePhotoPath;
  final String myUserId;
  final String otherUserProfilePhotoPath;
  final String otherUserId;
  final String otherUserName;

  const MatchedScreen(
      {Key? key,
      required this.myProfilePhotoPath,
      required this.myUserId,
      required this.otherUserProfilePhotoPath,
      required this.otherUserId,
      required this.otherUserName})
      : super(key: key);

  void sendMessagePressed(BuildContext context) async {
    AppUser user = await Provider.of<UserProvider>(context, listen: false).user;

    Navigator.pop(context);
    Navigator.pushNamed(context, ChatScreen.id, arguments: {
      "chat_id": compareAndCombineIds(myUserId, otherUserId),
      "user_id": user.id,
      "other_user_id": otherUserId
    });
  }

  void keepSwipingPressed(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 42.0,
            horizontal: 18.0,
          ),
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Text("It's a Match!", style: TextStyle(fontSize: 32)),
                Text(
                    "You and ${otherUserName.capitalize()} have liked each other",
                    style: TextStyle(fontSize: 24))
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Portrait(imageUrl: myProfilePhotoPath),
                  Portrait(imageUrl: otherUserProfilePhotoPath)
                ],
              ),
              Column(
                children: [
                  RoundedButton(
                    text: 'SEND MESSAGE',
                    onPressed: () {
                      sendMessagePressed(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  RoundedOutlinedButton(
                      text: 'KEEP SWIPING',
                      onPressed: () {
                        keepSwipingPressed(context);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
