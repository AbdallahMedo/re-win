import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up
  Future<User?> signUp(String firstName, String lastName, String phone, String password) async {
    try {
      // Creating user with a fake email (Firebase requires email format)
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: "$phone@myapp.com",
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot userDoc = await userDocRef.get();

        // Ensure Firestore document is created
        if (!userDoc.exists) {
          await userDocRef.set({
            'firstName': firstName,
            'lastName': lastName,
            'phone': phone,
            'uid': user.uid,
          });
        }

        Fluttertoast.showToast(msg: "Sign-Up Successful", backgroundColor: Colors.green);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}", backgroundColor: Colors.black38);
    }
    return null;
  }

  // Sign In
  Future<User?> signIn(String phone, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$phone@myapp.com",
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          Fluttertoast.showToast(msg: "User data not found. Please sign up again.", backgroundColor: Colors.red);
          await user.delete(); // Remove orphaned user
          return null;
        }

        Fluttertoast.showToast(msg: "Login Successful", backgroundColor: Colors.green);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}", backgroundColor: Colors.black38);
    }
    return null;
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: "Logged Out Successfully", backgroundColor: Colors.black38);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}", backgroundColor: Colors.black38);
    }
  }

  // Handle Authentication Errors
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
        message = "Authentication error: ${e.message}";
    }
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.black38);
  }
}
