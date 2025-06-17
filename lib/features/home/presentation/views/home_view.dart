import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recycling_app/features/categories/presentation/views/glass_category.dart';
import 'package:recycling_app/features/categories/presentation/views/paper_category.dart';
import 'package:recycling_app/features/categories/presentation/views/plastic_category.dart';
import '../../../categories/presentation/views/can_category.dart';
import '../widgets/category.dart';
import '../widgets/custom_list_items.dart';
import '../widgets/image_container.dart';
import '../widgets/pin_station_card.dart';
import '../widgets/recycled_info.dart';
import '../widgets/section_header.dart';
import '../widgets/scores.dart';

class HomeView extends StatefulWidget {
  final String firstName;
  final String? uid; // Added optional UID parameter

  const HomeView({super.key, required this.firstName, this.uid});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? imagePath;
  int totalRecycled = 0;
  int plastic = 0;
  int total = 0;
  DatabaseReference? _userRef; // Reference to user's data

  @override
  void initState() {
    super.initState();
    loadProfileImage(widget.uid!);
    _initializeData();
  }

  String? base64Image;


  Future<void> loadProfileImage(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    imagePath = prefs.getString('profileImage_$uid');
    setState(() {});
  }

  void _initializeData() {
    if (widget.uid != null) {
      // User is logged in - use user-specific data
      _userRef =
          FirebaseDatabase.instance.ref('users/${widget.uid}/recycling_data');
      _fetchUserData();
    } else {
      // Guest mode - show zeros or default values
      setState(() {
        totalRecycled = 0;
        plastic = 0;
        total = 0;
      });
    }
  }

  void _fetchUserData() {
    _userRef?.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        setState(() {
          totalRecycled = (data['totalRecycled'] ?? 0) as int;
          plastic = (data['plastic'] ?? 0) as int;
          total = (data['total'] ?? 0) as int;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    double savedCO2 = plastic * 1.08;
    double earnings = (total / 100) * 20;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: imagePath != null
                  ? FileImage(File(imagePath!))
                  : const AssetImage('assets/images/person.png') as ImageProvider,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              "Hello, ${widget.firstName}",
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Color(0xff619938),
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    constraints: const BoxConstraints(minWidth: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xff87c15a), Color(0xff619938)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "Total Points: $total",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RecycledInfoPage(userId: widget.uid!),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xff87c15a), Color(0xff619938)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Recycled Info",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Scores Section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff87c15a),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Scores(
                          imagePath: "assets/images/Coins - SVG.svg",
                          score: "${earnings.toStringAsFixed(0)} Coin",
                          result: "EARNED",
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                          child: const VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                            width: 20,
                          ),
                        ),
                        Scores(
                          imagePath: "assets/images/Cloud - SVG.svg",
                          score: "${savedCO2.toStringAsFixed(2)}g",
                          result: "SAVED CO2",
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                          child: const VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                            width: 20,
                          ),
                        ),
                        Scores(
                          imagePath: "assets/images/Recycle - SVG.svg",
                          score: "$totalRecycled",
                          result: "RECYCLED",
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 60,
                      right: 325,
                      child: IconButton(
                        icon:
                            const Icon(Icons.info_outline, color: Colors.grey),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("How Scores Are Calculated"),
                              content: const Text(
                                "• 1 Plastic = 1.08g CO2 Saved\n"
                                "• Every 100 Points = 20 Coins\n"
                                "• Total Recycled = All items recycled",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Waste Categories
              buildSectionHeader(
                title: "Waste Categories",
                subtitle: "Click to know how to recycle",
                isTablet: isTablet,
              ),
              SizedBox(height: screenHeight * 0.015),
              Wrap(
                spacing: screenWidth * 0.03,
                runSpacing: screenHeight * 0.05,
                alignment: WrapAlignment.center,
                children: [
                  Category(
                    imagePath: "assets/images/Plastic - PNG.png",
                    title: "Plastic",
                    ontap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const PlasticCategory()),
                    ),
                  ),
                  Category(
                    imagePath: "assets/images/Can - Png 1.png",
                    title: "Can",
                    ontap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CanCategory()),
                    ),
                  ),
                  Category(
                    imagePath: "assets/images/Glass - PNG.png",
                    title: "Glass",
                    ontap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GlassCategory()),
                    ),
                  ),
                  Category(
                    imagePath: "assets/images/recycling-paper.png",
                    title: "Paper",
                    ontap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PaperCategory()),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),
              buildSectionHeader(
                  title: "Nearby Bin Stations", isTablet: isTablet),
              SizedBox(height: screenHeight * 0.02),
              Column(
                children: [
                  BinStationCard(
                    location: "Zamalek Bin Station",
                    address: "26th July St, Cairo",
                    imagePath: "assets/images/Map.png", // Add a nice Cairo street-style image
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  BinStationCard(
                    location: "Nasr City Recycling Point",
                    address: "Makram Ebeid St, Nasr City",
                    imagePath: "assets/images/Map.png",
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  BinStationCard(
                    location: "6th October Smart Bin",
                    address: "El Hosary Sq, 6th October",
                    imagePath: "assets/images/Map.png",
                  ),
                ],
              ),
              SizedBox(height: 10,),

              buildSectionHeader(
                  title: "ECO - Friendly Tips", isTablet: isTablet),
              SizedBox(height: screenHeight * 0.02),
              const CustomCard(
                imagePath: "assets/images/Home - PNG.png",
                title: "At-Home Recycling Tips :",
                description: "Repurpose Glass Jars & Bottles\n"
                    "Compost Organic Waste\n"
                    "Upcycle Furniture",
              ),
              SizedBox(height: screenHeight * 0.02),
              const CustomCard(
                imagePath: "assets/images/Technology - PNG.png",
                title: "Electronic Recycling Tips :",
                description: "Donate Old Electronics\n"
                    "Recycle Batteries Safely\n"
                    "Use Trade-In Programs",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
