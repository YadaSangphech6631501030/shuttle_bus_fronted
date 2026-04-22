import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.110.214:5001"; //ip คอมเรา

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

  // Register
  static Future<String?> register(
    String username,
    String password,
    String email,
  ) async {
    print("REGISTER INPUT:");
    print("username: $username");
    print("password: $password");
    print("email: $email");

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

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

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

  //LOGIN
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

  //UPDATE PROFILE
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

  // GET USER
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

  //Station
  static Future<List<dynamic>> getStations(String line) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/station/$line"));

      final data = _handleResponse(res);

      if (res.statusCode == 200) {
        return data;
      } else {
        throw Exception("Failed to load stations");
      }
    } catch (e) {
      throw Exception("Network error");
    }
  }
  
  //bus
  static Future<List<dynamic>> getBuses() async {
  try {
    final res = await http.get(
      Uri.parse("$baseUrl/api/buses"),
    );

    final data = _handleResponse(res);

    if (res.statusCode == 200) {
      return data;
    } else {
      throw Exception("Failed to load buses");
    }
  } catch (e) {
    throw Exception("Network error");
  }
}
}
