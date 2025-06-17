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
import '../widgets/section_header.dart';
import '../widgets/scores.dart';

class HomeView extends StatefulWidget {
  final String firstName;
  const HomeView({super.key, required this.firstName});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? imagePath;
  int totalRecycled = 0;
  int plastic = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _fetchRealtimeData();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('profileImage');
    });
  }

  void _fetchRealtimeData() {
    final ref = FirebaseDatabase.instance.ref('re-win');
    ref.onValue.listen((event) {
      final data = event.snapshot.value as Map;
      setState(() {
        totalRecycled = data['totalRecycled'] ?? 0;
        plastic = data['plastic'] ?? 0;
        total = data['total'] ?? 0;
      });
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
              backgroundImage: imagePath != null
                  ? FileImage(File(imagePath!))
                  : const AssetImage("assets/images/person.png") as ImageProvider,
              radius: 20.0,
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
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                "Total Points: $total",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff619938),
                    fontSize: 16),
              ),
            ),
          ),
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
                          score: "${earnings.toStringAsFixed(1)} Coin",
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
                          score: "${savedCO2.toStringAsFixed(1)}g",
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
                        icon: const Icon(Icons.info_outline, color: Colors.grey),
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
                      MaterialPageRoute(builder: (_) => const PlasticCategory()),
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
              buildSectionHeader(title: "Nearby Bin Stations", isTablet: isTablet),
              SizedBox(height: screenHeight * 0.02),
              ImageContainer(path: "assets/images/Map.png", screenHeight: screenHeight),

              buildSectionHeader(title: "ECO - Friendly Tips", isTablet: isTablet),
              SizedBox(height: screenHeight * 0.02),
              const CustomCard(
                imagePath: "assets/images/Home - PNG.png",
                title: "At-Home Recycling Tips :",
                description:
                "Repurpose Glass Jars & Bottles\n"
                    "Compost Organic Waste\n"
                    "Upcycle Furniture",
              ),
              SizedBox(height: screenHeight * 0.02),
              const CustomCard(
                imagePath: "assets/images/Technology - PNG.png",
                title: "Electronic Recycling Tips :",
                description:
                "Donate Old Electronics\n"
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
