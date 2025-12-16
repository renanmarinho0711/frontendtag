mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';
/// Widget de filtros para a lista de produtos
class ProductFilters extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode? searchFocusNode;
  final String searchQuery;
  final String filterCategoria;
  final String filterStatus;
  final Function(String) onSearchChanged;
  final Function(String) onCategoriaChanged;
  final Function(String) onStatusChanged;
  final VoidCallback onClearFilters;
  final List<String> categorias;
  final List<String> statusOptions;

  const ProductFilters({
    super.key,
    required this.searchController,
    this.searchFocusNode,
    required this.searchQuery,
    required this.filterCategoria,
    required this.filterStatus,
    required this.onSearchChanged,
    required this.onCategoriaChanged,
    required this.onStatusChanged,
    required this.onClearFilters,
    this.categorias = const [
      'Todas',
      'Bebidas',
      'Mercearia',
      'Perec�veis',
      'Limpeza',
      'Higiene'
    ],
    this.statusOptions = const [
      'Todos',
      'Com Tag',
      'Sem Tag',
      'Ativo',
      'Inativo'
    ],
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 900;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFilterContainer(context, isMobile, isTablet),
        if (_hasActiveFilters())
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: _buildActiveFilters(context, isMobile, isTablet),
          ),
      ],
    );
  }

  bool _hasActiveFilters() {
    return filterCategoria != 'Todas' || filterStatus != 'Todos';
  }

  Widget _buildFilterContainer(
      BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.05),
            ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: AppRadius.card,
        border: Border.all(
            color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSearchField(context, isMobile, isTablet),
          SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
          _buildDropdowns(context, isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, bool isMobile, bool isTablet) {
    return TextField(
      controller: searchController,
      focusNode: searchFocusNode,
      style: TextStyle(
        fontSize: AppTextStyles.fontSizeBase.get(isMobile, isTablet),
        color: ThemeColors.of(context).textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar por nome ou c�digo...',
        hintStyle: TextStyle(
          color: ThemeColors.of(context).textTertiary.withValues(alpha: 0.6),
          fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
        ),
        prefixIcon: Container(
          margin: EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.xs),
          child: Icon(
            Icons.search_rounded,
            color: ThemeColors.of(context).brandPrimaryGreen,
            size: AppSizes.iconMedium.get(isMobile, isTablet),
          ),
        ),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: Container(
                  padding: EdgeInsets.all(AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.clear_rounded,
                    color: ThemeColors.of(context).brandPrimaryGreen,
                    size: AppSizes.iconSmall.get(isMobile, isTablet),
                  ),
                ),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide:
              BorderSide(color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide:
              BorderSide(color: ThemeColors.of(context).brandPrimaryGreen.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: BorderSide(color: ThemeColors.of(context).brandPrimaryGreen, width: 2),
        ),
        filled: true,
        fillColor: ThemeColors.of(context).surfaceOverlay90,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd.get(isMobile, isTablet),
          vertical: AppSizes.paddingMd.get(isMobile, isTablet),
        ),
        isDense: false,
      ),
      onChanged: onSearchChanged,
    );
  }

  Widget _buildDropdowns(BuildContext context, bool isMobile, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: filterCategoria,
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
              color: ThemeColors.of(context).textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Categoria',
              labelStyle: TextStyle(
                  fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet)),
              prefixIcon: Icon(Icons.category_rounded,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
              border: OutlineInputBorder(borderRadius: AppRadius.lg),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              isDense: true,
            ),
            items: categorias
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                            fontSize: AppTextStyles.fontSizeSmAlt
                                .get(isMobile, isTablet)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (value) => onCategoriaChanged(value!),
          ),
        ),
        SizedBox(width: AppSizes.paddingBase.get(isMobile, isTablet)),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: filterStatus,
            style: TextStyle(
              fontSize: AppTextStyles.fontSizeSmAlt.get(isMobile, isTablet),
              color: ThemeColors.of(context).textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Status',
              labelStyle: TextStyle(
                  fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet)),
              prefixIcon: Icon(Icons.filter_list_rounded,
                  size: AppSizes.iconMediumSmall.get(isMobile, isTablet)),
              border: OutlineInputBorder(borderRadius: AppRadius.lg),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingBase.get(isMobile, isTablet),
                vertical: AppSizes.paddingSmAlt.get(isMobile, isTablet),
              ),
              isDense: true,
            ),
            items: statusOptions
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                            fontSize: AppTextStyles.fontSizeSmAlt
                                .get(isMobile, isTablet)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (value) => onStatusChanged(value!),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilters(
      BuildContext context, bool isMobile, bool isTablet) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (filterCategoria != 'Todas')
          _buildFilterChip(context, 'Categoria: $filterCategoria',
            () => onCategoriaChanged('Todas'),
            isMobile,
            isTablet,
          ),
        if (filterStatus != 'Todos')
          _buildFilterChip(context, 'Status: $filterStatus',
            () => onStatusChanged('Todos'),
            isMobile,
            isTablet,
          ),
        TextButton.icon(
          onPressed: onClearFilters,
          icon: Icon(Icons.clear_all_rounded,
              size: AppSizes.iconSmall.get(isMobile, isTablet)),
          label: Text(
            'Limpar tudo',
            style: TextStyle(
                fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet)),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, 
    String label,
    VoidCallback onRemove,
    bool isMobile,
    bool isTablet,
  ) {
    return Chip(
      label: Text(label,
          style: TextStyle(
              fontSize: AppTextStyles.fontSizeXsAlt.get(isMobile, isTablet))),
      deleteIcon: Icon(Icons.close_rounded,
          size: AppSizes.iconSmall.get(isMobile, isTablet)),
      onDeleted: onRemove,
      backgroundColor: ThemeColors.of(context).successLight,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.sm,
        side: BorderSide(color: ThemeColors.of(context).success),
      ),
    );
  }
}





