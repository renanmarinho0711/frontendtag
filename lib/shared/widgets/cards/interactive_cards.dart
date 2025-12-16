mport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Card de ao rpida com hover effects e feedback visual
class QuickActionCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;
  final bool isDisabled;
  final String? badge;
  final bool showArrow;

  const QuickActionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.color,
    this.gradientColors,
    this.onTap,
    this.isDisabled = false,
    this.badge,
    this.showArrow = true,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && widget.onTap != null) {
      setState(() => _isPressed = true);
      _controller.forward();
      HapticFeedback.selectionClick();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? ThemeColors.of(context).primary;
    final gradient = widget.gradientColors != null
        ? LinearGradient(
            colors: widget.gradientColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [baseColor, Color.alphaBlend(baseColor.withValues(alpha: 0.8), ThemeColors.of(context).surface)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: widget.isDisabled ? null : gradient,
            color: widget.isDisabled ? ThemeColors.of(context).grey200 : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.isDisabled
                ? null
                : [
                    BoxShadow(
                      color: Color.alphaBlend(baseColor.withOpacity(_isPressed ? 0.2 : 0.3), ThemeColors.of(context).surface),
                      blurRadius: _isPressed ? 8 : 12,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.isDisabled ? ThemeColors.of(context).surfaceOverlay50 : ThemeColors.of(context).surfaceOverlay20,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.isDisabled ? ThemeColors.of(context).grey600 : ThemeColors.of(context).surface,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  if (widget.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).surfaceOverlay25,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.badge!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: widget.isDisabled ? ThemeColors.of(context).grey600 : ThemeColors.of(context).surface,
                        ),
                      ),
                    ),
                  if (widget.showArrow && !widget.isDisabled)
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: ThemeColors.of(context).surfaceOverlay70,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.isDisabled ? ThemeColors.of(context).grey700 : ThemeColors.of(context).surface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isDisabled 
                        ? ThemeColors.of(context).grey500 
                        : ThemeColors.of(context).surfaceOverlay80,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Item de lista com visual moderno e feedback de toque
class ModernListTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final bool showDivider;
  final EdgeInsets? padding;

  const ModernListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.showDivider = true,
    this.padding,
  });

  @override
  State<ModernListTile> createState() => _ModernListTileState();
}

class _ModernListTileState extends State<ModernListTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            if (widget.onTap != null) {
              HapticFeedback.selectionClick();
              widget.onTap!();
            }
          },
          onLongPress: widget.onLongPress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: widget.padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isPressed
                  ? ThemeColors.of(context).grey100
                  : widget.backgroundColor ?? ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: ThemeColors.of(context).grey600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 12),
                  widget.trailing!,
                ] else if (widget.onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: ThemeColors.of(context).grey400,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
        if (widget.showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: ThemeColors.of(context).grey100,
            indent: widget.leading != null ? 72 : 16,
          ),
      ],
    );
  }
}

/// Card de informao com cone
class InfoCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Color? color;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;
  final InfoCardType type;

  const InfoCard({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.color,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
    this.type = InfoCardType.info,
  });

  factory InfoCard.tip({
    required String title,
    String? description,
    VoidCallback? onDismiss,
  }) {
    return InfoCard(
      title: title,
      description: description,
      icon: Icons.lightbulb_outline_rounded,
      type: InfoCardType.tip,
      onDismiss: onDismiss,
    );
  }

  factory InfoCard.warning({
    required String title,
    String? description,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return InfoCard(
      title: title,
      description: description,
      icon: Icons.warning_amber_rounded,
      type: InfoCardType.warning,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  factory InfoCard.success({
    required String title,
    String? description,
    VoidCallback? onDismiss,
  }) {
    return InfoCard(
      title: title,
      description: description,
      icon: Icons.check_circle_outline_rounded,
      type: InfoCardType.success,
      onDismiss: onDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.$2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.alphaBlend(colors.$3.withValues(alpha: 0.2), ThemeColors.of(context).surface),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colors.$3, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.$3,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.alphaBlend(colors.$3.withValues(alpha: 0.8), ThemeColors.of(context).surface),
                    ),
                  ),
                ],
                if (onAction != null && actionLabel != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.$3,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, size: 18, color: colors.$3),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  (Color, Color, Color) _getColors() {
    switch (type) {
      case InfoCardType.info:
        return (
          ThemeColors.of(context).infoCardBg,
          ThemeColors.of(context).infoCardBorder,
          ThemeColors.of(context).infoCardText,
        );
      case InfoCardType.tip:
        return (
          ThemeColors.of(context).tipCardBg,
          ThemeColors.of(context).tipCardBorder,
          ThemeColors.of(context).tipCardText,
        );
      case InfoCardType.warning:
        return (
          ThemeColors.of(context).warningCardBg,
          ThemeColors.of(context).warningCardBorder,
          ThemeColors.of(context).warningCardText,
        );
      case InfoCardType.success:
        return (
          ThemeColors.of(context).successCardBg,
          ThemeColors.of(context).successCardBorder,
          ThemeColors.of(context).successCardText,
        );
      case InfoCardType.error:
        return (
          ThemeColors.of(context).errorCardBg,
          ThemeColors.of(context).errorCardBorder,
          ThemeColors.of(context).errorCardText,
        );
    }
  }
}

enum InfoCardType { info, tip, warning, success, error }

/// Tooltip interativo com contedo customizado
class InteractiveTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Widget? content;
  final TooltipTrigger trigger;

  const InteractiveTooltip({
    super.key,
    required this.child,
    required this.message,
    this.content,
    this.trigger = TooltipTrigger.longPress,
  });

  @override
  State<InteractiveTooltip> createState() => _InteractiveTooltipState();
}

class _InteractiveTooltipState extends State<InteractiveTooltip> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  void _showTooltip() {
    if (_isShowing) return;
    _isShowing = true;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        position: position,
        size: size,
        message: widget.message,
        content: widget.content,
        onDismiss: _hideTooltip,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    HapticFeedback.selectionClick();
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onLongPress: widget.trigger == TooltipTrigger.longPress ? _showTooltip : null,
      onTap: widget.trigger == TooltipTrigger.tap ? _showTooltip : null,
      child: widget.child,
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final Offset position;
  final Size size;
  final String message;
  final Widget? content;
  final VoidCallback onDismiss;

  const _TooltipOverlay({
    required this.position,
    required this.size,
    required this.message,
    this.content,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            child: Container(color: ThemeColors.of(context).transparent),
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy + size.height + 8,
          child: Material(
            color: ThemeColors.of(context).transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).grey900,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.of(context).overlay20,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: content ??
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: ThemeColors.of(context).surface,
                    ),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

enum TooltipTrigger { tap, longPress }






