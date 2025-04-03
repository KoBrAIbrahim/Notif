import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignupScreen extends StatelessWidget {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  SignupScreen({super.key});

  Future<void> _signup() async {
    if (password.text != confirmPassword.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      final user = userCredential.user;
      if (user != null) {
        final uid = user.uid;

        final fcmToken = await FirebaseMessaging.instance.getToken();

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': name.text.trim(),
          'email': email.text.trim(),
          'fcmToken': fcmToken,
          'createdAt': Timestamp.now(),
        });

        Get.snackbar("Success", "Account created successfully 🎉");
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Signup Error", "Email already in use");
      } else if (e.code == 'weak-password') {
        Get.snackbar(
          "Signup Error",
          "Weak password. Please use a stronger one.",
        );
      } else {
        Get.snackbar(
          "Signup Error",
          e.message ?? "An unexpected error occurred",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Get.toNamed('/login'),
            child: Text("Sign In", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://static.vecteezy.com/system/resources/thumbnails/030/678/834/small/red-background-high-quality-free-photo.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Text(
                    "Create Account",
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: _signup, child: Text("SIGN UP")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
