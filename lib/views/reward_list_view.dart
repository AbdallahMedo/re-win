import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/reward_item.dart';
import '../widgets/reward_web_view.dart';

class RewardsListView extends StatefulWidget {
  final String uid; // Accept user UID as parameter
  const RewardsListView({super.key, required this.uid});

  @override
  State<RewardsListView> createState() => _RewardsListViewState();
}

class _RewardsListViewState extends State<RewardsListView> {
  late DatabaseReference _databaseRef;
  int plastic = 0;
  int can = 0;
  int glass = 0;
  int totalRecycled = 0;
  int total = 0;
  StreamSubscription<DatabaseEvent>? _dataSubscription;
  StreamSubscription<DatabaseEvent>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref("users/${widget.uid}/recycling_data");
    _setupConnectionMonitoring();
    _setupRealtimeUpdates();
  }

  void _setupConnectionMonitoring() {
    _connectionSubscription = FirebaseDatabase.instance
        .ref('.info/connected')
        .onValue
        .listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      print("Firebase connection: $connected");
    });
  }

  void _setupRealtimeUpdates() {
    _dataSubscription = _databaseRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data is Map<dynamic, dynamic> && mounted) {
        final newPlastic = (data['plastic'] ?? 0) as int;
        final newCan = (data['can'] ?? 0) as int;
        final newGlass = (data['glass'] ?? 0) as int;

        print("""
        New data received:
        - Plastic: $newPlastic
        - Can: $newCan
        - Glass: $newGlass
        """);

        setState(() {
          plastic = newPlastic;
          can = newCan;
          glass = newGlass;
          totalRecycled = (data['totalRecycled'] ?? 0) as int;
          total = (data['total'] ?? 0) as int;
        });

        _updateCalculatedValues();
      }
    }, onError: (error) {
      print("Firebase error: $error");
    });
  }

  Future<void> _updateCalculatedValues() async {
    try {
      final newTotalRecycled = plastic + can + glass;
      final newTotal = newTotalRecycled * 50;

      final updates = {
        if (newTotalRecycled != totalRecycled) 'totalRecycled': newTotalRecycled,
        if (newTotal != total) 'total': newTotal,
      };

      if (updates.isNotEmpty) {
        print("Attempting to write updates: $updates");
        await _databaseRef.update(updates);
        print("Updates written successfully");
      }
    } catch (e) {
      print("Failed to update calculated values: $e");
    }
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
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
                  "$total pts",
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