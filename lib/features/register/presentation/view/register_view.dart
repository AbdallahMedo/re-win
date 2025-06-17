import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../widgets/navigation.dart';
import '../../../login/presentation/view/login_view.dart';
import '../../../login/presentation/widgets/custom_password_field.dart';
import '../../../login/presentation/widgets/custom_text_field.dart';
import '../../cubit/register_cubit.dart';
import '../../cubit/register_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isChecked = false;

  void _register() {
    if (_validateInputs()) {
      context.read<RegisterCubit>().registerUser(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        phone: _phoneNumber.text.trim(),
        password: _password.text.trim(),
      );
    }
  }

  bool _validateInputs() {
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _phoneNumber.text.isEmpty ||
        _password.text.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required");
      return false;
    }

    if (!isChecked) {
      Fluttertoast.showToast(msg: "Please accept terms & conditions");
      return false;
    }

    if (_phoneNumber.text.length != 11) {
      Fluttertoast.showToast(msg: "Phone must be 11 digits");
      return false;
    }

    if (_password.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be 6+ characters");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xff0B3D02),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.green)),
            );
          } else if (state is RegisterSuccess) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RecycleApp(
                  uid: state.uid,
                  firstName: _firstName.text.trim(),
                  lastName: _lastName.text.trim(),
                  phoneNumber: _phoneNumber.text.trim(),
                ),
              ),
            );
          } else if (state is RegisterFailure) {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: state.error);
          }
        },
        child: Center(
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
                      Expanded(
                        child: CustomTextField(
                          color: Colors.grey,
                          hintText: "First name",
                          controller: _firstName,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: CustomTextField(
                          color: Colors.grey,
                          hintText: "Last name",
                          controller: _lastName,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(
                    color: Colors.grey,
                    hintText: "Phone number",
                    controller: _phoneNumber,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomPasswordField(controller: _password),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() => isChecked = value!);
                        },
                        activeColor: Colors.green,
                      ),
                      const Text(
                        "I Agree With All ",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show terms
                        },
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
                      onPressed: _register,
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginView(),
                          ));
                        },
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
      ),
    );
  }
}