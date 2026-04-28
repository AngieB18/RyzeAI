import 'package:supabase_flutter/supabase_flutter.dart';

class PaletteService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getPalettes() async {
    try {
      final response = await _supabase
          .from('palette')
          .select('id, name_palette, colors_palette');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error loading palettes: $e');
      return [];
    }
  }
}