import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Function
  Future<User?> signUp(String? firstName, String? lastName, String phone, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: "$phone@example.com", // Firebase Auth requires email, so we fake it
        password: password,
      );

      User? user = userCredential.user;
      String displayName = "${firstName ?? "User"} ${lastName ?? ""}".trim();

      await user?.updateDisplayName(displayName);

      Fluttertoast.showToast(msg: "Sign-up successful!", backgroundColor: Colors.green);
      return user;
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
      return null;
    }
  }

  // Login Function
  Future<User?> login(String phone, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$phone@example.com",
        password: password,
      );

      Fluttertoast.showToast(msg: "Login successful!", backgroundColor: Colors.green);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
      return null;
    }
  }

  // Logout Function
  Future<void> logout() async {
    await _auth.signOut();
    Fluttertoast.showToast(msg: "Logged out successfully!", backgroundColor: Colors.black38);
  }

  // Handle Firebase Errors
  void _handleAuthErrors(FirebaseAuthException e) {
    String message;
    if (e.code == 'weak-password') {
      message = "The password is too weak.";
    } else if (e.code == 'email-already-in-use') {
      message = "Phone already exists for this phone.";
    } else if (e.code == 'user-not-found') {
      message = "No user found for this phone.";
    } else if (e.code == 'wrong-password') {
      message = "Incorrect password.";
    } else {
      message = "Error: ${e.message}";
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
    );
  }
}
