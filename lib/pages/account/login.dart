import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  final controller = Get.find<AuthController>();

  LoginScreen({super.key});

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
                  decoration: InputDecoration(labelText: "Email", labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password", labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => controller.login(email.text, password.text),
                  child: Text("LOGIN"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
