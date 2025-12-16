mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Bottom Sheet personalizado reutilizvel
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final bool showHandle;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;
  final double? maxHeight;
  final bool isScrollable;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showHandle = true,
    this.showCloseButton = false,
    this.padding,
    this.maxHeight,
    this.isScrollable = true,
  });

  /// Exibe o bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    List<Widget>? actions,
    bool showHandle = true,
    bool showCloseButton = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        actions: actions,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        maxHeight: maxHeight,
        padding: padding,
        child: child,
      ),
    );
  }

  /// Factory para bottom sheet de opes
  static Future<T?> showOptions<T>({
    required BuildContext context,
    required String title,
    required List<BottomSheetOption<T>> options,
    bool showCancel = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      showCloseButton: showCancel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options
            .map((option) => ListTile(
                  leading: option.icon != null ? Icon(option.icon) : null,
                  title: Text(option.label),
                  subtitle:
                      option.subtitle != null ? Text(option.subtitle!) : null,
                  onTap: () => Navigator.of(context).pop(option.value),
                  trailing: option.trailing,
                ))
            .toList(),
      ),
    );
  }

  /// Factory para bottom sheet de confirmao
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDanger = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: isDanger
                      ? FilledButton.styleFrom(
                          backgroundColor: ThemeColors.of(context).redMain,
                        )
                      : null,
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Factory para bottom sheet de formulrio
  static Future<T?> showForm<T>({
    required BuildContext context,
    required String title,
    required Widget form,
    String submitText = 'Salvar',
    VoidCallback? onSubmit,
  }) {
    return show<T>(
      context: context,
      title: title,
      isScrollControlled: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            form,
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onSubmit,
              child: Text(submitText),
            ),
          ],
        ),
      ),
    );
  }

  /// Factory para bottom sheet de seleo
  static Future<T?> showSelection<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    T? selected,
    Widget Function(T)? leadingBuilder,
  }) {
    return show<T>(
      context: context,
      title: title,
      isScrollControlled: true,
      maxHeight: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item == selected;
          return ListTile(
            leading: leadingBuilder?.call(item),
            title: Text(labelBuilder(item)),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            selected: isSelected,
            onTap: () => Navigator.of(context).pop(item),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    Widget content = child;

    if (isScrollable) {
      content = SingleChildScrollView(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      );
    } else {
      content = Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? mediaQuery.size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            if (showHandle)
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(theme.colorScheme.onSurface.withValues(alpha: 0.3), ThemeColors.of(context).surface),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

            // Header
            if (title != null || showCloseButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (showCloseButton)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
              ),

            // Content
            Flexible(child: content),

            // Actions
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: actions!
                      .map((action) => Expanded(child: action))
                      .toList()
                      .expand((widget) => [widget, const SizedBox(width: 12)])
                      .toList()
                    ..removeLast(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Opo para bottom sheet de opes
class BottomSheetOption<T> {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final T value;
  final Widget? trailing;

  const BottomSheetOption({
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.trailing,
  });
}

/// Bottom sheet para filtros
class FilterBottomSheet extends StatefulWidget {
  final String title;
  final Map<String, List<String>> filters;
  final Map<String, List<String>> selected;
  final ValueChanged<Map<String, List<String>>> onApply;

  const FilterBottomSheet({
    super.key,
    this.title = 'Filtros',
    required this.filters,
    required this.selected,
    required this.onApply,
  });

  static Future<Map<String, List<String>>?> show({
    required BuildContext context,
    required Map<String, List<String>> filters,
    Map<String, List<String>>? selected,
  }) {
    return showModalBottomSheet<Map<String, List<String>>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.of(context).transparent,
      builder: (context) => FilterBottomSheet(
        filters: filters,
        selected: selected ?? {},
        onApply: (result) => Navigator.of(context).pop(result),
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, List<String>> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Map.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBottomSheet(
      title: widget.title,
      showCloseButton: true,
      actions: [
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selected.clear();
            });
          },
          child: const Text('Limpar'),
        ),
        FilledButton(
          onPressed: () => widget.onApply(_selected),
          child: const Text('Aplicar'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.filters.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.value.map((option) {
                  final isSelected =
                      _selected[entry.key]?.contains(option) ?? false;
                  return FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selected[entry.key] = [
                            ...(_selected[entry.key] ?? []),
                            option
                          ];
                        } else {
                          _selected[entry.key] =
                              (_selected[entry.key] ?? [])
                                  .where((o) => o != option)
                                  .toList();
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}





