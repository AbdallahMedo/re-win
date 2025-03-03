import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycling_app/views/register_view.dart';
import 'package:recycling_app/widgets/navigation.dart';
import '../services/auth_services.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  final AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;


    // void _login() async {
    //   if (_phoneNumber.text.isEmpty || _password.text.isEmpty) {
    //     Fluttertoast.showToast(
    //       msg: "Please fill all fields",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.black38,
    //       textColor: Colors.white,
    //     );
    //     return;
    //   }
    //
    //   User? user = await _authServices.login(
    //     _phoneNumber.text,
    //     _password.text,
    //   );
    //
    //   if (user != null) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => RecycleApp()),
    //     );
    //   }
    // }
    void _login() async {
      String phone = _phoneNumber.text.trim();
      String password = _password.text.trim();

      if (phone.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(msg: "All fields are required");
        return;
      }

      User? user = await _authServices.signIn(phone, password);
      if (user != null) {
        // Fetch user data from Firestore
        var userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        String firstName = userData['firstName'] ?? "User";
        String lastName= userData['lastName'] ?? "User";

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecycleApp(firstName: firstName ,phoneNumber: phone, lastName: lastName,),
          ),
        );
      }
    }


    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double containerWidth = constraints.maxWidth * 0.85;
              if (constraints.maxWidth > 600) {
                containerWidth = 400; // Fixed width for tablets
              }

              return Container(
                width: containerWidth,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Phone Number Field
                    CustomTextField(
                      color: Colors.grey,
                      controller: _phoneNumber,
                      hintText: "Phone number",
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Password Field
                    CustomPasswordField(
                      controller: _password,
                    ),
                    const SizedBox(height: 10),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Sign-up Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return RegisterView();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
