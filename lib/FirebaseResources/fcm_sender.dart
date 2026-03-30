import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class FCMSender {
  // This URL will be set after deploying the Cloud Function
  static const String _cloudFunctionUrl =
      'https://us-central1-expert-support.cloudfunctions.net/sendNotification';

  static Future<void> sendToTopic({
    required String topic,
    required String titleAr,
    required String titleEn,
    required String bodyAr,
    required String bodyEn,
  }) async {
    // Use the current admin's Firebase Auth UID as the auth token
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse(_cloudFunctionUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.uid}',
      },
      body: jsonEncode({
        'titleAr': titleAr,
        'titleEn': titleEn,
        'bodyAr': bodyAr,
        'bodyEn': bodyEn,
        'topic': topic,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to send notification');
    }
  }
}
