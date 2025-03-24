import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_page.dart';

class MessagesPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        body: Center(child: Text("You are not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        backgroundColor: Colors.red[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users found"));
          }

          final users = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data.containsKey('uid') && data['uid'] != currentUser.uid;
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final data = users[index].data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown';
              final email = data['email'] ?? '';
              final uid = data['uid'];
              final chatId = generateChatId(currentUser.uid, uid);

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, msgSnapshot) {
                  bool hasNewMessage = false;

                  if (msgSnapshot.hasData && msgSnapshot.data!.docs.isNotEmpty) {
                    final msg = msgSnapshot.data!.docs.first;
                    final msgData = msg.data() as Map<String, dynamic>;
                    final sender = msgData['senderId'];

                    hasNewMessage = sender == uid;
                  }

                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(child: Icon(Icons.person)),
                        if (hasNewMessage)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(name),
                    subtitle: Text(email),
                    onTap: () {
                      Get.to(() => ChatPage(
                            chatId: chatId,
                            myId: currentUser.uid,
                            receiverId: uid,
                            receiverName: name,
                          ));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String generateChatId(String a, String b) {
    final ids = [a, b]..sort();
    return "${ids[0]}_${ids[1]}";
  }
}
