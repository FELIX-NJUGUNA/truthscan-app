import 'package:flutter/material.dart';
import 'package:truthscan_app/views/analyze_screen.dart';
import 'package:truthscan_app/views/history_screen.dart';
import 'package:truthscan_app/views/profile_screen.dart';
import 'package:truthscan_app/widgets/bottom_nav_bar.dart';
import 'package:truthscan_app/widgets/side_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _screens = [AnalyzeScreen(), HistoryScreen(), ProfileScreen()];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildWebLayout() {
    return Scaffold(
      body: Row(
        children: [
          SideBar(selectedIndex: _selectedIndex, onTap: _onTap),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 600
            ? _buildMobileLayout()
            : _buildWebLayout();
      },
    );
  }
}
