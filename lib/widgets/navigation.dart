import 'package:flutter/material.dart';

import '../views/Profile_view.dart';
import '../views/reward_list_view.dart';
import '../views/reward_system_view.dart';
import '../views/home_view.dart';


class RecycleApp extends StatefulWidget {
  @override
  _RecycleAppState createState() => _RecycleAppState();
}

class _RecycleAppState extends State<RecycleApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const RewardSystemView(),
    const RewardsListView(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.green.withOpacity(0.5),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outlined), label: 'Reward'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Count'),

            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
