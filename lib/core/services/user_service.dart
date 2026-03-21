// lib/core/services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        // Si firstName está vacío usa displayName de Auth
        if ((data['firstName'] ?? '').isEmpty) {
          final displayName = user.displayName ?? '';
          final parts = displayName.split(' ');
          data['firstName'] = parts.isNotEmpty ? parts[0] : '';
          data['lastName'] = parts.length > 1 ? parts.sublist(1).join(' ') : '';
        }
        return data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static String getInitials(String firstName, String lastName) {
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();
    if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();
    return initials;
  }

  static Future<void> updateUserName(String firstName, String lastName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'firstName': firstName, 'lastName': lastName},
      );
    } catch (e) {
      // handle error
    }
  }
}
