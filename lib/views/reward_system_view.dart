import 'package:flutter/material.dart';
import 'package:recycling_app/views/Profile_view.dart';
import '../widgets/navigation.dart';
import '../widgets/recycling_tip.dart';
import '../widgets/reward_card.dart';
import '../widgets/reward_dialog.dart';

class RewardSystemView extends StatelessWidget {
  const RewardSystemView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.green),
        //   onPressed: () {
        //     // Navigator.push(context, MaterialPageRoute(builder: (context){return RecycleApp();}));
        //   },
        // ),
        title: const Text(
          "Reward System",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.person, color: Colors.green),
          //   onPressed: () {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context){return ProfileView();}));
          //   },
          // ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Your Reward Section
              const Text(
                "Your reward",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RewardDialog(
                title: "Golden Cup",
                description:
                "You have recycled more than 5kg of plastic. We thank you for your contribution.\nKeep taking care of our planet and recycle to get new rewards and coins.",
                imagePath: "assets/images/Cup 1 - PNG.png",
              ),
              const SizedBox(height: 20),

              // Your Coins Section
              const Text(
                "Your Coins",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RewardCard(
                title: "50 coins",
                description:
                "For each item recycled, you get a different number of coins that you can spend in the app or send as coins to your wallet or account.",
                imagePath: "assets/images/Coins 2 - PNG.png",
              ),
              const SizedBox(height: 20),

              // Tips Section
              RecyclingTip(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}