import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  // USER
  static const String keyuserId = 'KEY_USER_ID';

// TUTORIAL
  static const String tutorialId = 'KEY_TUTORIAL_ID';

  // Set User ID
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyuserId);
  }

  static Future<void> setUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyuserId, id);
  }

  static Future<void> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyuserId);
  }
  // END Set User ID

  // Set Tutorial true / false

  static Future<bool?> getTutorialState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorialId);
  }

  static Future<void> setTutorialState(bool tutorialState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialId, tutorialState);
  }

  static Future<void> removeTutorialState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(tutorialId);
  }

  // END Set Tutorial true / false

}
