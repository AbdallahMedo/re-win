import 'package:flutter/material.dart';
import '../features/login/presentation/view/login_view.dart';
import '../features/profile/presentation/view/Profile_view.dart';
import '../views/reward_list_view.dart';
import '../views/reward_system_view.dart';
import '../features/home/presentation/views/home_view.dart';

class RecycleApp extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? password;
  final String? uid; // Added optional UID parameter

  const RecycleApp({
    super.key,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.password,
    this.uid, // Optional UID
  });

  @override
  _RecycleAppState createState() => _RecycleAppState();
}

class _RecycleAppState extends State<RecycleApp> {
  late List<Widget> _pages;
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      HomeView(
        firstName: widget.firstName ?? "User",
        uid: widget.uid,
      ),
      const RewardSystemView(),
      // Only create proper RewardsListView if UID exists
      widget.uid != null
          ? RewardsListView(uid: widget.uid!)
          : _buildLoginPromptView(),
      // Profile view with UID check
      widget.uid != null
          ? ProfileView(
        firstName: widget.firstName ?? 'User',
        lastName: widget.lastName ?? 'Last Name',
        phone: widget.phoneNumber ?? "NA",
        uid: widget.uid,
      )
          : _buildLoginPromptView(),
    ];
  }

  Widget _buildLoginPromptView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please login to access this feature",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  LoginView()),
                );
              },
              child: const Text("Go to Login"),
            ),
          ],
        ),
      ),
    );
  }

// In your RecycleApp widget's _onItemTapped method:
  void _onItemTapped(int index) {
    // Block access to protected tabs (index 2=Count, 3=Profile) if not logged in
    if ((index == 2 || index == 3) && widget.uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please login to access this feature"),
            duration: Duration(seconds: 2),
          )
      );
      return; // Prevent navigation
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _selectedIndex = index);
  }
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      _onItemTapped(0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // Optional: prevent navigating to restricted pages via swipe
            if ((index == 2 || index == 3) && widget.uid == null) {
              _pageController.jumpToPage(_selectedIndex); // go back to safe page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please login to access this feature"),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              setState(() => _selectedIndex = index);
            }
          },
          children: _pages,
        ),
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