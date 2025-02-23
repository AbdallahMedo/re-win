import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recycling_app/views/glass_category.dart';
import 'package:recycling_app/views/paper_category.dart';
import 'package:recycling_app/views/plastic_category.dart';
import '../widgets/category.dart';
import '../widgets/custom_list_items.dart';
import '../widgets/scores.dart';
import 'can_category.dart';

class HomeView extends StatefulWidget {
  String? firstName;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String firstName = "";
  String lastName = "";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        firstName = userDoc['firstName'];
        lastName = userDoc['lastName'];
        imageUrl = userDoc['imageUrl'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName =
        widget.firstName?.isNotEmpty == true ? widget.firstName! : "User";
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : AssetImage("assets/images/person.png"),
              radius: 20.0,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              "Hello, $displayName",
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
              // Scores Section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff87c15a),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Scores(
                        imagePath: "assets/images/Coins - SVG.svg",
                        score: "150\$",
                        result: "EARNED"),
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                        width: 20,
                      ),
                    ),
                    const Scores(
                        imagePath: "assets/images/Cloud - SVG.svg",
                        score: "500g",
                        result: "SAVED CO2"),
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                        width: 20,
                      ),
                    ),
                    const Scores(
                        imagePath: "assets/images/Recycle - SVG.svg",
                        score: "50",
                        result: "Recycled"),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Waste Categories Section
              _buildSectionHeader(
                title: "Waste Categories",
                subtitle: "Click to know how to recycle",
                isTablet: isTablet,
              ),
              SizedBox(height: screenHeight * 0.015),

              // Categories Responsive Grid
              Wrap(
                spacing: screenWidth * 0.03,
                runSpacing: screenHeight * 0.05,
                alignment: WrapAlignment.center,
                children: [
                  Category(
                    imagePath: "assets/images/Plastic - PNG.png",
                    title: "Plastic",
                    ontap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PlasticCategory(),
                      ));
                    },
                  ),
                  Category(
                    imagePath: "assets/images/Can - Png 1.png",
                    title: "Can",
                    ontap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CanCategory(),
                      ));
                    },
                  ),
                  Category(
                    imagePath: "assets/images/Glass - PNG.png",
                    title: "Glass",
                    ontap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const GlassCategory(),
                      ));
                    },
                  ),
                  Category(
                    imagePath: "assets/images/recycling-paper.png",
                    title: "Paper",
                    ontap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PaperCategory(),
                      ));
                    },
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),

              // Nearby Bin Stations Section
              _buildSectionHeader(
                  title: "Nearby Bin Stations", isTablet: isTablet),
              SizedBox(height: screenHeight * 0.02),
              _buildImageContainer("assets/images/Map.png", screenHeight),

              // Eco-Friendly Tips Section
              _buildSectionHeader(
                  title: "ECO - Friendly Tips", isTablet: isTablet),
              SizedBox(height: screenHeight * 0.02),

              // Tip Cards
              const CustomCard(
                imagePath: "assets/images/Home - PNG.png",
                // Replace with your image path
                title: "At-Home Recycling Tips :",
                description:
                    "Repurpose Glass Jars & Bottles Use them for storage, flower vases, or DIY crafts.\n"
                    "Compost Organic Waste – Food scraps and yard waste can become nutrient-rich compost.\n"
                    "Upcycle Furniture – Give old furniture a second life with some creativity and paint.",
              ),

              SizedBox(height: screenHeight * 0.02),
              const CustomCard(
                imagePath: "assets/images/Technology - PNG.png",
                // Replace with actual image path
                title: "Electronic Recycling Tips :",
                description:
                    "Donate Old Electronics – Many charities or repair shops will take used electronics.\n"
                    "Recycle Batteries – Special e-waste collection points exist for safe disposal.\n"
                    "Trade-In Programs – Some companies (like Apple & Best Buy) offer discounts when you recycle old devices.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader(
      {required String title, String? subtitle, required bool isTablet}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xffa7d482),
            ),
          ),
      ],
    );
  }

  // Image Container
  Widget _buildImageContainer(String path, double screenHeight) {
    return Container(
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
