# Estructura de Widgets - RyzeAI

## 📁 Carpeta de Widgets Reorganizada

La carpeta `lib/presentation/widgets/` ha sido reorganizada en categorías para mejor mantenimiento y reutilización:

### 🎨 Categorías de Widgets

#### 1. **Global** (`widgets/global/`)
Widgets reutilizables en toda la aplicación:

- **`custom_text_field.dart`** - Campo de entrada personalizado
  - Soporte para contraseña oculta
  - Validación integrada
  - Estilos adaptados al tema

- **`error_dialog.dart`** - Diálogo de errores
  - Muestra errores elegantes
  - Ícono de error y botón de cerrar

- **`app_header.dart`** - Encabezado con botón de retroceso
  - Botón de retroceso funcional
  - Título personalizable
  - Ícono trailing personalizable

- **`simple_header.dart`** - Encabezado simple sin retroceso
  - Título solamente o con widget trailing
  - Usado en: Favorites, Projects

- **`section_header.dart`** - Encabezado de secciones
  - Título con badge de "Requerido/Opcional"
  - Uso en formularios

- **`favorite_card.dart`** - Tarjeta de producto favorito
  - Muestra emoji, nombre, tienda y precio
  - Icono de corazón en la esquina
  - Usado en: FavoritesScreen

- **`project_card.dart`** - Tarjeta de proyecto
  - Emoji, nombre, items y estado
  - Color dinámico según estado
  - Usado en: ProjectsScreen

- **`menu_item_widget.dart`** - Elemento de menú
  - Icono, etiqueta y trailing personalizable
  - Soporte para items peligrosos (logout)
  - Usado en: ProfileScreen

- **`global_loader.dart`** - Cargador global animado
  - Animación 3D personalizada
  - Usado en toda la app

#### 2. **Colores** (`widgets/colors/`)
Widgets relacionados con selección de paletas y colores:

- **`color_palette_selector.dart`** - Selector de paletas de color
  - Muestra colores circulares
  - Selección animada
  - Etiqueta de paleta
  - Usado en: DesignGeneratorScreen

#### 3. **Emojis** (`widgets/emojis/`)
Widgets con soporte para emojis y selección:

- **`room_selector.dart`** - Selector de habitaciones
  - Emojis para cada tipo de habitación
  - Selección horizontal
  - Usado en: DesignGeneratorScreen

- **`style_selector.dart`** - Selector de estilos
  - Emojis para cada estilo (Modern, Minimal, etc)
  - Indicador de selección con check
  - Usado en: DesignGeneratorScreen

- **`user_styles_display.dart`** - Muestra estilos seleccionados del usuario
  - Emojis con check circle
  - Estilos del usuario en color principal
  - Usado en: DesignGeneratorScreen

- **`emoji_feature_selector.dart`** - Selector de características con emojis
  - Agrupado por categorías (Iluminación, Arquitectura, Decoración)
  - Colores por categoría
  - Usado en: DesignGeneratorScreen

#### 4. **Imágenes** (`widgets/images/`)
Widgets para manejo de imágenes:

- **`image_picker_button.dart`** - Botón para seleccionar imágenes
  - Opciones de cámara/galería
  - Interfaz limpia con bottom sheet
  - Usado en: HomeScreen, DesignGeneratorScreen

- **`image_picker_display.dart`** - Muestra imagen seleccionada
  - Preview de imagen
  - Hint para seleccionar
  - Usado en: DesignGeneratorScreen

---

## 🔗 Importación de Widgets

### Opción 1: Importar todo
```dart
import 'package:ryzeai/presentation/widgets/index.dart';
```

### Opción 2: Importar por categoría
```dart
import 'package:ryzeai/presentation/widgets/global/index.dart';
import 'package:ryzeai/presentation/widgets/colors/index.dart';
import 'package:ryzeai/presentation/widgets/emojis/index.dart';
import 'package:ryzeai/presentation/widgets/images/index.dart';
```

### Opción 3: Importar específicamente
```dart
import 'package:ryzeai/presentation/widgets/global/custom_text_field.dart';
import 'package:ryzeai/presentation/widgets/colors/color_palette_selector.dart';
```

---

## 📝 Ejemplos de Uso

### CustomTextField
```dart
CustomTextField(
  controller: emailController,
  label: 'Email',
  placeholder: 'correo@ejemplo.com',
  keyboardType: TextInputType.emailAddress,
)
```

### FavoriteCard
```dart
FavoriteCard(
  icon: '🛋️',
  name: 'Scandinavian Sofa',
  store: 'IKEA',
  price: '\$899',
)
```

### ProjectCard
```dart
ProjectCard(
  icon: '🛋️',
  name: 'Living Room',
  items: '8 items',
  status: 'In progress',
  statusColor: AppColors.passwordMedium,
)
```

### SimpleHeader
```dart
SimpleHeader(
  title: 'Favorites',
  trailing: Container(
    // Widget trailing opcional
  ),
)
```

### MenuItemWidget
```dart
MenuItemWidget(
  icon: Icons.person_outline,
  label: 'Edit Profile',
  onTap: () => _showEditProfileSheet(context),
)
```

### ColorPaletteSelector
```dart
ColorPaletteSelector(
  palettes: palettes,
  selectedPalette: selectedPalette,
  onPaletteSelected: (palette) => setState(() => selectedPalette = palette),
  getPaletteLabel: (key) => getLabelForPalette(key),
)
```

### ImagePickerDisplay
```dart
ImagePickerDisplay(
  selectedImage: selectedImage,
  onTap: _showImagePickerOptions,
)
```

### EmojiFeatureSelector
```dart
EmojiFeatureSelector(
  sections: featureSections,
  selectedFeatures: selectedFeatures,
  onFeatureToggled: (feature, isSelected) {
    // Actualizar selección
  },
)
```

---

## 🎯 Beneficios de esta Estructura

✅ **Reutilizable** - Widgets usados en múltiples screens  
✅ **Organizado** - Fácil encontrar widgets específicos  
✅ **Mantenible** - Cambios en un solo lugar  
✅ **Escalable** - Fácil agregar nuevos widgets  
✅ **Consistente** - Mismo estilo en toda la app  
✅ **Reducción de Código** - Menos duplicación entre features

---

## 📦 Archivos Actualizados

Los siguientes archivos han sido actualizados para usar los widgets globales:

- ✅ `login_page.dart` - Usa `ErrorDialog`
- ✅ `design_generator_screen.dart` - Usa `AppHeader`, `ImagePickerDisplay`, `SectionHeader`, `RoomSelector`, `StyleSelector`, `UserStylesDisplay`, `ColorPaletteSelector`, `EmojiFeatureSelector`
- ✅ `favorites_screen.dart` - Usa `SimpleHeader`, `FavoriteCard`
- ✅ `projects_screen.dart` - Usa `SimpleHeader`, `ProjectCard`
- ✅ `profile_screen.dart` - Usa `MenuItemWidget`

---

## 📊 Resumen de Cambios

| Archivo | Widgets Extraídos | Reducción |
|---------|------------------|-----------|
| design_generator_screen.dart | 8 widgets | ~400 líneas |
| favorites_screen.dart | 2 widgets | ~100 líneas |
| projects_screen.dart | 2 widgets | ~70 líneas |
| profile_screen.dart | 1 widget | ~50 líneas |
| login_page.dart | 1 widget | ~60 líneas |
| **TOTAL** | **14 widgets** | **~680 líneas** |



