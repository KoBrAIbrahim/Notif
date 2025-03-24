import 'package:app/controllers/product_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final controller = Get.put(ProductController());

  final String backgroundImage =
      'https://static.vecteezy.com/system/resources/thumbnails/030/678/834/small/red-background-high-quality-free-photo.jpg';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Ramadan App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () => Get.toNamed('/main'),
          ),
          IconButton(
            icon: Icon(Icons.message, color: Colors.white),
            onPressed: () => Get.toNamed('/messages'),
          ),
           IconButton(
      icon: Icon(Icons.logout, color: Colors.white),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Get.offAllNamed('/login');
      },
    ),
        ],
      ),
      body: Stack(
        children: [
          Image.network(
            backgroundImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Obx(() {
            if (controller.products.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: EdgeInsets.only(top: kToolbarHeight + 20, bottom: 20),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          product['images'][0],
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          product['title'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4),
                        child: Text(
                          product['description'],
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
