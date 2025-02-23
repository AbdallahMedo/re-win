import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/Profile_view.dart';
import '../views/reward_list_view.dart';
import '../views/reward_system_view.dart';
import '../views/home_view.dart';


class RecycleApp extends StatefulWidget {

  // final String? firstName;
  // final String? lastName;
  // final String? phone;

  // const RecycleApp({super.key, this.firstName, this.lastName, this.phone});
  @override
  _RecycleAppState createState() => _RecycleAppState();
}

class _RecycleAppState extends State<RecycleApp> {


  final PageController _pageController = PageController(initialPage: 0);
  late List<Widget> _pages;
  int _selectedIndex = 0;
  @override
  void initState() {
     _pages = [
      HomeView(),
      const RewardSystemView(),
      const RewardsListView(),
      const ProfileView(),
    ];

  }
  // Pages


  // Handle Navigation
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handle back button on Android
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      _onItemTapped(0); // Navigate back to Home
      return false; // Prevent app exit
    }
    return true; // Allow exit if already on Home
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _pages,
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Reward"),
            BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Count"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

