import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycling_app/views/login_view.dart';
import 'package:recycling_app/widgets/navigation.dart';
import '../services/auth_services.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServices _authServices = AuthServices();
  TextEditingController _firstName=TextEditingController();
  TextEditingController _lastName=TextEditingController();
  TextEditingController _phoneNumber=TextEditingController();
  TextEditingController _password=TextEditingController();

  void _signUp() async {
    if (
    _firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _phoneNumber.text.isEmpty ||
        _password.text.isEmpty ) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
      );
      return;
    }

    User? user = await _authServices.signUp(
      _firstName.text,
      _lastName.text,
      _phoneNumber.text,
      _password.text,
    );
    if (user != null) {
      // await _firestore.collection('users').doc(user.uid).set({
      //   'firstName': _firstName.text,
      //   'lastName': _lastName.text,
      //   'phone': _phoneNumber.text,
      //   'imageUrl': "",
      // });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RecycleApp(
          // firstName: _firstName.text,
          // lastName: _lastName.text,
          // phone: _phoneNumber.text,
        )
        ),
      );
    }
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
                      Expanded(child: CustomTextField(hintText: "First name",controller: _firstName,)),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(child: CustomTextField(hintText: "Last name",controller: _lastName,)),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(hintText: "Phone number",controller: _phoneNumber,),
                  SizedBox(height: screenHeight * 0.02),
                  CustomPasswordField(controller: _password,),// Password field with visibility toggle
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
                      onPressed: _signUp,
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
                        "Sign up",
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
                      const Text("Already have an account? "),
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


  }
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
                    Expanded(child: CustomTextField(hintText: "First name",controller: _firstName,)),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(child: CustomTextField(hintText: "Last name",controller: _lastName,)),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(hintText: "Phone number",controller: _phoneNumber,),
                SizedBox(height: screenHeight * 0.02),
                CustomPasswordField(controller: _password,),// Password field with visibility toggle
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
                    onPressed: _signUp,
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
                      "Sign up",
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


}
