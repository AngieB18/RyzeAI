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
}