import 'package:supabase_flutter/supabase_flutter.dart';

class TypeRoomService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getTypeRooms() async {
    try {
      final response = await _supabase
          .from('type_room')
          .select('id, name_type_room, icon_room');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error loading type rooms: $e');
      return [];
    }
  }
}