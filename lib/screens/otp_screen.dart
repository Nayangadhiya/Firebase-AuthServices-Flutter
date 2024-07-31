import 'package:fire_services/Utils/auth_services.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String verifyOTP;
  const OTPScreen({super.key, required this.verifyOTP});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'OTP Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                AuthServices().verifyOtp(
                    widget.verifyOTP.toString(), _otpController, context);
              },
              child: const Text('Send Verification Code'),
            ),
          ],
        ),
      ),
    );
  }
}
