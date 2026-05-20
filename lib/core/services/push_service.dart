import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushService {
  static final _supabase = Supabase.instance.client;

  static Future<bool> sendNotificationToRecipient({
    required String recipientUserId,
    required String title,
    required String body,
    required String projectId,
    String? senderUserId,
  }) async {
    try {
      final session = _supabase.auth.currentSession;
      final token = session?.accessToken;
      if (token == null) return false;

      final response = await _supabase.functions.invoke(
        'send-push-notification',
        body: jsonEncode({
          'recipient_user_id': recipientUserId,
          'title': title,
          'body': body,
          'project_id': projectId,
          'sender_user_id': senderUserId,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.status >= 200 && response.status < 300;
    } catch (e) {
      debugPrint('Error sending push through function: $e');
      return false;
    }
  }
}
