import 'package:flutter/material.dart';
import 'sigin02.dart';

class Signin01 extends StatelessWidget {
  const Signin01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
  children: [

    const SizedBox(height: 20),

    Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/mfu_logo.png',
        height: 90,
      ),
    ),

    const SizedBox(height: 40),

    // bus
    Image.asset(
      'assets/bus.png',
      height: 120,
    ),

    const SizedBox(height: 100), 

    // ปุ่ม
    SizedBox(
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signin02(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

    const SizedBox(height: 20),

    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Don't have an account? "),
        Text(
          "Sign up",
          style: TextStyle(color: Colors.blue),
        ),
      ],
    ),
  ],
),
        ),
      ),
    );
  }
}