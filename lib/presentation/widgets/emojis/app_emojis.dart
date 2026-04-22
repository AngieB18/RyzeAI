class AppEmojis {
  // Styles
  static const String modern = '🏙️';
  static const String minimal = '🕯️';
  static const String traditional = '🏛️';
  static const String japanese = '⛩️';
  static const String contemporary = '🖼️';
  static const String bohemian = '🪬';
  static const String farmhouse = '🚜';
  static const String vintage = '📻';
  static const String industrial = '⚙️';
  static const String retro = '📼';
  static const String cyberpunk = '🤖';
  static const String christmas = '🎄';
  static const String tropical = '🌴';
  static const String scandinavian = '❄️';
  static const String natural = '🌿';
  static const String rustic = '🪵';
  static const String colorful = '🎨';
  static const String brutalist = '🧱';
  static const String southwest = '🌵';
  static const String baroque = '👑';
  static const String futuristic = '🚀';
  static const String colonial = '🏰';
  static const String rococo = '💎';
  static const String valentine = '💖';

  // Rooms
  static const String livingRoom = '🛋️';
  static const String bedroom = '🛏️';
  static const String kitchen = '🍳';
  static const String bathroom = '🛁';
  static const String office = '💻';
  static const String diningRoom = '🍽️';

  // UI / Status Emojis (Centralizados aquí)
  static const String favoriteActive = '❤️';
  static const String favoriteInactive = '🤍';
  static const String emptyFavorites = '💔';
  static const String error = '⚠️';
  static const String success = '✅';

  static const Map<String, String> _styles = {
    'modern': modern,
    'minimal': minimal,
    'traditional': traditional,
    'japanese': japanese,
    'contemporary': contemporary,
    'bohemian': bohemian,
    'farmhouse': farmhouse,
    'vintage': vintage,
    'industrial': industrial,
    'retro': retro,
    'cyberpunk': cyberpunk,
    'christmas': christmas,
    'tropical': tropical,
    'scandinavian': scandinavian,
    'natural': natural,
    'rustic': rustic,
    'colorful': colorful,
    'brutalist': brutalist,
    'southwest': southwest,
    'baroque': baroque,
    'futuristic': futuristic,
    'colonial': colonial,
    'rococo': rococo,
    'valentine': valentine,
  };

  static const Map<String, String> _rooms = {
    'living_room': livingRoom,
    'bedroom': bedroom,
    'kitchen': kitchen,
    'bathroom': bathroom,
    'office': office,
    'dining_room': diningRoom,
  };

  static const Map<String, String> _features = {
    'ambient_light': '💡',
    'natural_light': '☀️',
    'cozy_atmosphere': '🔥',
    'accent_wall': '🎨',
    'built_in_shelves': '📚',
    'exposed_beams': '🪵',
    'arches': '🏛️',
    'plants': '🌿',
    'mirrors': '🪞',
    'textured_walls': '🧱',
    'rugs': '🧶',
  };

  // Mapa para los elementos de la interfaz
  static const Map<String, String> _ui = {
    'fav_active': favoriteActive,
    'fav_inactive': favoriteInactive,
    'empty_fav': emptyFavorites,
    'error': error,
    'success': success,
  };

  // Métodos de acceso
  static String getStyle(String key) => _styles[key] ?? '✨';
  static String getRoom(String key) => _rooms[key] ?? '🏠';
  static String getFeature(String key) => _features[key] ?? '🔹';
  
  // Nuevo método para la UI
  static String getUI(String key) => _ui[key] ?? '🔘';
}