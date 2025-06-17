import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetDataDialog {
  static Future<void> show({
    required BuildContext context,
    required String userId,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Method'),
          content: const Text(
            'Payment method integration will be implemented in future updates. '
                'Would you like to reset all your recycling data to zero instead?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Reset Data'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                await _resetUserData(userId);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> _resetUserData(String userId) async {
    try {
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('users/$userId/recycling_data').update({
        'can': 0,
        'glass': 0,
        'plastic': 0,
        'total': 0,
        'totalRecycled': 0,
      });
      Fluttertoast.showToast(
        msg: 'All data has been reset to zero',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error resetting data: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }
}