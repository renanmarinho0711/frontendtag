import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_colors_dynamic.dart' show ThemeColorsData;

// Importação dos temas
import 'package:tagbean/design_system/theme/theme_colors.dart' as theme_default;
import 'package:tagbean/design_system/theme/temas/theme_colors_t01_emerald_power.dart' as t01;
import 'package:tagbean/design_system/theme/temas/theme_colors_t02_royal_blue.dart' as t02;
import 'package:tagbean/design_system/theme/temas/theme_colors_t03_crimson_fire.dart' as t03;
import 'package:tagbean/design_system/theme/temas/theme_colors_t04_purple_reign.dart' as t04;
import 'package:tagbean/design_system/theme/temas/theme_colors_t05_sunset_orange.dart' as t05;
import 'package:tagbean/design_system/theme/temas/theme_colors_t06_ocean_teal.dart' as t06;
import 'package:tagbean/design_system/theme/temas/theme_colors_t07_lime_fresh.dart' as t07;
import 'package:tagbean/design_system/theme/temas/theme_colors_t08_pink_passion.dart' as t08;
import 'package:tagbean/design_system/theme/temas/theme_colors_t09_amber_gold.dart' as t09;
import 'package:tagbean/design_system/theme/temas/theme_colors_t11_rose_red.dart' as t11;
import 'package:tagbean/design_system/theme/temas/theme_colors_t13_violet_dream.dart' as t13;
import 'package:tagbean/design_system/theme/temas/theme_colors_t15_fuchsia_pop.dart' as t15;
import 'package:tagbean/design_system/theme/temas/theme_colors_v01_dark_mode.dart' as v01;
import 'package:tagbean/design_system/theme/temas/theme_colors_v02_light_pastel.dart' as v02;
import 'package:tagbean/design_system/theme/temas/theme_colors_v03_christmas.dart' as v03;
import 'package:tagbean/design_system/theme/temas/theme_colors_v04_halloween.dart' as v04;
import 'package:tagbean/design_system/theme/temas/theme_colors_v05_easter.dart' as v05;
import 'package:tagbean/design_system/theme/temas/theme_colors_v06_valentine.dart' as v06;
import 'package:tagbean/design_system/theme/temas/theme_colors_v07_summer_beach.dart' as v07;
import 'package:tagbean/design_system/theme/temas/theme_colors_v08_autumn_forest.dart' as v08;
import 'package:tagbean/design_system/theme/temas/theme_colors_v09_corporate_blue.dart' as v09;
import 'package:tagbean/design_system/theme/temas/theme_colors_v10_energetic_sport.dart' as v10;

/// Modelo representando informações de um tema
class ThemeInfo {
  final String id;
  final String name;
  final String description;
  final String category;
  final String fileName;
  final Color primaryColor;
  final Color secondaryColor;

  const ThemeInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.fileName,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

/// Lista de todos os temas disponíveis no sistema
final List<ThemeInfo> availableThemes = [
  // Tema Padrão
  const ThemeInfo(
    id: 'default',
    name: 'Padrão (Forest Green)',
    description: 'Tema padrão do sistema',
    category: 'Padrão',
    fileName: 'theme_colors.dart',
    primaryColor: Color(0xFF22C55E),
    secondaryColor: Color(0xFF16A34A),
  ),
  // Temas Principais (T01-T15)
  const ThemeInfo(
    id: 't01',
    name: 'Emerald Power',
    description: 'Verde esmeralda vibrante',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t01_emerald_power.dart',
    primaryColor: Color(0xFF10B981),
    secondaryColor: Color(0xFF059669),
  ),
  const ThemeInfo(
    id: 't02',
    name: 'Royal Blue',
    description: 'Azul real elegante',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t02_royal_blue.dart',
    primaryColor: Color(0xFF3B82F6),
    secondaryColor: Color(0xFF2563EB),
  ),
  const ThemeInfo(
    id: 't03',
    name: 'Crimson Fire',
    description: 'Vermelho carmesim intenso',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t03_crimson_fire.dart',
    primaryColor: Color(0xFFEF4444),
    secondaryColor: Color(0xFFDC2626),
  ),
  const ThemeInfo(
    id: 't04',
    name: 'Purple Reign',
    description: 'Roxo majestoso',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t04_purple_reign.dart',
    primaryColor: Color(0xFF8B5CF6),
    secondaryColor: Color(0xFF7C3AED),
  ),
  const ThemeInfo(
    id: 't05',
    name: 'Sunset Orange',
    description: 'Laranja pôr do sol',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t05_sunset_orange.dart',
    primaryColor: Color(0xFFF97316),
    secondaryColor: Color(0xFFEA580C),
  ),
  const ThemeInfo(
    id: 't06',
    name: 'Ocean Teal',
    description: 'Azul-verde oceânico',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t06_ocean_teal.dart',
    primaryColor: Color(0xFF14B8A6),
    secondaryColor: Color(0xFF0D9488),
  ),
  const ThemeInfo(
    id: 't07',
    name: 'Lime Fresh',
    description: 'Verde limão refrescante',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t07_lime_fresh.dart',
    primaryColor: Color(0xFF84CC16),
    secondaryColor: Color(0xFF65A30D),
  ),
  const ThemeInfo(
    id: 't08',
    name: 'Pink Passion',
    description: 'Rosa apaixonante',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t08_pink_passion.dart',
    primaryColor: Color(0xFFEC4899),
    secondaryColor: Color(0xFFDB2777),
  ),
  const ThemeInfo(
    id: 't09',
    name: 'Amber Gold',
    description: 'Âmbar dourado',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t09_amber_gold.dart',
    primaryColor: Color(0xFFF59E0B),
    secondaryColor: Color(0xFFD97706),
  ),
  const ThemeInfo(
    id: 't10',
    name: 'Indigo Night',
    description: 'Índigo noturno',
    category: 'Cores Vibrantes',
    fileName: 'BOA theme_colors_t10_indigo_night.dart',
    primaryColor: Color(0xFF6366F1),
    secondaryColor: Color(0xFF4F46E5),
  ),
  const ThemeInfo(
    id: 't11',
    name: 'Rose Red',
    description: 'Vermelho rosado',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t11_rose_red.dart',
    primaryColor: Color(0xFFF43F5E),
    secondaryColor: Color(0xFFE11D48),
  ),
  const ThemeInfo(
    id: 't12',
    name: 'Sky Blue',
    description: 'Azul céu claro',
    category: 'Cores Vibrantes',
    fileName: 'BOA_theme_colors_t12_sky_blue.dart',
    primaryColor: Color(0xFF0EA5E9),
    secondaryColor: Color(0xFF0284C7),
  ),
  const ThemeInfo(
    id: 't13',
    name: 'Violet Dream',
    description: 'Violeta sonhador',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t13_violet_dream.dart',
    primaryColor: Color(0xFFA855F7),
    secondaryColor: Color(0xFF9333EA),
  ),
  const ThemeInfo(
    id: 't14',
    name: 'Forest Green',
    description: 'Verde floresta',
    category: 'Cores Vibrantes',
    fileName: 'BOM_theme_colors_t14_forest_green.dart',
    primaryColor: Color(0xFF22C55E),
    secondaryColor: Color(0xFF16A34A),
  ),
  const ThemeInfo(
    id: 't15',
    name: 'Fuchsia Pop',
    description: 'Fúcsia vibrante',
    category: 'Cores Vibrantes',
    fileName: 'theme_colors_t15_fuchsia_pop.dart',
    primaryColor: Color(0xFFD946EF),
    secondaryColor: Color(0xFFC026D3),
  ),
  // Temas Especiais (V01-V10)
  const ThemeInfo(
    id: 'v01',
    name: 'Dark Mode',
    description: 'Modo escuro elegante',
    category: 'Especiais',
    fileName: 'theme_colors_v01_dark_mode.dart',
    primaryColor: Color(0xFF374151),
    secondaryColor: Color(0xFF1F2937),
  ),
  const ThemeInfo(
    id: 'v02',
    name: 'Light Pastel',
    description: 'Cores pastéis suaves',
    category: 'Especiais',
    fileName: 'theme_colors_v02_light_pastel.dart',
    primaryColor: Color(0xFFA5B4FC),
    secondaryColor: Color(0xFF818CF8),
  ),
  const ThemeInfo(
    id: 'v03',
    name: 'Christmas',
    description: 'Tema natalino',
    category: 'Sazonais',
    fileName: 'theme_colors_v03_christmas.dart',
    primaryColor: Color(0xFFDC2626),
    secondaryColor: Color(0xFF16A34A),
  ),
  const ThemeInfo(
    id: 'v04',
    name: 'Halloween',
    description: 'Tema de Halloween',
    category: 'Sazonais',
    fileName: 'theme_colors_v04_halloween.dart',
    primaryColor: Color(0xFFF97316),
    secondaryColor: Color(0xFF7C2D12),
  ),
  const ThemeInfo(
    id: 'v05',
    name: 'Easter',
    description: 'Tema de Páscoa',
    category: 'Sazonais',
    fileName: 'theme_colors_v05_easter.dart',
    primaryColor: Color(0xFFF9A8D4),
    secondaryColor: Color(0xFFA78BFA),
  ),
  const ThemeInfo(
    id: 'v06',
    name: 'Valentine',
    description: 'Dia dos Namorados',
    category: 'Sazonais',
    fileName: 'theme_colors_v06_valentine.dart',
    primaryColor: Color(0xFFFB7185),
    secondaryColor: Color(0xFFE11D48),
  ),
  const ThemeInfo(
    id: 'v07',
    name: 'Summer Beach',
    description: 'Praia de verão',
    category: 'Sazonais',
    fileName: 'theme_colors_v07_summer_beach.dart',
    primaryColor: Color(0xFF38BDF8),
    secondaryColor: Color(0xFFFBBF24),
  ),
  const ThemeInfo(
    id: 'v08',
    name: 'Autumn Forest',
    description: 'Floresta de outono',
    category: 'Sazonais',
    fileName: 'theme_colors_v08_autumn_forest.dart',
    primaryColor: Color(0xFFD97706),
    secondaryColor: Color(0xFF92400E),
  ),
  const ThemeInfo(
    id: 'v09',
    name: 'Corporate Blue',
    description: 'Azul corporativo',
    category: 'Profissionais',
    fileName: 'theme_colors_v09_corporate_blue.dart',
    primaryColor: Color(0xFF1E40AF),
    secondaryColor: Color(0xFF1E3A8A),
  ),
  const ThemeInfo(
    id: 'v10',
    name: 'Energetic Sport',
    description: 'Esportivo energético',
    category: 'Profissionais',
    fileName: 'theme_colors_v10_energetic_sport.dart',
    primaryColor: Color(0xFFEF4444),
    secondaryColor: Color(0xFFF59E0B),
  ),
];

/// Estado do tema atual
class ThemeState {
  final String currentThemeId;
  final ThemeInfo? currentTheme;
  final bool isLoading;

  const ThemeState({
    this.currentThemeId = 'default',
    this.currentTheme,
    this.isLoading = false,
  });

  ThemeState copyWith({
    String? currentThemeId,
    ThemeInfo? currentTheme,
    bool? isLoading,
  }) {
    return ThemeState(
      currentThemeId: currentThemeId ?? this.currentThemeId,
      currentTheme: currentTheme ?? this.currentTheme,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier para gerenciar o tema
class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'selected_theme_id';

  ThemeNotifier() : super(const ThemeState()) {
    _loadSavedTheme();
  }

  /// Carrega o tema salvo nas preferências
  Future<void> _loadSavedTheme() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeId = prefs.getString(_themeKey);
      if (savedThemeId != null && savedThemeId != 'default') {
        final theme = availableThemes.firstWhere(
          (t) => t.id == savedThemeId,
          orElse: () => availableThemes.first,
        );
        state = state.copyWith(
          currentThemeId: savedThemeId,
          currentTheme: theme,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint('Erro ao carregar tema: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Altera o tema atual
  Future<void> setTheme(String themeId) async {
    debugPrint('?? SETANDO TEMA PARA: $themeId');
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeId);

      if (themeId == 'default') {
        state = state.copyWith(
          currentThemeId: 'default',
          currentTheme: null,
          isLoading: false,
        );
      } else {
        final theme = availableThemes.firstWhere(
          (t) => t.id == themeId,
          orElse: () => availableThemes.first,
        );
        state = state.copyWith(
          currentThemeId: themeId,
          currentTheme: theme,
          isLoading: false,
        );
        debugPrint('? TEMA APLICADO COM SUCESSO: $themeId');
      }
    } catch (e) {
      debugPrint('Erro ao salvar tema: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Reseta para o tema padrão
  Future<void> resetToDefault() async {
    await setTheme('default');
  }

  /// Retorna os temas agrupados por categoria
  Map<String, List<ThemeInfo>> get themesByCategory {
    final Map<String, List<ThemeInfo>> grouped = {};
    for (final theme in availableThemes) {
      grouped.putIfAbsent(theme.category, () => []);
      grouped[theme.category]!.add(theme);
    }
    return grouped;
  }
}

/// Provider do tema
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

/// Provider para obter a lista de temas disponíveis
final availableThemesProvider = Provider<List<ThemeInfo>>((ref) {
  return availableThemes;
});

/// Provider para obter temas por categoria
final themesByCategoryProvider =
    Provider<Map<String, List<ThemeInfo>>>((ref) {
  final notifier = ref.watch(themeProvider.notifier);
  return notifier.themesByCategory;
});

/// Classe de cores dinâmicas baseada no tema selecionado
/// Fornece acesso às cores do tema atual
class DynamicThemeColors {
  /// Obtém a cor primária do dashboard baseada no tema
  static Color primaryDashboard(String themeId) {
    return _getColorFromTheme(themeId, 'primaryDashboard');
  }
  
  /// Obtém a cor primária do dashboard dark baseada no tema
  static Color primaryDashboardDark(String themeId) {
    return _getColorFromTheme(themeId, 'primaryDashboardDark');
  }
  
  /// Obtém a cor do módulo dashboard baseada no tema
  static Color moduleDashboard(String themeId) {
    return _getColorFromTheme(themeId, 'moduleDashboard');
  }
  
  /// Obtém a cor do módulo dashboard dark baseada no tema
  static Color moduleDashboardDark(String themeId) {
    return _getColorFromTheme(themeId, 'moduleDashboardDark');
  }
  
  /// Obtém a cor de sucesso baseada no tema
  static Color success(String themeId) {
    return _getColorFromTheme(themeId, 'success');
  }
  
  /// Obtém a cor primária de um tema específico
  static Color getPrimaryColor(String themeId) {
    final theme = availableThemes.firstWhere(
      (t) => t.id == themeId,
      orElse: () => availableThemes.first,
    );
    return theme.primaryColor;
  }
  
  /// Obtém a cor secundária de um tema específico
  static Color getSecondaryColor(String themeId) {
    final theme = availableThemes.firstWhere(
      (t) => t.id == themeId,
      orElse: () => availableThemes.first,
    );
    return theme.secondaryColor;
  }
  
  static Color _getColorFromTheme(String themeId, String colorName) {
    switch (themeId) {
      case 't01':
        return _getT01Color(colorName);
      case 't02':
        return _getT02Color(colorName);
      case 't03':
        return _getT03Color(colorName);
      case 't04':
        return _getT04Color(colorName);
      case 't05':
        return _getT05Color(colorName);
      case 't06':
        return _getT06Color(colorName);
      case 't07':
        return _getT07Color(colorName);
      case 't08':
        return _getT08Color(colorName);
      case 't09':
        return _getT09Color(colorName);
      case 't11':
        return _getT11Color(colorName);
      case 't13':
        return _getT13Color(colorName);
      case 't15':
        return _getT15Color(colorName);
      case 'v01':
        return _getV01Color(colorName);
      case 'v02':
        return _getV02Color(colorName);
      case 'v03':
        return _getV03Color(colorName);
      case 'v04':
        return _getV04Color(colorName);
      case 'v05':
        return _getV05Color(colorName);
      case 'v06':
        return _getV06Color(colorName);
      case 'v07':
        return _getV07Color(colorName);
      case 'v08':
        return _getV08Color(colorName);
      case 'v09':
        return _getV09Color(colorName);
      case 'v10':
        return _getV10Color(colorName);
      default:
        return _getDefaultColor(colorName);
    }
  }
  
  static Color _getDefaultColor(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return theme_default.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return theme_default.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return theme_default.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return theme_default.AppThemeColors.moduleDashboardDark;
      case 'success':
        return theme_default.AppThemeColors.success;
      default:
        return theme_default.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT01Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t01.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t01.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t01.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t01.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t01.AppThemeColors.success;
      default:
        return t01.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT02Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t02.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t02.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t02.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t02.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t02.AppThemeColors.success;
      default:
        return t02.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT03Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t03.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t03.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t03.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t03.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t03.AppThemeColors.success;
      default:
        return t03.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT04Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t04.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t04.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t04.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t04.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t04.AppThemeColors.success;
      default:
        return t04.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT05Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t05.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t05.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t05.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t05.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t05.AppThemeColors.success;
      default:
        return t05.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT06Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t06.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t06.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t06.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t06.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t06.AppThemeColors.success;
      default:
        return t06.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT07Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t07.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t07.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t07.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t07.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t07.AppThemeColors.success;
      default:
        return t07.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT08Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t08.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t08.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t08.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t08.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t08.AppThemeColors.success;
      default:
        return t08.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT09Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t09.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t09.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t09.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t09.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t09.AppThemeColors.success;
      default:
        return t09.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT11Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t11.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t11.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t11.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t11.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t11.AppThemeColors.success;
      default:
        return t11.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT13Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t13.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t13.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t13.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t13.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t13.AppThemeColors.success;
      default:
        return t13.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getT15Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return t15.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return t15.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return t15.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return t15.AppThemeColors.moduleDashboardDark;
      case 'success':
        return t15.AppThemeColors.success;
      default:
        return t15.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV01Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v01.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v01.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v01.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v01.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v01.AppThemeColors.success;
      default:
        return v01.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV02Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v02.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v02.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v02.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v02.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v02.AppThemeColors.success;
      default:
        return v02.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV03Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v03.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v03.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v03.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v03.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v03.AppThemeColors.success;
      default:
        return v03.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV04Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v04.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v04.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v04.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v04.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v04.AppThemeColors.success;
      default:
        return v04.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV05Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v05.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v05.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v05.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v05.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v05.AppThemeColors.success;
      default:
        return v05.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV06Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v06.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v06.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v06.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v06.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v06.AppThemeColors.success;
      default:
        return v06.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV07Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v07.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v07.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v07.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v07.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v07.AppThemeColors.success;
      default:
        return v07.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV08Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v08.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v08.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v08.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v08.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v08.AppThemeColors.success;
      default:
        return v08.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV09Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v09.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v09.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v09.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v09.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v09.AppThemeColors.success;
      default:
        return v09.AppThemeColors.primaryDashboard;
    }
  }
  
  static Color _getV10Color(String colorName) {
    switch (colorName) {
      case 'primaryDashboard':
        return v10.AppThemeColors.primaryDashboard;
      case 'primaryDashboardDark':
        return v10.AppThemeColors.primaryDashboardDark;
      case 'moduleDashboard':
        return v10.AppThemeColors.moduleDashboard;
      case 'moduleDashboardDark':
        return v10.AppThemeColors.moduleDashboardDark;
      case 'success':
        return v10.AppThemeColors.success;
      default:
        return v10.AppThemeColors.primaryDashboard;
    }
  }
}

/// Provider que fornece as cores dinâmicas do tema atual
/// Usa ThemeColorsData de theme_colors_dynamic.dart com 150+ cores
final dynamicThemeColorsProvider = Provider<ThemeColorsData>((ref) {
  final themeState = ref.watch(themeProvider);
  return ThemeColorsData.fromThemeId(themeState.currentThemeId);
});







