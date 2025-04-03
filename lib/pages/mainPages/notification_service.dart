import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;

class NotificationService {
  static Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      await rootBundle.loadString('assets/service-account.json'),
    );

    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final authClient = await clientViaServiceAccount(accountCredentials, scopes);

    const projectId = 'notifi-eb864';
    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

    final message = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
      }
    };

    final response = await authClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message),
    );

    if (response.statusCode == 200) {
      print("Notification sent");
    } else {
      print("Failed to send notification: ${response.body}");
    }
  }
}
