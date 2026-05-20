import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final _supabase = Supabase.instance.client;

  static Future<bool> createNotification({
    required String recipientUserId,
    required String senderUserId,
    required String projectId,
    required String title,
    required String body,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'recipient_user_id': recipientUserId,
        'sender_user_id': senderUserId,
        'project_id': projectId,
        'title': title,
        'body': body,
        'is_read': false,
      });
      return true;
    } catch (e) {
      debugPrint('Error creating notification: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getCurrentUserNotifications() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    try {
      final response = await _supabase
          .from('notifications')
          .select('id, title, body, is_read, created_at')
          .eq('recipient_user_id', currentUser.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      return [];
    }
  }

  static Future<int> getUnreadNotificationCount() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return 0;

    try {
      final response = await _supabase
          .from('notifications')
          .select('id')
          .eq('recipient_user_id', currentUser.id)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      debugPrint('Error loading unread notification count: $e');
      return 0;
    }
  }

  static Future<bool> markNotificationRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      return true;
    } catch (e) {
      debugPrint('Error marking notification read: $e');
      return false;
    }
  }
}
