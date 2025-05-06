import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      option: AnimatedBarOptions(
        iconStyle: IconStyle.animated,
        barAnimation: BarAnimation.fade,
        iconSize: 26,
      ),
      items: [
        BottomBarItem(
          icon: const Icon(Icons.analytics),
          title: const Text('Analyze'),
          selectedColor: Colors.blue,
        ),
        BottomBarItem(
          icon: const Icon(Icons.history),
          title: const Text('History'),
          selectedColor: Colors.blue,
        ),
        BottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text('Profile'),
          selectedColor: Colors.blue,
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
