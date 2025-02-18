import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !isPasswordVisible, // Toggle password visibility
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
        filled: true,
        fillColor: const Color(0xffF7F6F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black45,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
