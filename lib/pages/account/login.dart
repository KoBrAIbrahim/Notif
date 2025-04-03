import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();

  LoginScreen({super.key});

  Future<void> _login() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        final fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'fcmToken': fcmToken,
            'lastLogin': Timestamp.now(),
          });
        }

        Get.snackbar("Success", "Logged in successfully 👋");
        Get.offAllNamed('/main');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Something went wrong");
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
            onPressed: () => Get.toNamed('/signup'),
            child: Text("Sign Up", style: TextStyle(color: Colors.white)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign In", style: TextStyle(fontSize: 28, color: Colors.white)),
                SizedBox(height: 40),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  child: Text("LOGIN"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
