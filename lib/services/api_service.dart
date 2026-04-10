import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://172.25.19.229:5000"; //ip คอมเรา

  // ===== COMMON FUNCTION =====
  static dynamic _handleResponse(http.Response res) {
    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    try {
      return jsonDecode(res.body);
    } catch (e) {
      return {"error": "Server error (not JSON)"};
    }
  }

  // 🔥 REGISTER
  static Future<String?> register(
    String username,
    String password,
    String email,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email,
        }),
      );

      final data = _handleResponse(res);

      if (res.statusCode == 200) {
        return null;
      } else {
        return data["error"] ?? "Register failed";
      }
    } catch (e) {
      return "Network error";
    }
  }

  // 🔥 LOGIN
  static Future<String?> login(String username, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      final data = _handleResponse(res);

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        return null;
      } else {
        return data["error"] ?? "Login failed";
      }
    } catch (e) {
      return "Network error";
    }
  }

  // 🔥 UPDATE PROFILE
  static Future<String?> updateProfile(
    String username,
    String email,
    String password,
    String newPassword,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final res = await http.put(
        Uri.parse("$baseUrl/auth/update"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "new_password": newPassword,
        }),
      );

      final data = _handleResponse(res);

      if (res.statusCode == 200) {
        return null;
      } else {
        return data["error"] ?? "Update failed";
      }
    } catch (e) {
      return "Network error";
    }
  }

  // 🔒 GET USER
  static Future<Map<String, dynamic>> getLatest() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final res = await http.get(
      Uri.parse("$baseUrl/auth/user"),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = _handleResponse(res);

    if (res.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["error"] ?? "Failed to load user");
    }
  }
}
