// lib/core/services/user_service.dart
import 'dart:typed_data';
import 'dart:convert';
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
        if ((data['firstName'] ?? '').isEmpty) {
          data['firstName'] = data['first_name'] ?? '';
        }
        if ((data['lastName'] ?? '').isEmpty) {
          data['lastName'] = data['last_name'] ?? '';
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
    } catch (e) {}
  }

  static Future<void> updateUserEmail(String newEmail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'email': newEmail},
      );
    } catch (e) {}
  }

  // ← Guarda foto como base64 en Firestore (sin Storage)
  static Future<String?> uploadProfilePhoto(Uint8List imageBytes) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      // Comprimir si es muy grande (max ~700KB para Firestore)
      Uint8List compressed = imageBytes;
      if (imageBytes.length > 700000) {
        // Si pesa más de 700KB avisamos
        return null;
      }

      // Convertir a base64
      final base64String = base64Encode(compressed);
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      // Guardar en Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'photoUrl': dataUrl},
      );

      return dataUrl;
    } catch (e) {
      return null;
    }
  }
}
