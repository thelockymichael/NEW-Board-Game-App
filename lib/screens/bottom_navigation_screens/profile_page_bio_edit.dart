import 'package:flutter/material.dart';
import 'package:flutter_demo_01/components/widgets/custom_modal_progress_hud.dart';
import 'package:flutter_demo_01/db/entity/GridItem.dart';
import 'package:flutter_demo_01/db/entity/FavGenreItem.dart';
import 'package:flutter_demo_01/db/remote/response.dart';
import 'package:flutter_demo_01/model/app_user.dart';
import 'package:flutter_demo_01/model/user_bio_edit.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePageBgBioEdit extends StatefulWidget {
  static const String id = 'profile_page_bio_edit';
  final Function() notifyParent;
  final AppUser? userSnapshot;

  const ProfilePageBgBioEdit({this.userSnapshot, required this.notifyParent});

  @override
  _ProfilePageBgBioEditState createState() => _ProfilePageBgBioEditState();
}

class _ProfilePageBgBioEditState extends State<ProfilePageBgBioEdit> {
  final UserBioEdit _userBioEdit = UserBioEdit();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<FavGenreItem> itemList;
  late List<FavGenreItem> selectedList;

  late UserProvider _userProvider;
  late AppUser _userSnapshot;

  final _bioFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void initState() {
    _userSnapshot = widget.userSnapshot!;
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Container(
          child:
              Consumer<UserProvider>(builder: (context, userProvider, child) {
            return FutureBuilder<AppUser>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                    inAsyncCall:
                        userProvider.user == null || userProvider.isLoading,
                    child: userSnapshot.hasData
                        ? CustomScrollView(
                            slivers: <Widget>[
                              SliverAppBar(),
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  bioEditForm(context, userSnapshot.data!),
                                  // tripDetails(),
                                  // CalculatorWidget(trip: widget.trip),
                                  // totalBudgetCard(),
                                  // daysOutCard(),
                                  // notesCard(context),
                                  Container(
                                    height: 200,
                                  )
                                ]),
                              )
                            ],
                          )
                        : Container());
              },
            );
          }),
        ));
  }

  Widget bioEditForm(context, AppUser userSnapshot) {
    final _bioTextController = TextEditingController(text: userSnapshot.bio);

    final _focusBio = FocusNode();
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Write about your board game hobby",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 32)),
            Form(
              key: _bioFormKey,
              child: Column(children: <Widget>[
                TextFormField(
                  controller: _bioTextController,
                  focusNode: _focusBio,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Don't be shy!",
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  maxLength: 500,
                ),
                _isProcessing
                    ? CircularProgressIndicator()
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isProcessing = true;
                                });

                                if (_bioFormKey.currentState!.validate()) {
                                  // Bio
                                  _userBioEdit.bio = _bioTextController.text;

                                  await _userProvider
                                      .updateUserBio(userSnapshot, _userBioEdit,
                                          _scaffoldKey)
                                      .then((response) {
                                    if (response is Success) {
                                      widget.notifyParent();
                                      print("Great success");
                                    }
                                  });

                                  setState(() {
                                    _isProcessing = false;
                                  });
                                } else {
                                  setState(() {
                                    _isProcessing = false;
                                  });
                                }
                              },
                              child: Text("Save",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      )
              ]),
            )
          ],
        ));
  }
}
