import 'package:firebase_project/screens/phone_auth/phone_signin.dart';
import 'package:flutter/material.dart';

import 'email_auth/sign in/pages/signin_page.dart';

class SignInOptions extends StatelessWidget {
  const SignInOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign In"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Sign In Options"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInWithPhone()));
                  },
                  child: const Text("Phone number Authetication")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: const Text("Email Authentication"))
            ],
          ),
        ));
  }
}
