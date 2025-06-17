import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _rtdb = FirebaseDatabase.instance.ref();

  // Sign Up - Now creates both auth user AND initializes RTDB data
  Future<String?> signUp(String firstName, String lastName, String phone, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: "$phone@myapp.com",
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        // Initialize user data in Realtime DB
        await _rtdb.child('users/$uid').set({
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'recycling_data': {
            'can': 0,
            'glass': 0,
            'plastic': 0,
            'total': 0,
            'totalRecycled': 0
          }
        });

        Fluttertoast.showToast(msg: "Sign-Up Successful", backgroundColor: Colors.green);
        return uid; // Return UID instead of User object
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error: ${e.toString()}", backgroundColor: Colors.black38);
    }
    return null;
  }

  // Sign In - Returns UID if successful
  Future<String?> signIn(String phone, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$phone@myapp.com",
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        // Verify user exists in RTDB
        final snapshot = await _rtdb.child('users/$uid').get();
        if (!snapshot.exists) {
          Fluttertoast.showToast(
              msg: "User data not found. Please sign up again.",
              backgroundColor: Colors.red
          );
          await userCredential.user!.delete();
          return null;
        }

        Fluttertoast.showToast(msg: "Login Successful", backgroundColor: Colors.green);
        return uid; // Return UID instead of User object
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error: ${e.toString()}", backgroundColor: Colors.black38);
    }
    return null;
  }

  // Sign Out - No changes needed
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Clear any cached credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('phone');
      await prefs.remove('password');
      Fluttertoast.showToast(msg: "Logged Out Successfully", backgroundColor: Colors.black38);
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error: ${e.toString()}", backgroundColor: Colors.black38);
      rethrow; // Important to rethrow so the caller knows logout failed
    }
  }
  // Get current user's UID (helper method)
  String? get currentUID => _auth.currentUser?.uid;

  // Get reference to current user's recycling data (helper method)
  DatabaseReference get currentUserRecyclingRef {
    final uid = currentUID;
    if (uid == null) throw Exception("User not logged in");
    return _rtdb.child('users/$uid/recycling_data');
  }

  // Error handling - No changes needed
  void _handleAuthErrors(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'weak-password':
        message = "The password provided is too weak.";
        break;
      case 'email-already-in-use':
        message = "This phone number is already registered.";
        break;
      case 'user-not-found':
        message = "No user found for this phone number.";
        break;
      case 'wrong-password':
        message = "Incorrect password. Try again.";
        break;
      default:
        message = "Authentication error";
    }
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.black38);
  }
}