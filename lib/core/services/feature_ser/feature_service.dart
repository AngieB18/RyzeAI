import 'package:supabase_flutter/supabase_flutter.dart';

class FeatureService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getFeatures() async {
    try {
      final response = await _supabase
          .from('feature')
          .select('id, name_feature, icon_feature');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error loading features: $e');
      return [];
    }
  }
}