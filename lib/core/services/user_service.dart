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
        if ((data['photoUrl'] ?? '').isEmpty) {
          data['photoUrl'] = data['photo_url'] ?? '';
        }

        // Safe parsing for styles column
        if (data['styles'] is String) {
          try {
            data['styles'] = jsonDecode(data['styles'] as String);
          } catch (_) {
            data['styles'] = [];
          }
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
        {'first_name': firstName, 'last_name': lastName},
      ).eq('id', user.id);
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  static Future<void> updateUserEmail(String newEmail) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      await _supabase.from('users').update(
        {'email': newEmail},
      ).eq('id', user.id);
    } catch (e) {
      print('Error updating user email: $e');
    }
  }

  // Guarda foto como base64 en Supabase (sin Storage)
  static Future<String?> uploadProfilePhoto(Uint8List imageBytes) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      // Límite de 1.2MB para base64 en columna TEXT
      if (imageBytes.length > 1200000) {
        print('Image too large: ${imageBytes.length} bytes');
        return null;
      }

      // Convertir a base64
      final base64String = base64Encode(imageBytes);
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      // Guardar en Supabase - Usamos photo_url (snake_case)
      await _supabase.from('users').update(
        {'photo_url': dataUrl},
      ).eq('id', user.id);

      return dataUrl;
    } catch (e) {
      print('Error uploading profile photo: $e');
      return null;
    }
  }

  static Future<void> updateUserStyles(List<String> styles) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      await _supabase.from('users').update({
        'styles': styles,
        'styles_selected': true,
      }).eq('id', user.id);
    } catch (e) {
      print('Error updating user styles: $e');
    }
  }

  static Future<void> setStylesSelected(bool selected) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      await _supabase.from('users').update({
        'styles_selected': selected,
      }).eq('id', user.id);
    } catch (e) {
      print('Error updating styles_selected: $e');
    }
  }
}
