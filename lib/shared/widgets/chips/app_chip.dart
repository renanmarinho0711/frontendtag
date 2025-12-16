mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Chip personalizado para tags e filtros
class AppChip extends StatelessWidget {
  final String label;
  final Widget? avatar;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool selected;
  final bool deletable;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final double? elevation;
  final EdgeInsetsGeometry? padding;

  const AppChip({
    super.key,
    required this.label,
    this.avatar,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.selected = false,
    this.deletable = false,
    this.onTap,
    this.onDeleted,
    this.elevation,
    this.padding,
  });

  /// Factory para chip de filtro
  factory AppChip.filter({
    required String label,
    required bool selected,
    VoidCallback? onTap,
    IconData? icon,
  }) =>
      AppChip(
        label: label,
        selected: selected,
        onTap: onTap,
        icon: icon,
      );

  /// Factory para chip de tag
  factory AppChip.tag({
    required String label,
    Color? color,
    VoidCallback? onDeleted,
  }) =>
      AppChip(
        label: label,
        backgroundColor: color != null ? Color.alphaBlend(color.withValues(alpha: 0.1), ThemeColors.of(context).surface) : null,
        textColor: color,
        borderColor: color != null ? Color.alphaBlend(color.withValues(alpha: 0.3), ThemeColors.of(context).surface) : null,
        deletable: onDeleted != null,
        onDeleted: onDeleted,
      );

  /// Factory para chip de categoria
  factory AppChip.category({
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) =>
      AppChip(
        label: label,
        backgroundColor: Color.alphaBlend(color.withValues(alpha: 0.15), ThemeColors.of(context).surface),
        textColor: color,
        onTap: onTap,
      );

  /// Factory para chip de status
  factory AppChip.status({
    required String status,
    VoidCallback? onTap,
  }) {
    final (color, displayLabel) = _getStatusStyle(status);
    return AppChip(
      label: displayLabel,
      backgroundColor: Color.alphaBlend(color.withValues(alpha: 0.1), ThemeColors.of(context).surface),
      textColor: color,
      borderColor: Color.alphaBlend(color.withValues(alpha: 0.3), ThemeColors.of(context).surface),
      onTap: onTap,
    );
  }

  static (Color, String) _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'ativo':
        return (ThemeColors.of(context).greenMaterial, 'Ativo');
      case 'inactive':
      case 'inativo':
        return (ThemeColors.of(context).grey500, 'Inativo');
      case 'pending':
      case 'pendente':
        return (ThemeColors.of(context).orangeMaterial, 'Pendente');
      case 'error':
      case 'erro':
        return (ThemeColors.of(context).redMain, 'Erro');
      case 'synced':
      case 'sincronizado':
        return (ThemeColors.of(context).greenMaterial, 'Sincronizado');
      default:
        return (ThemeColors.of(context).grey500, status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBgColor = selected
        ? colorScheme.primary
        : backgroundColor ?? colorScheme.surfaceContainerHighest;

    final effectiveTextColor = selected
        ? colorScheme.onPrimary
        : textColor ?? colorScheme.onSurface;

    if (deletable) {
      return InputChip(
        label: Text(label),
        avatar: _buildAvatar(),
        backgroundColor: effectiveBgColor,
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(color: effectiveTextColor),
        selected: selected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        onDeleted: onDeleted,
        deleteIconColor: Color.alphaBlend(effectiveTextColor.withValues(alpha: 0.7), ThemeColors.of(context).surface),
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
        elevation: elevation,
        padding: padding,
      );
    }

    if (onTap != null) {
      return FilterChip(
        label: Text(label),
        avatar: _buildAvatar(),
        backgroundColor: effectiveBgColor,
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(color: effectiveTextColor),
        selected: selected,
        onSelected: (_) => onTap!(),
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
        elevation: elevation,
        padding: padding,
      );
    }

    return Chip(
      label: Text(label),
      avatar: _buildAvatar(),
      backgroundColor: effectiveBgColor,
      labelStyle: TextStyle(color: effectiveTextColor),
      side: borderColor != null ? BorderSide(color: borderColor!) : null,
      elevation: elevation,
      padding: padding,
    );
  }

  Widget? _buildAvatar() {
    if (avatar != null) return avatar;
    if (icon != null) {
      return Icon(
        icon,
        size: 18,
        color: textColor,
      );
    }
    return null;
  }
}

/// Grupo de chips selecionveis (single ou multi-select)
class AppChipGroup extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final bool multiSelect;
  final bool wrap;
  final double spacing;
  final double runSpacing;

  const AppChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.multiSelect = false,
    this.wrap = true,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final chips = options.map((option) {
      final isSelected = selected.contains(option);
      return AppChip.filter(
        label: option,
        selected: isSelected,
        onTap: () => _onChipTap(option, isSelected),
      );
    }).toList();

    if (wrap) {
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: chips,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map((chip) => Padding(
                  padding: EdgeInsets.only(right: spacing),
                  child: chip,
                ))
            .toList(),
      ),
    );
  }

  void _onChipTap(String option, bool isSelected) {
    if (multiSelect) {
      if (isSelected) {
        onChanged(selected.where((s) => s != option).toList());
      } else {
        onChanged([...selected, option]);
      }
    } else {
      if (isSelected) {
        onChanged([]);
      } else {
        onChanged([option]);
      }
    }
  }
}

/// Chips para exibir lista de tags
class TagChips extends StatelessWidget {
  final List<String> tags;
  final ValueChanged<String>? onDeleted;
  final int? maxVisible;
  final Color? color;

  const TagChips({
    super.key,
    required this.tags,
    this.onDeleted,
    this.maxVisible,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final visibleTags =
        maxVisible != null ? tags.take(maxVisible!).toList() : tags;

    final hiddenCount =
        maxVisible != null ? tags.length - maxVisible! : 0;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...visibleTags.map((tag) => AppChip.tag(
              label: tag,
              color: color,
              onDeleted: onDeleted != null ? () => onDeleted!(tag) : null,
            )),
        if (hiddenCount > 0)
          AppChip(
            label: '+$hiddenCount',
            backgroundColor: ThemeColors.of(context).grey500Overlay10,
            textColor: ThemeColors.of(context).grey500,
          ),
      ],
    );
  }
}





