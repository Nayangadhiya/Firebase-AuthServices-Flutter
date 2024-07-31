import 'package:fire_services/Utils/auth_services.dart';
import 'package:flutter/material.dart';

class PhonAuthScreen extends StatefulWidget {
  const PhonAuthScreen({super.key});

  @override
  State<PhonAuthScreen> createState() => _PhonAuthScreenState();
}

class _PhonAuthScreenState extends State<PhonAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                AuthServices()
                    .phonAuth(_phoneNumberController.text.toString(), context);
              },
              child: const Text('Send Verification Code'),
            ),
          ],
        ),
      ),
    );
  }
}
