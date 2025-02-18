import 'package:flutter/material.dart';

import '../widgets/reward_item.dart';
import '../widgets/reward_web_view.dart';


class RewardsListView extends StatelessWidget {
  const RewardsListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> rewards = [
      {
        "title": "Plastic",
        "points": 500,
        "imagePath": "assets/images/Plastic - PNG.png",
        "recycledCount": 5
      },
      {
        "title": "Can",
        "points": 300,
        "imagePath": "assets/images/Can - Png 1.png",
        "recycledCount": 5,
      },
      {
        "title": "Glass",
        "points": 200,
        "imagePath": "assets/images/Glass - PNG.png",
        "recycledCount": 5,
      },
      {
        "title": "Paper",
        "points": 100,
        "imagePath": "assets/images/recycling-paper.png",
        "recycledCount": 5

      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Rewards"),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          return RewardItem(
            title: rewards[index]["title"],
            points: rewards[index]["points"],
            imagePath: rewards[index]["imagePath"],
            recycledCount: rewards[index]["recycledCount"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(
                    title: rewards[index]["title"],
                    points: rewards[index]["points"],
                    imagePath: rewards[index]["imagePath"],
                    recycledCount: rewards[index]["recycledCount"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
