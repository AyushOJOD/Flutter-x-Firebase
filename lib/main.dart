// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/firebase_options.dart';
import 'package:firebase_project/screens/homepage/homepage.dart';
import 'package:firebase_project/screens/signin_options.dart';
import 'package:firebase_project/services/notification.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotficationService.initialize();

  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // THIS IS USED TO ADD AND UPDATE DATA

  // DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //     .collection("Users")
  //     .doc("mMa9rVyxubAD4iYsd11C")
  //     .get();

  // log(snapshot.data().toString());

  // THIS IS USED TO ADD AND UPDATE DATA

  // Map<String, dynamic> newUserData = {
  //   "name": "Rohan",
  //   "email": "rohancr@gmail.com",
  //   "Phone Number": "9554254574"
  // };

  // await _firestore.collection("Users").doc("your-id-here").update({
  //   "email": "rohan123@gmail.com",
  // });
  // log("New User Saved");

  // THIS IS HOW WE DELETE DATA FROM THE SERVER

  // await _firestore.collection("Users").doc("your-id-here").delete();
  // log("User Deleted");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (FirebaseAuth.instance.currentUser != null)
          ? const Homepage()
          : const SignInOptions(),
    );
  }
}
