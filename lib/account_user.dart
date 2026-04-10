import 'package:flutter/material.dart';
import 'package:shuttle_bus_fronted/edit_account_user.dart';
import 'package:shuttle_bus_fronted/signin01.dart';
import 'package:shuttle_bus_fronted/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountUser extends StatefulWidget {
  const AccountUser({super.key});

  @override
  State<AccountUser> createState() => _AccountUserState();
}

class _AccountUserState extends State<AccountUser> {
  int currentIndex = 2;

  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    // 🔥 เช็ค token ก่อน
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      _logout();
      return;
    }

    try {
      final data = await ApiService.getLatest();

      print("LATEST DATA: $data");

      setState(() {
        username = data["username"] ?? "";
        email = data["email"] ?? "";
      });
    } catch (e) {
      print("LOAD USER ERROR: $e");

      // ❌ ไม่ logout แล้ว
      // แค่กัน UI พัง
      setState(() {
        username = "";
        email = "";
      });
    }
  }

  // 🔥 logout function (เหมือนเดิม)
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Signin01()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );

                            loadUser(); // 🔥 refresh
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Username
                Text(
                  username.isEmpty ? "Loading..." : username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // Email
                Text(
                  email.isEmpty ? "" : email,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 40),

                // Sign out button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _logout,
                    child: const Text(
                      "Sign out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu bar (เหมือนเดิม 100%)
          Positioned(
            bottom: 20,
            left: 70,
            right: 70,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.home, color: Colors.white),
                        SizedBox(height: 4),
                        Text(
                          "Home",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Image.asset('assets/bus.png', height: 50),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Account",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
