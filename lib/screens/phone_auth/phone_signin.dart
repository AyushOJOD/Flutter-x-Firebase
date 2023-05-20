import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/screens/phone_auth/otp_verification.dart';
import 'package:flutter/material.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({Key? key}) : super(key: key);

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  TextEditingController phoneController = TextEditingController();

  void sendOTP() async {
    String number = '+91${phoneController.text.trim()}';

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (credentials) {},
        verificationFailed: (ex) {
          log(ex.code.toString());
        },
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyOtpScreen(verificationId: verificationId)));
        },
        codeAutoRetrievalTimeout: (verificayionId) {},
        timeout: const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign In with Phone"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      sendOTP();
                    },
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
