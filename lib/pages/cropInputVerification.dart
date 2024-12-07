import 'dart:math';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_field.dart';

class VerificationPage extends StatefulWidget {
  final String cropName;
  final String quantity;
  final String price;

  VerificationPage({
    super.key,
    required this.cropName,
    required this.quantity,
    required this.price,
  });

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController verificationCodeController = TextEditingController();
  late String generatedCode;

  @override
  void initState() {
    super.initState();
    _generateVerificationCode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showVerificationCodeDialog();
    });
  }

  void _generateVerificationCode() {
    final random = Random();
    generatedCode = (random.nextInt(900000) + 100000).toString();
  }

  void _showVerificationCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verification Code'),
          content: Text('Your verification code is: $generatedCode'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _verifyCode() {
    if (verificationCodeController.text == generatedCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification Successful!')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Code!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Please enter the verification code sent to your phone:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: verificationCodeController,
              hintText: 'Verification Code',
              obscureText: false,
            ),
            const SizedBox(height: 30),
            Center(
              child: MyButton(
                text: 'Verify',
                onTap: _verifyCode,
                width: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
