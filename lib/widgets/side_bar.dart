import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const SideBar({super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      labelType: NavigationRailLabelType.selected,
      backgroundColor: Colors.grey[100],
      selectedIconTheme: IconThemeData(color: Colors.blue, size: 28),
      unselectedIconTheme: IconThemeData(color: Colors.grey, size: 24),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.analytics),
          selectedIcon: Icon(Icons.analytics_outlined),
          label: Text('Analyze'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.history),
          selectedIcon: Icon(Icons.history_outlined),
          label: Text('History'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          selectedIcon: Icon(Icons.person_outline),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
