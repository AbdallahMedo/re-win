import 'dart:math';
import 'package:flutter/material.dart';

class RewardItem extends StatelessWidget {
  final String title;
  final int points;
  final String imagePath;
  final int recycledCount;
  final VoidCallback onTap;

  const RewardItem({
    super.key,
    required this.title,
    required this.points,
    required this.imagePath,
    required this.recycledCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Random color for the circular counter
    final List<Color> colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple,Colors.black,Colors.cyan,];
    final Color randomColor = colors[Random().nextInt(colors.length)];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F6F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: screenWidth * 0.15),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Points: $points",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Circular Recycled Counter
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: randomColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                recycledCount.toString(),
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
