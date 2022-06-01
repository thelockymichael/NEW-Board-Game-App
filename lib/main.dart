import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/firebase_options.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page_bg_genre_edit.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page_edit.dart';
import 'package:flutter_demo_01/screens/chat_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/discover_page.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page.dart';
import 'package:flutter_demo_01/screens/register_page.dart';
import 'package:flutter_demo_01/screens/settings_page.dart';
import 'package:flutter_demo_01/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CardProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.id,
          routes: {
            SplashScreen.id: (context) => SplashScreen(),
            LoginPage.id: (context) => LoginPage(),
            DiscoverPage.id: (context) => DiscoverPage(),
            ProfilePage.id: (context) => ProfilePage(),
            ProfilePageEdit.id: (context) => ProfilePageEdit(),
            ProfilePageBgGenreEdit.id: (context) => ProfilePageBgGenreEdit(),
            SettingsPage.id: (context) => SettingsPage(),
            RegisterPage.id: (context) => RegisterPage(),
            MainNavigation.id: (context) => MainNavigation(),
            MatchedScreen.id: (context) => MatchedScreen(
                  myProfilePhotoPath: (ModalRoute.of(context)
                      ?.settings
                      .arguments as Map)['my_profile_photo_path'],
                  myUserId: (ModalRoute.of(context)?.settings.arguments
                      as Map)['my_user_id'],
                  otherUserProfilePhotoPath: (ModalRoute.of(context)
                      ?.settings
                      .arguments as Map)['other_user_profile_photo_path'],
                  otherUserId: (ModalRoute.of(context)?.settings.arguments
                      as Map)['other_user_id'],
                ),
            ChatScreen.id: (context) => ChatScreen(
                  chatId: (ModalRoute.of(context)?.settings.arguments
                      as Map)['chat_id'],
                  otherUserId: (ModalRoute.of(context)?.settings.arguments
                      as Map)['other_user_id'],
                  myUserId: (ModalRoute.of(context)?.settings.arguments
                      as Map)['user_id'],
                ),
          },
        ));
  }
  // @override
  // Widget build(BuildContext context) => ChangeNotifierProvider(
  //     create: (context) => CardProvider(),
  //     child: MaterialApp(
  //         title: 'Flutter Authentication',
  //         debugShowCheckedModeBanner: false,
  //         theme: ThemeData(
  //           primarySwatch: Colors.cyan,
  //           // elevatedButtonTheme: ElevatedButtonThemeData(
  //           //     style: ElevatedButton.styleFrom(
  //           //   elevation: 8,
  //           //   primary: Colors.white,
  //           //   shape: CircleBorder(),
  //           //   minimumSize: Size.square(80),
  //         ),
  //         home: const LoginPage()));
}