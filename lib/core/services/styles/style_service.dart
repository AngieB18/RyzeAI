import 'package:supabase_flutter/supabase_flutter.dart';

class StyleService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getStyles() async {
    try {
      final response = await _supabase
          .from('styles')
          .select();

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error loading styles: $e');
      return [];
    }
  }

  // Obtiene solo los estilos que están relacionados con el usuario (user_styles)
  static Future<List<Map<String, dynamic>>> getStylesForUser(String userId) async {
    try {
      final response = await _supabase
          .from('styles')
          .select('id, name, icon, user_styles!inner(user_id)')
          .eq('user_styles.user_id', userId)
          .order('name', ascending: true);

      if (response == null) return [];
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getStylesForUser: $e');
      return [];
    }
  }
}