import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recycling_app/features/login/presentation/view/login_view.dart';
import 'package:recycling_app/widgets/navigation.dart';
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
    String firstName = _firstName.text.trim();
    String lastName = _lastName.text.trim();
    String phone = _phoneNumber.text.trim();
    String password = _password.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required", backgroundColor: Colors.black38);
      return;
    }

    if (!isChecked) {
      Fluttertoast.showToast(msg: "You must accept the terms and conditions!", backgroundColor: Colors.black38);
      return;
    }

    if (phone.length != 11) {
      Fluttertoast.showToast(msg: "Phone number must be 11 digits.");
      return;
    }

    if (password.length < 6) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters.");
      return;
    }

    context.read<RegisterCubit>().registerUser(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xff0B3D02),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(child: CircularProgressIndicator(color:Colors.green,)),
            );
          } else if (state is RegisterSuccess) {
            Navigator.pop(context); // remove loading
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RecycleApp(
                  firstName: _firstName.text.trim(),
                  lastName: _lastName.text.trim(),
                  phoneNumber: _phoneNumber.text.trim(),
                ),
              ),
            );
          } else if (state is RegisterFailure) {
            Navigator.pop(context); // remove loading
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

