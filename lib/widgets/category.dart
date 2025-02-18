import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback ontap;

  const Category({
    Key? key,
    required this.ontap,
    required this.imagePath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffF7F6F5),
        ),
        width: screenWidth * (isTablet ? 0.15 : 0.2),  // Adjusts width based on screen size
        height: screenHeight * 0.15,  // Scales height dynamically
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: screenHeight * 0.08,  // Makes the image responsive
              ),
              SizedBox(height: screenHeight * 0.008),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 12, // Increases font size on tablets
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
