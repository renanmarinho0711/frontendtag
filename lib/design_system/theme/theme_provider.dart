import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart' show ThemeColorsData;

// Importação do tema padrão
import 'package:tagbean/design_system/theme/theme_colors.dart' as theme_default;

/// Modelo representando informa��es de um tema
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
  // Tema Padrão (Indigo/Purple)
  const ThemeInfo(
    id: 'default',
    name: 'Padrão (Indigo)',
    description: 'Tema padrão do sistema',
    category: 'Padrão',
    fileName: 'theme_colors.dart',
    primaryColor: Color(0xFF6366F1),
    secondaryColor: Color(0xFF4F46E5),
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

  /// Carrega o tema salvo nas prefer�ncias
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

  /// Reseta para o tema padr�o
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

/// Provider para obter a lista de temas dispon�veis
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
    return theme_default.AppThemeColors.primaryDashboard;
  }
  
  /// Obtém a cor primária do dashboard dark baseada no tema
  static Color primaryDashboardDark(String themeId) {
    return theme_default.AppThemeColors.primaryDashboardDark;
  }
  
  /// Obtém a cor do módulo dashboard baseada no tema
  static Color moduleDashboard(String themeId) {
    return theme_default.AppThemeColors.moduleDashboard;
  }
  
  /// Obtém a cor do módulo dashboard dark baseada no tema
  static Color moduleDashboardDark(String themeId) {
    return theme_default.AppThemeColors.moduleDashboardDark;
  }
  
  /// Obtém a cor de sucesso baseada no tema
  static Color success(String themeId) {
    return theme_default.AppThemeColors.success;
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
}

/// Provider que fornece as cores dinâmicas do tema atual
/// Usa ThemeColorsData de theme_colors_dynamic.dart com 150+ cores
final dynamicThemeColorsProvider = Provider<ThemeColorsData>((ref) {
  final themeState = ref.watch(themeProvider);
  return ThemeColorsData.fromThemeId(themeState.currentThemeId);
});

