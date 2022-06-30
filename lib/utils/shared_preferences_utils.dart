import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const String keyuserId = 'KEY_USER_ID';
  static const String setupState = 'SETUP_STATE';

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
}
