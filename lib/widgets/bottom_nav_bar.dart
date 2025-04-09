// lib/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.cyanAccent,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.sensors),
          label: 'Sensing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Compass',
        ),
      ],
    );
  }
}
