import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String userKey = 'user_key';
  static const String isLoggedInKey = 'is_logged_in_key';

  Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, username);
    await prefs.setBool(isLoggedInKey, true);
  }

  Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
