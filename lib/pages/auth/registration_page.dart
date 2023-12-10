import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:musical_application/components/my_button.dart';
import 'package:musical_application/components/my_textfield.dart';
import 'package:musical_application/utils/collection_names.dart';

import '../../models/artist.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  String message = 'Registration';

  void register() async {
    if (emailController.text.isEmpty
        || passwordController.text.isEmpty
        || repeatPasswordController.text.isEmpty
        || nameController.text.isEmpty){
      setState(() {
        message = "Fill all fields";
      });
      return;
    }

    if (passwordController.text != repeatPasswordController.text){
      setState(() {
        message = "Passwords do not match";
      });
      return;
    }

    try {
      setState(() {
        message = "Loading";
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text);

      final artist = Artist(
          name: nameController.text,
          userId: userCredential.user!.uid
      ).toFirestore();

      await FirebaseFirestore.instance.collection(CollectionNames.artists).add(artist);

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          message = "Successful😊";
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message =
            "${e.code[0].toUpperCase()}${e.code.substring(1).toLowerCase()}"
                .replaceAll('-', ' ');
      });
    } catch (e) {
      setState(() {
        message = e.toString();
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 50),
              MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false),
              MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false),
              MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true),
              MyTextField(
                  controller: repeatPasswordController,
                  hintText: "Repeat password",
                  obscureText: true),
              const SizedBox(height: 25),
              MyButton(
                onTap: register,
                color: Colors.red,
                text: "Register",
              ),
              const SizedBox(height: 10),

              MyButton(
                text: 'Go Back',
                color: Colors.green,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
