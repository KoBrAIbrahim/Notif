import 'package:app/pages/account/login.dart';
import 'package:app/pages/account/signup.dart';
import 'package:app/pages/account/welcome.dart';
import 'package:app/pages/mainPages/main.dart';
import 'package:app/pages/mainPages/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:app/pages/mainPages/chat_page.dart';
import 'package:app/pages/mainPages/massages.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void handleNotificationTap(String? payload) {
  if (payload != null) {
    final parts = payload.split('|');
    if (parts.length == 3) {
      Get.to(() => ChatPage(
            chatId: parts[0],
            myId: parts[1],
            receiverId: parts[2],
            receiverName: "User", 
          ));
    }
  }
}

void handleDynamicLink(Uri? deepLink) {
  if (deepLink != null) {
    print("Dynamic Link: $deepLink");

    if (deepLink.path == '/home') {
      Get.toNamed('/main'); 
      return;
    }

     if (deepLink.path == '/messages') {
      Get.toNamed('/messages');
      return;
    }

    if (deepLink.pathSegments.contains('chat')) {
      final chatId = deepLink.queryParameters['chatId'];
      final myId = deepLink.queryParameters['myId'];
      final receiverId = deepLink.queryParameters['receiverId'];

      if (chatId != null && myId != null && receiverId != null) {
        Get.to(() => ChatPage(
              chatId: chatId,
              myId: myId,
              receiverId: receiverId,
              receiverName: "User",
            ));
      }
    }
  }
}


void initDynamicLinks() async {
  final data = await FirebaseDynamicLinks.instance.getInitialLink();
  handleDynamicLink(data?.link);

  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    handleDynamicLink(dynamicLinkData.link);
  }).onError((e) {
    print('خطأ في dynamic link: $e');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      handleNotificationTap(response.payload);
    },
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload:
              "${message.data['chatId']}|${FirebaseAuth.instance.currentUser?.uid}|${message.data['senderId']}",
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNotificationTap(
        "${message.data['chatId']}|${FirebaseAuth.instance.currentUser?.uid}|${message.data['senderId']}",
      );
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => WelcomeScreenWithLinkInit()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignupScreen()),
        GetPage(name: '/main', page: () => MainPage()),
        GetPage(name: '/messages', page: () => MessagesPage()),
        GetPage(name: '/notifications', page: () => NotificationsPage()),
      ],
    );
  }
}

class WelcomeScreenWithLinkInit extends StatefulWidget {
  @override
  State<WelcomeScreenWithLinkInit> createState() =>
      _WelcomeScreenWithLinkInitState();
}

class _WelcomeScreenWithLinkInitState
    extends State<WelcomeScreenWithLinkInit> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks(); 
  }

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen();
  }
}
