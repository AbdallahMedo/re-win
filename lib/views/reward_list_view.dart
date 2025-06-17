import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/reward_item.dart';
import '../widgets/reward_web_view.dart';

class RewardsListView extends StatefulWidget {
  const RewardsListView({super.key});

  @override
  State<RewardsListView> createState() => _RewardsListViewState();
}

class _RewardsListViewState extends State<RewardsListView> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("re-win");

  int plastic = 0;
  int can = 0;
  int glass = 0;
  int totalRecycled = 0; // Track total recycled items (not points)
  int total=0;

  @override
  void initState() {
    super.initState();
    _listenToFirebase();
    _listenToFirebaseTotalPoints();
  }

  void _listenToFirebase() {
    _databaseRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map<dynamic, dynamic>) {
        setState(() {
          plastic = (data['plastic'] ?? 0) as int;
          can = (data['can'] ?? 0) as int;
          glass = (data['glass'] ?? 0) as int;
          totalRecycled = (data['totalRecycled'] ?? 0) as int; // Load from Firebase
        });

        // Update totalRecycled in Firebase whenever counts change
        _updateTotalRecycled();
      }
    });
  }

  void _updateTotalRecycled() {
    final newTotalRecycled = plastic + can + glass;

    // Only update if the value changed
    if (newTotalRecycled != totalRecycled) {
      _databaseRef.update({'totalRecycled': newTotalRecycled});
    }
  }


  void _listenToFirebaseTotalPoints() {
    _databaseRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map<dynamic, dynamic>) {
        setState(() {
          plastic = (data['plastic'] ?? 0) as int;
          can = (data['can'] ?? 0) as int;
          glass = (data['glass'] ?? 0) as int;
          total = (data['total'] ?? 0) as int;
        });

        // Calculate and update total whenever individual items change
        _updateTotal();
      }
    });
  }

  void _updateTotal() {
    // Calculate the new total
    final newTotal = (plastic + can + glass) * 50;

    // Only update if the total has changed
    if (newTotal != total) {
      _databaseRef.update({'total': newTotal});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rewards = [
      {
        "title": "Plastic",
        "points": plastic * 50,
        "imagePath": "assets/images/Plastic - PNG.png",
        "recycledCount": plastic,
      },
      {
        "title": "Can",
        "points": can * 50,
        "imagePath": "assets/images/Can - Png 1.png",
        "recycledCount": can,
      },
      {
        "title": "Glass",
        "points": glass * 50,
        "imagePath": "assets/images/Glass - PNG.png",
        "recycledCount": glass,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "Rewards",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Colors.amber[800], size: 20),
                const SizedBox(width: 4),
                Text(
                  "${(plastic + can + glass) * 50} pts",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
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