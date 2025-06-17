import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RecycledInfoPage extends StatefulWidget {
  final String userId;

  const RecycledInfoPage({super.key, required this.userId});

  @override
  State<RecycledInfoPage> createState() => _RecycledInfoPageState();
}

class _RecycledInfoPageState extends State<RecycledInfoPage> {
  late DatabaseReference _userRef;
  Map<String, dynamic> _recyclingData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.ref('users/${widget.userId}/recycling_data');
    _loadRecyclingData();
  }

  Future<void> _loadRecyclingData() async {
    try {
      final snapshot = await _userRef.get();
      if (snapshot.exists) {
        setState(() {
          _recyclingData = Map<String, dynamic>.from(snapshot.value as Map);
          _isLoading = false;
        });
      } else {
        setState(() {
          _recyclingData = {
            'plastic': 0,
            'can': 0,
            'glass': 0,
            'total': 0,
            'totalRecycled': 0,
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  // Calculation methods
  int get _totalRecycled => (_recyclingData['totalRecycled'] ?? 0) as int;
  int get _totalPoints => (_recyclingData['total'] ?? 0) as int;
  double get _coins => _totalPoints * 0.2;
  double get _co2Saved => (_recyclingData['plastic'] ?? 0) * 1.08 +
      (_recyclingData['can'] ?? 0) * 0.92 +
      (_recyclingData['glass'] ?? 0) * 0.31;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recycling Impact',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green[700],
        leading: IconButton(onPressed: Navigator.of(context).pop, icon: Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildImpactCard(),
            const SizedBox(height: 20),
            _buildMaterialsCard(),
            const SizedBox(height: 20),
            _buildCalculationsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Your Environmental Impact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildImpactItem('🌱', 'CO2 Saved', '${_co2Saved.toStringAsFixed(2)} kg'),
                _buildImpactItem('♻️', 'Items Recycled', _totalRecycled.toString()),
                _buildImpactItem('⭐', 'Total Points', _totalPoints.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactItem(String emoji, String title, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMaterialsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Materials Recycled',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMaterialRow('Plastic', _recyclingData['plastic'] ?? 0, Colors.blue),
            _buildMaterialRow('Cans', _recyclingData['can'] ?? 0, Colors.orange),
            _buildMaterialRow('Glass', _recyclingData['glass'] ?? 0, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialRow(String material, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
        Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          material == 'Plastic' ? '🥤' :
          material == 'Cans' ? '🥫' : '🍶',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      const SizedBox(width: 16),
      Column(
        children: [
          Text(material, style: const TextStyle(fontSize: 16)),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

        ],
      ),
        ],
      ),
    );
  }

  Widget _buildCalculationsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How We Calculate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCalculationItem(
              'Plastic',
              _recyclingData['plastic'] ?? 0,
              '1.08 kg CO2 per item',
            ),
            _buildCalculationItem(
              'Cans',
              _recyclingData['can'] ?? 0,
              '0.92 kg CO2 per item',
            ),
            _buildCalculationItem(
              'Glass',
              _recyclingData['glass'] ?? 0,
              '0.31 kg CO2 per item',
            ),
            const Divider(height: 32),
            const Text(
              'Points System',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• 50 points per recycled item'),
            const Text('• 20 coins per 100 points'),
            const SizedBox(height: 8),
            Text(
              'Your coins: ${_coins.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationItem(String material, int count, String co2Info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            material,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('• Items: $count'),
          Text('• $co2Info'),
          Text('• Total: ${(count * double.parse(co2Info.split(' ')[0])).toStringAsFixed(2)} kg CO2 saved'),
        ],
      ),
    );
  }
}