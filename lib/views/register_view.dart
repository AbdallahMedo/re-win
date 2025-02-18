import 'package:flutter/material.dart';
import 'package:recycling_app/views/login_view.dart';

import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isChecked = false;
  // bool isPasswordVisible = false; // Toggles password visibility

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xff0B3D02), // Green gradient background
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: isTablet ? screenWidth * 0.5 : screenWidth * 0.85,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.04,
              horizontal: screenWidth * 0.06,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  "Please register to login.",
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(child: CustomTextField(hintText: "First name")),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(child: CustomTextField(hintText: "Last name")),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(hintText: "Phone number"),
                SizedBox(height: screenHeight * 0.02),
                CustomPasswordField(),// Password field with visibility toggle
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    const Text(
                      "I Agree With All ",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {}, // Add navigation to T&C page
                      child: const Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff619938),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff87c15a),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already hav an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginView();
                            },
                          ),
                        );
                      }, // Navigate to Sign Up page
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff619938),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField(String hint) {
  //   return TextField(
  //     decoration: InputDecoration(
  //       hintText: hint,
  //       hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
  //       filled: true,
  //       fillColor: const Color(0xffF7F6F5),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10),
  //         borderSide: BorderSide.none,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPasswordField() {
  //   return TextField(
  //     obscureText: !isPasswordVisible, // Toggle password visibility
  //     decoration: InputDecoration(
  //       hintText: "Password",
  //       hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
  //       filled: true,
  //       fillColor: const Color(0xffF7F6F5),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10),
  //         borderSide: BorderSide.none,
  //       ),
  //       suffixIcon: IconButton(
  //         icon: Icon(
  //           isPasswordVisible ? Icons.visibility : Icons.visibility_off,
  //           color: Colors.black45,
  //         ),
  //         onPressed: () {
  //           setState(() {
  //             isPasswordVisible = !isPasswordVisible;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }
}
