import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycling_app/features/register/presentation/view/register_view.dart';
import 'package:recycling_app/widgets/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/auth_services.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _rememberMe = false;
  bool _isCheckingLogin = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('isLoggedIn') ?? false;
      if (_rememberMe) {
        _phoneNumber.text = prefs.getString('phone') ?? '';
      }
      _isCheckingLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingLogin) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green,)),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => LoginCubit(AuthServices()),
      child: Scaffold(
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

                return BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      Fluttertoast.showToast(msg: state.error);
                    } else if (state is LoginSuccess) {
                      _navigateToHome(context, state.user);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginSuccess) {
                      return const Center(child: CircularProgressIndicator());
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

                          // Remember Me Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                  context
                                      .read<LoginCubit>()
                                      .toggleRememberMe(value!);
                                },
                              ),
                              const Text("Remember Me"),
                            ],
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
                              onPressed: state is LoginLoading
                                  ? null
                                  : () {
                                      if (_phoneNumber.text.isEmpty ||
                                          _password.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "All fields are required");
                                        return;
                                      }
                                      context.read<LoginCubit>().login(
                                            phone: _phoneNumber.text.trim(),
                                            password: _password.text.trim(),
                                          );
                                    },
                              child: state is LoginLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
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
                                      builder: (context) =>
                                          const RegisterView(),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToHome(BuildContext context, User user) async {
    // Fetch user data from Firestore
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    String firstName = userData['firstName'] ?? "User";
    String lastName = userData['lastName'] ?? "User";

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecycleApp(
          firstName: firstName,
          phoneNumber: _phoneNumber.text.trim(),
          lastName: lastName,
        ),
      ),
    );
  }
}
