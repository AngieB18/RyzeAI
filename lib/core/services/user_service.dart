// lib/core/services/user_service.dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static final _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      if (response != null) {
        final data = response as Map<String, dynamic>;
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
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      await _supabase.from('users').update(
        {'firstName': firstName, 'lastName': lastName},
      ).eq('id', user.id);
    } catch (e) {}
  }

  static Future<void> updateUserEmail(String newEmail) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      await _supabase.from('users').update(
        {'email': newEmail},
      ).eq('id', user.id);
    } catch (e) {}
  }

  // Guarda foto como base64 en Supabase (sin Storage)
  static Future<String?> uploadProfilePhoto(Uint8List imageBytes) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      // Comprimir si es muy grande (max ~700KB para Supabase)
      Uint8List compressed = imageBytes;
      if (imageBytes.length > 700000) {
        // Si pesa más de 700KB avisamos
        return null;
      }

      // Convertir a base64
      final base64String = base64Encode(compressed);
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      // Guardar en Supabase
      await _supabase.from('users').update(
        {'photoUrl': dataUrl},
      ).eq('id', user.id);

      return dataUrl;
    } catch (e) {
      return null;
    }
  }
}
