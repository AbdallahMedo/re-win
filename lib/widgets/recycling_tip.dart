import 'package:flutter/material.dart';

class RecyclingTip extends StatefulWidget {
  const RecyclingTip({super.key});

  @override
  _RecyclingTipState createState() => _RecyclingTipState();
}

class _RecyclingTipState extends State<RecyclingTip> {
  int _tipIndex = 0;

  final List<Map<String, String>> _tips = [
    {
      "title": "Plastic",
      "number": "#1",
      "description":
      "Items like plastic bags and wraps can jam machines. Instead, take them to designated drop-off locations."
    },
    {
      "title": "Glass",
      "number": "#2",
      "description":
      "Glass can be endlessly recycled. Rinse glass containers before recycling them to prevent contamination."
    },
    {
      "title": "Metal",
      "number": "#3",
      "description":
      "Aluminum cans are 100% recyclable. Make sure to crush cans to save space before recycling."
    },
    {
      "title": "Paper",
      "number": "#4",
      "description":
      "Avoid recycling wet or greasy paper (like pizza boxes). Only clean paper should go in the recycling bin."
    },
  ];

  void _nextTip() {
    setState(() {
      _tipIndex = (_tipIndex + 1) % _tips.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tips on recycling:",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

          // Animated Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (widget, animation) => FadeTransition(opacity: animation, child: widget),
            child: Column(
              key: ValueKey<int>(_tipIndex),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tips[_tipIndex]["title"]!,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  _tips[_tipIndex]["number"]!,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  _tips[_tipIndex]["description"]!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),
          Center(
            child: ElevatedButton(
              onPressed: _nextTip,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
