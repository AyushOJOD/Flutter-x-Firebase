import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/screens/email_auth/sign%20in/components/my_button.dart';
import 'package:firebase_project/screens/email_auth/sign%20in/components/my_textfield.dart';
import 'package:firebase_project/screens/signin_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  io.File? profilePic;

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SignInOptions()));
  }

  void saveUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String number = numberController.text.trim();
    String ageString = ageController.text.trim();

    int age = int.parse(ageString);

    nameController.clear();
    emailController.clear();
    numberController.clear();
    ageController.clear();

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("Profile Picture")
        .child(Uuid().v1())
        .putFile(profilePic!);

    StreamSubscription taskSubscription =
        uploadTask.snapshotEvents.listen((event) {
      double percentage = event.bytesTransferred / event.totalBytes * 100;
      log(percentage.toString());
    });

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    taskSubscription.cancel();

    Map<String, dynamic> newUser = {
      "name": name,
      "email": email,
      "number": number,
      "age": age,
      "profile pic": downloadUrl
    };

    if (name == "" ||
        email == "" ||
        number == "" ||
        age == 0 && profilePic != null) {
      const AlertDialog(
        title: Text("Please enter all the fields!"),
      );
    } else {
      FirebaseFirestore.instance.collection("Users").add(newUser);
      log("User Created");
    }

    setState(() {
      profilePic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), centerTitle: true, actions: [
        IconButton(
            onPressed: () {
              logOut();
            },
            icon: const Icon(Icons.exit_to_app))
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? selectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (selectedImage != null) {
                    io.File convertedFile = io.File(selectedImage.path);
                    setState(() {
                      profilePic = convertedFile;
                    });
                  } else {
                    log("No Image Selected");
                  }
                },
                child: CircleAvatar(
                  backgroundImage:
                      (profilePic != null) ? FileImage(profilePic!) : null,
                  backgroundColor: Colors.grey,
                  radius: 50.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                hintText: 'Name',
                obscureText: false,
                controller: nameController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Email',
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: 'Phone Number',
                obscureText: false,
                controller: numberController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                  controller: ageController,
                  hintText: "Age",
                  obscureText: false),
              const SizedBox(height: 20),
              MyButton(
                onTap: () {
                  saveUser();
                },
                text: 'Save',
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .orderBy(
                        "age",
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> userMap =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              return ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userMap["profile pic"])),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      deleteUser(snapshot.data!.docs[index].id);
                                      setState(() {});
                                    },
                                  ),
                                  title: Text(
                                      "${userMap["name"]}(${userMap["age"]})"),
                                  subtitle: Text(userMap["email"].toString()));
                            },
                          ),
                        );
                      } else {
                        return const Text('No Data Found');
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void deleteUser(id) {
    FirebaseFirestore.instance.collection("Users").doc(id).delete();
  }
}
