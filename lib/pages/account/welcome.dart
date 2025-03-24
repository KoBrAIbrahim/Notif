import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://static.vecteezy.com/system/resources/thumbnails/030/678/834/small/red-background-high-quality-free-photo.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Messages application", style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text("Welcome Back", style: TextStyle(color: Colors.white70, fontSize: 18)),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/login'),
                  child: Text("SIGN IN"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/signup'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text("SIGN UP", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
