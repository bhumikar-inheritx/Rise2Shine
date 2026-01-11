import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Keys for SharedPreferences
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyLoginTimestamp = 'login_timestamp';

  // Save login state
  static Future<bool> saveLoginState(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    } catch (e) {
      print('❌ SharedPreferencesService: Error saving login state - $e');
      return false;
    }
  }

  // Get login state
  static Future<bool> getLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('❌ SharedPreferencesService: Error getting login state - $e');
      return false;
    }
  }

  // Save user ID (Firebase Auth UID)
  static Future<bool> saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_keyUserId, userId);
    } catch (e) {
      print('❌ SharedPreferencesService: Error saving user ID - $e');
      return false;
    }
  }

  // Get user ID
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserId);
    } catch (e) {
      print('❌ SharedPreferencesService: Error getting user ID - $e');
      return null;
    }
  }

  // Save user phone number
  static Future<bool> saveUserPhone(String phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_keyUserPhone, phoneNumber);
    } catch (e) {
      print('❌ SharedPreferencesService: Error saving user phone - $e');
      return false;
    }
  }

  // Get user phone number
  static Future<String?> getUserPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserPhone);
    } catch (e) {
      print('❌ SharedPreferencesService: Error getting user phone - $e');
      return null;
    }
  }

  // Save login timestamp
  static Future<bool> saveLoginTimestamp(String timestamp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_keyLoginTimestamp, timestamp);
    } catch (e) {
      print('❌ SharedPreferencesService: Error saving login timestamp - $e');
      return false;
    }
  }

  // Get login timestamp
  static Future<String?> getLoginTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyLoginTimestamp);
    } catch (e) {
      print('❌ SharedPreferencesService: Error getting login timestamp - $e');
      return null;
    }
  }

  // Clear all login-related data (for logout)
  static Future<bool> clearLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsLoggedIn);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUserPhone);
      await prefs.remove(_keyLoginTimestamp);
      print('✅ SharedPreferencesService: Login data cleared');
      return true;
    } catch (e) {
      print('❌ SharedPreferencesService: Error clearing login data - $e');
      return false;
    }
  }

  // Check if user is logged in (convenience method)
  static Future<bool> isUserLoggedIn() async {
    final isLoggedIn = await getLoginState();
    final userId = await getUserId();
    // User is logged in only if both conditions are true
    return isLoggedIn && userId != null && userId.isNotEmpty;
  }
}
