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
        data['language'] = data['language'] ?? 'es';
        data['styles'] = await getCurrentUserStyleIds();

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
      await _supabase
          .from('users')
          .update({'first_name': firstName, 'last_name': lastName})
          .eq('id', user.id);
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  static Future<void> updateUserEmail(String newEmail) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      await _supabase
          .from('users')
          .update({'email': newEmail})
          .eq('id', user.id);
    } catch (e) {
      print('Error updating user email: $e');
    }
  }

  // Guarda foto como base64 o URL de avatar en Supabase
  static Future<String?> uploadProfilePhoto(
    Uint8List? imageBytes, {
    String? avatarUrl,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      String finalUrl = '';

      if (avatarUrl != null) {
        // Si nos pasan una URL (avatar predefinido)
        finalUrl = avatarUrl;
      } else if (imageBytes != null) {
        // Límite de 1.2MB para base64 en columna TEXT
        if (imageBytes.length > 1200000) {
          print('Image too large: ${imageBytes.length} bytes');
          return null;
        }
        // Convertir a base64
        final base64String = base64Encode(imageBytes);
        finalUrl = 'data:image/jpeg;base64,$base64String';
      } else {
        return null;
      }

      // Guardar en Supabase - Usamos photo_url (snake_case)
      await _supabase
          .from('users')
          .update({'photo_url': finalUrl})
          .eq('id', user.id);

      return finalUrl;
    } catch (e) {
      print('Error updating profile photo: $e');
      return null;
    }
  }

  static Future<void> updateUserStyles(List<String> styles) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('user_styles')
        .delete()
        .eq('user_id', user.id);

    if (styles.isNotEmpty) {
      await _supabase.from('user_styles').insert(
        styles.map((styleId) => {
          'user_id': user.id,
          'style_id': styleId,
        }).toList(),
      );
    }

    await _supabase.from('users').update({
      'styles_selected': styles.isNotEmpty,
    }).eq('id', user.id);
  } catch (e) {
    print('Error updating user styles: $e');
  }
}

  static Future<void> setStylesSelected(bool selected) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      await _supabase
          .from('users')
          .update({'styles_selected': selected})
          .eq('id', user.id);
    } catch (e) {
      print('Error updating styles_selected: $e');
    }
  }

  static Future<List<String>> getCurrentUserStyleIds() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase
          .from('user_styles')
          .select('style_id')
          .eq('user_id', user.id);

      return (response as List)
          .map((row) => row['style_id'].toString())
          .toList();
    } catch (e) {
      print('Error loading user styles: $e');
      return [];
    }
  }

  static Future<void> updateUserLanguage(String language) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final normalizedLanguage = language.trim().toLowerCase();

    if (normalizedLanguage != 'es' && normalizedLanguage != 'en') {
      throw Exception('Idioma no válido: $language');
    }

    await _supabase
        .from('users')
        .update({'language': normalizedLanguage})
        .eq('id', user.id);
  } catch (e) {
    print('Error updating user language: $e');
  }
}
}
