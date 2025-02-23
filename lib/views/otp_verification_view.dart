import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "OTP Verification",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),

            const Text(
              "Enter the 6-digit code sent to your phone",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: screenHeight * 0.02),

            // OTP Input Field
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: otpController,
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
              keyboardType: TextInputType.number,
              autoFocus: true,
              enableActiveFill: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: screenWidth * 0.12,
                fieldWidth: screenWidth * 0.12,
                activeFillColor: Colors.green, // Green when filled
                inactiveFillColor: Colors.grey.shade200,
                inactiveColor: Colors.grey.shade400,
                selectedFillColor: Colors.white,
                selectedColor: Colors.green,
                activeColor: Colors.green,
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild to update color
              },
            ),

            SizedBox(height: screenHeight * 0.03),

            // Resend OTP
            TextButton(
              onPressed: () {
                // TODO: Resend OTP Logic
              },
              child: const Text(
                "Resend Code",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Verify Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Verify OTP Logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
