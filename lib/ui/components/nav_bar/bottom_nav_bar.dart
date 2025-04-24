import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.explore),
              label: "Explore",
              selectedIcon: Icon(Icons.explore, color: Color(0xFF094D95))),
          NavigationDestination(
              icon: Icon(Icons.home),
              label: "My courses",
              selectedIcon: Icon(Icons.home, color: Color(0xFF094D95))),
          //NavigationDestination(icon: Icon(Icons.trending_up), label: "Stats"),
        ],
        onDestinationSelected: (int index) {
          navigationShell.goBranch(index);
        },
        selectedIndex: navigationShell.currentIndex,
      ),
    );
  }
}
