import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_01/firebase_options.dart';
import 'package:flutter_demo_01/navigation/bottom_navigation_bar.dart';
import 'package:flutter_demo_01/provider/card_provider.dart';
import 'package:flutter_demo_01/provider/user_provider.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page_edit.dart';
import 'package:flutter_demo_01/screens/chat_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/discover_page.dart';
import 'package:flutter_demo_01/screens/matched_screen.dart';
import 'package:flutter_demo_01/screens/bottom_navigation_screens/profile_page/profile_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/add_photos_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/date_of_birth_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/enable_location_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/first_name_bgg_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/gender_page.dart';
import 'package:flutter_demo_01/screens/setup_screens/register_page.dart';
import 'package:flutter_demo_01/screens/v1_register_page.dart';
import 'package:flutter_demo_01/screens/settings_page.dart';
import 'package:flutter_demo_01/screens/splash_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
  }
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
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: GlobalLoaderOverlay(
            child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.id,
          routes: {
            SplashScreen.id: (context) => const SplashScreen(),
            LoginPage.id: (context) => const LoginPage(),
            DiscoverPage.id: (context) => const DiscoverPage(),
            ProfilePage.id: (context) => const ProfilePage(),
            ProfilePageEdit.id: (context) => const ProfilePageEdit(),
            SettingsPage.id: (context) => const SettingsPage(),
            RegisterPage.id: (context) => const RegisterPage(),
            FirstNameBggPage.id: (context) => const FirstNameBggPage(),
            DateOfBirthPage.id: (context) => const DateOfBirthPage(),
            GenderPage.id: (context) => GenderPage(
                  gender: (ModalRoute.of(context)?.settings.arguments
                      as Map)['gender'],
                ),
            AddPhotosPage.id: (context) => AddPhotosPage(
                  profilePhotoPaths: (ModalRoute.of(context)?.settings.arguments
                      as Map)['profilePhotoPaths'],
                ),
            EnableLocationPage.id: (context) => const EnableLocationPage(),
            V1RegisterPage.id: (context) => const V1RegisterPage(),
            MainNavigation.id: (context) => const MainNavigation(),
            MatchedScreen.id: (context) => MatchedScreen(
                  myProfilePhotoPath: (ModalRoute.of(context)
                      ?.settings
                      .arguments as Map)['my_profile_photo_path'],
                  myUserId: (ModalRoute.of(context)?.settings.arguments
                      as Map)['my_user_id'],
                  otherUserProfilePhotoPath: (ModalRoute.of(context)
                      ?.settings
                      .arguments as Map)['other_user_profile_photo_path'],
                  otherUserName: (ModalRoute.of(context)?.settings.arguments
                      as Map)['other_user_name'],
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
        )));
  }
}
