import 'package:flutter/material.dart';
import 'package:shuttle_bus_fronted/account_user.dart';
import 'package:shuttle_bus_fronted/homepages.dart';
import 'package:shuttle_bus_fronted/bus_page.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = const Homepages();
        break;
      case 1:
        page = const BusPage();
        break;
      case 2:
        page = const AccountUser();
        break;
      default:
        page = const Homepages();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
            _item(context, Icons.home, "Home", 0),
            _busItem(context),
            _item(context, Icons.person, "Account", 2),
          ],
        ),
      ),
    );
  }
  // Home + Account Pages
Widget _item(BuildContext context, IconData icon, String label, int index) {
  final isActive = currentIndex == index;

  return GestureDetector(
    onTap: () => _navigate(context, index),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
       mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: isActive ? const Offset(0, -20) : Offset.zero,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 12,
            height: 1,
          ),
        ),
      ],
    ),
  );
}
// Bus pages
Widget _busItem(BuildContext context) {
  final isActive = currentIndex == 1;

  return GestureDetector(
    onTap: () => _navigate(context, 1),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: isActive ? const Offset(0, -20) : Offset.zero,
          child: Container(
            width: 60,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Image.asset('assets/bus.png', height: 30),
            ),
          ),
        ),
        Text(
          "Bus",
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
}