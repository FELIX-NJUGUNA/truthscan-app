import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://truthscan-ai.onrender.com";

  // Key to store/retrieve token
  static const String _tokenKey = 'auth_token';

  // Call this method after successful login to save the token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieve token for use in authenticated requests
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Optional: Clear token on logout
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
