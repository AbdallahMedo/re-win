import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isPasswordReset;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.isPasswordReset,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  String? _verificationId;
  bool _isLoading = false;
  bool _isResending = false;
  int _resendTimeout = 60;
  late Timer _resendTimer;
  int? _resendToken;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _sendOtp();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _resendTimer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        setState(() {
          _resendTimeout--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: _handleVerificationCompleted,
        verificationFailed: _handleVerificationFailed,
        codeSent: _handleCodeSent,
        codeAutoRetrievalTimeout: _handleCodeTimeout,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      _handleGenericError(e);
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
      _resendTimeout = 60;
    });

    await _sendOtp();
    _startResendTimer();

    setState(() {
      _isResending = false;
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6 || _verificationId == null) {
      Fluttertoast.showToast(msg: "Please enter a valid 6-digit OTP");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateAfterVerification();
    } on FirebaseAuthException catch (e) {
      _handleVerificationFailed(e);
    } catch (e) {
      _handleGenericError(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVerificationCompleted(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateAfterVerification();
    } catch (e) {
      _handleGenericError(e);
    }
  }

  void _handleVerificationFailed(FirebaseAuthException e) {
    setState(() => _isLoading = false);

    String errorMessage;
    switch (e.code) {
      case 'invalid-phone-number':
        errorMessage = 'Invalid phone number format. Please include country code (e.g., +1...)';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Please try again later';
        break;
      case 'quota-exceeded':
        errorMessage = 'SMS quota exceeded. Contact support';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Phone auth not enabled in Firebase console';
        break;
      default:
        errorMessage = 'Verification failed: ${e.message}';
    }

    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
    );
    debugPrint("OTP Error: $errorMessage");

  }

  void _handleCodeSent(String verificationId, int? resendToken) {
    setState(() {
      _verificationId = verificationId;
      _resendToken = resendToken;
      _isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "OTP sent to ${widget.phoneNumber}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _handleCodeTimeout(String verificationId) {
    setState(() {
      _verificationId = verificationId;
      _isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Auto-retrieval timed out. Please enter code manually",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _handleGenericError(dynamic e) {
    setState(() => _isLoading = false);

    Fluttertoast.showToast(
      msg: "Error: ${e.toString()}",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
    );

    debugPrint("OTP Error: $e");
  }

  void _navigateAfterVerification() {
    if (widget.isPasswordReset) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Verification successful!",
        toastLength: Toast.LENGTH_LONG,
      );
      Navigator.pop(context, true);
    }
  }

  void _handleOtpInput(String value, int index) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    if (index == 5 && value.isNotEmpty) {
      _verifyOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
          child: Container(
            width: screenWidth > 600 ? 400 : screenWidth * 0.85,
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Enter the OTP sent to ${widget.phoneNumber}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                          onChanged: (value) => _handleOtpInput(value, index),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),

                  // Verify Button
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
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Resend OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive code?",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextButton(
                        onPressed: _resendTimeout > 0 || _isResending
                            ? null
                            : _resendOtp,
                        child: _isResending
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          _resendTimeout > 0
                              ? "Resend in $_resendTimeout s"
                              : "Resend OTP",
                          style: TextStyle(
                            color: _resendTimeout > 0
                                ? Colors.grey
                                : Colors.green,
                            fontWeight: FontWeight.bold,
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

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: const Center(
        child: Text('Password Reset Screen'),
      ),
    );
  }
}