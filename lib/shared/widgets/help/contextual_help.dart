import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Boto de ajuda flutuante que mostra dicas contextuais
class HelpButton extends StatelessWidget {
  final String title;
  final List<HelpItem> items;
  final Color? color;

  const HelpButton({
    super.key,
    required this.title,
    required this.items,
    this.color,
  });

  void _showHelp(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HelpSheet(title: title, items: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return IconButton(
      onPressed: () => _showHelp(context),
      icon: Icon(
        Icons.help_outline_rounded,
        color: color ?? colors.textSecondary,
      ),
      tooltip: 'Ajuda',
    );
  }
}

class _HelpSheet extends StatelessWidget {
  final String title;
  final List<HelpItem> items;

  const _HelpSheet({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primaryPastel,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.help_rounded,
                      color: colors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Central de Ajuda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _HelpItemCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpItemCard extends StatelessWidget {
  final HelpItem item;

  const _HelpItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.alphaBlend(colors.surface.withValues(alpha: 0.9), item.color),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.grey600,
                    height: 1.4,
                  ),
                ),
                if (item.steps != null && item.steps!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...item.steps!.asMap().entries.map((entry) {
                    final stepIndex = entry.key + 1;
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$stepIndex',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colors.surface,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              step,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.grey700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item de ajuda
class HelpItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String>? steps;

  const HelpItem({
    required this.title,
    required this.description,
    required this.icon,
    this.color = const Color(0xFF6366F1), // roleManager default
    this.steps,
  });
}

/// Boto de ao com tooltip expandido
class ActionButtonWithHelp extends StatelessWidget {
  final String label;
  final String helpText;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExpanded;

  const ActionButtonWithHelp({
    super.key,
    required this.label,
    required this.helpText,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? colors.primary,
        foregroundColor: foregroundColor ?? colors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return Tooltip(
      message: helpText,
      preferBelow: false,
      child: isExpanded
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }
}

/// Campo de input com dica integrada
class InputWithHint extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? helpText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;

  const InputWithHint({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.helpText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (helpText != null) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: helpText!,
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: colors.grey500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
            filled: true,
            fillColor: colors.grey50,
          ),
        ),
      ],
    );
  }
}

/// Atalhos de teclado visveis
class KeyboardShortcutHint extends StatelessWidget {
  final String shortcut;
  final String action;
  final Color? color;

  const KeyboardShortcutHint({
    super.key,
    required this.shortcut,
    required this.action,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors.grey200,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: colors.grey300),
          ),
          child: Text(
            shortcut,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: color ?? colors.grey700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          action,
          style: TextStyle(
            fontSize: 12,
            color: colors.grey600,
          ),
        ),
      ],
    );
  }
}






