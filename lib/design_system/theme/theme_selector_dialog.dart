mport 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
import 'package:tagbean/design_system/theme/theme_provider.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Di�logo para sele��o de temas do sistema
class ThemeSelectorDialog extends ConsumerStatefulWidget {
  const ThemeSelectorDialog({super.key});

  /// Mostra o di�logo de sele��o de temas
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => const ThemeSelectorDialog(),
    );
  }

  @override
  ConsumerState<ThemeSelectorDialog> createState() =>
      _ThemeSelectorDialogState();
}

class _ThemeSelectorDialogState extends ConsumerState<ThemeSelectorDialog> {
  String? _selectedThemeId;
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    // Inicializa com o tema atual
    final currentTheme = ref.read(themeProvider);
    _selectedThemeId = currentTheme.currentThemeId;
  }

  List<String> get _categories {
    final categories = <String>{'Todos'};
    for (final theme in availableThemes) {
      categories.add(theme.category);
    }
    return categories.toList();
  }

  List<ThemeInfo> get _filteredThemes {
    return availableThemes.where((theme) {
      // Filtro por categoria
      if (_selectedCategory != 'Todos' &&
          theme.category != _selectedCategory) {
        return false;
      }
      // Filtro por busca
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return theme.name.toLowerCase().contains(query) ||
            theme.description.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final themeState = ref.watch(themeProvider);

    return Dialog(
      backgroundColor: AppThemeColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
      ),
      child: Container(
        width: isMobile ? double.infinity : (isTablet ? 600 : 700),
        height: isMobile ? MediaQuery.of(context).size.height * 0.85 : 600,
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, isMobile),
            const SizedBox(height: 16),
            
            // Search bar
            _buildSearchBar(context, isMobile),
            const SizedBox(height: 12),
            
            // Categories
            _buildCategoryChips(context, isMobile),
            const SizedBox(height: 16),
            
            // Tema atual
            if (themeState.currentTheme != null) ...[
              _buildCurrentThemeInfo(context, themeState, isMobile),
              const SizedBox(height: 12),
            ],
            
            // Lista de temas
            Expanded(
              child: _buildThemeGrid(context, isMobile, isTablet),
            ),
            
            const SizedBox(height: 16),
            
            // Bot�es de a��o
            _buildActionButtons(context, themeState, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    // Usa cores do tema selecionado para preview
    final previewTheme = _selectedThemeId != null
        ? availableThemes.firstWhere(
            (t) => t.id == _selectedThemeId,
            orElse: () => availableThemes.first,
          )
        : null;
    final previewPrimary = previewTheme?.primaryColor ?? AppThemeColors.moduleDashboard;
    final previewSecondary = previewTheme?.secondaryColor ?? AppThemeColors.moduleDashboardDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [previewPrimary, previewSecondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.palette_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecionar Tema',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.textPrimary,
                  ),
                ),
                Text(
                  '${availableThemes.length} temas dispon�veis',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppThemeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
          style: IconButton.styleFrom(
            backgroundColor: AppThemeColors.grey100,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Buscar tema...',
          hintStyle: TextStyle(color: AppThemeColors.grey500),
          prefixIcon: Icon(Icons.search_rounded, color: AppThemeColors.grey400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context, bool isMobile) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return FilterChip(
            label: Text(
              category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppThemeColors.surface
                    : AppThemeColors.textSecondary,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedCategory = category),
            backgroundColor: AppThemeColors.grey100,
            selectedColor: AppThemeColors.primaryDashboard,
            checkmarkColor: AppThemeColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          );
        },
      ),
    );
  }

  Widget _buildCurrentThemeInfo(
    BuildContext context,
    ThemeState themeState,
    bool isMobile,
  ) {
    final theme = themeState.currentTheme;
    if (theme == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemeColors.successBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemeColors.successBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema atual: ${theme.name}',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.successText,
                  ),
                ),
                Text(
                  theme.description,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: AppThemeColors.successDark,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: AppThemeColors.success,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeGrid(BuildContext context, bool isMobile, bool isTablet) {
    final themes = _filteredThemes;
    
    if (themes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppThemeColors.grey400,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum tema encontrado',
              style: TextStyle(
                fontSize: 16,
                color: AppThemeColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isMobile ? 1.0 : 1.1,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        return _buildThemeCard(context, theme, isMobile);
      },
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeInfo theme, bool isMobile) {
    final isSelected = _selectedThemeId == theme.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedThemeId = theme.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppThemeColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppThemeColors.primaryDashboard
                : AppThemeColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppThemeColors.primaryDashboard.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview das cores
            Container(
              height: isMobile ? 50 : 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: theme.primaryColor,
                          size: 18,
                        ),
                      ),
                    )
                  : null,
            ),
            // Info do tema
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      theme.name,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: AppThemeColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      theme.description,
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 11,
                        color: AppThemeColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppThemeColors.grey100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        theme.category,
                        style: TextStyle(
                          fontSize: isMobile ? 9 : 10,
                          color: AppThemeColors.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ThemeState themeState,
    bool isMobile,
  ) {
    // Usa cores do tema selecionado para o bot�o
    final previewTheme = _selectedThemeId != null
        ? availableThemes.firstWhere(
            (t) => t.id == _selectedThemeId,
            orElse: () => availableThemes.first,
          )
        : null;
    final buttonColor = previewTheme?.primaryColor ?? AppThemeColors.primaryDashboard;

    return Row(
      children: [
        // Bot�o resetar para padr�o
        TextButton.icon(
          onPressed: () {
            setState(() => _selectedThemeId = 'default');
          },
          icon: const Icon(Icons.restore_rounded, size: 18),
          label: Text(isMobile ? 'Resetar' : 'Resetar para Padr�o'),
          style: TextButton.styleFrom(
            foregroundColor: AppThemeColors.textSecondary,
          ),
        ),
        const Spacer(),
        // Bot�o cancelar
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppThemeColors.textSecondary,
          ),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 8),
        // Bot�o aplicar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ElevatedButton.icon(
            onPressed: _selectedThemeId != null
                ? () async {
                    final selectedTheme = availableThemes.firstWhere(
                      (t) => t.id == _selectedThemeId,
                      orElse: () => availableThemes.first,
                    );
                    await ref
                        .read(themeProvider.notifier)
                        .setTheme(_selectedThemeId!);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tema "${selectedTheme.name}" aplicado!',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'O tema foi aplicado com sucesso.',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: selectedTheme.primaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                : null,
            icon: themeState.isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppThemeColors.surface,
                    ),
                  )
                : const Icon(Icons.check_rounded, size: 18),
            label: Text(themeState.isLoading ? 'Aplicando...' : 'Aplicar Tema'),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}




