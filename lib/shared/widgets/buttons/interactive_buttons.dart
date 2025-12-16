mport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Boto de ao flutuante expansvel com menu de opes
class ExpandableFab extends StatefulWidget {
  final List<FabAction> actions;
  final IconData icon;
  final IconData closeIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double distance;
  final Duration animationDuration;

  const ExpandableFab({
    super.key,
    required this.actions,
    this.icon = Icons.add,
    this.closeIcon = Icons.close,
    this.backgroundColor,
    this.foregroundColor,
    this.distance = 112,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _close() {
    if (_isOpen) {
      setState(() => _isOpen = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? ThemeColors.of(context).primary;
    final fgColor = widget.foregroundColor ?? ThemeColors.of(context).surface;

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          // Backdrop quando aberto
          if (_isOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                child: AnimatedBuilder(
                  animation: _expandAnimation,
                  builder: (context, child) {
                    return Container(
                      color: Color.alphaBlend(
                        ThemeColors.of(context).neutralBlack.withOpacity(_expandAnimation.value * 0.3),
                        ThemeColors.of(context).transparent,
                      ),
                    );
                  },
                ),
              ),
            ),
          // Action buttons
          ..._buildExpandingActions(fgColor),
          // Main FAB
          _buildMainFab(bgColor, fgColor),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActions(Color fgColor) {
    final widgets = <Widget>[];
    final count = widget.actions.length;
    final step = 90.0 / (count > 1 ? count - 1 : 1);

    for (var i = 0; i < count; i++) {
      final action = widget.actions[i];
      final angle = 180 + (i * step);
      final angleRad = angle * (3.14159 / 180);

      widgets.add(
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            final offset = Offset(
              widget.distance * _expandAnimation.value * -1 * 
                  (i == 0 ? 0 : (i / (count - 1))),
              widget.distance * _expandAnimation.value * -1 * 
                  (1 - (i / count)),
            );
            return Positioned(
              right: 4,
              bottom: 72 + (i * 56),
              child: Transform.scale(
                scale: _expandAnimation.value,
                child: Opacity(
                  opacity: _expandAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: _FabActionButton(
            action: action,
            onPressed: () {
              _close();
              action.onPressed();
            },
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildMainFab(Color bgColor, Color fgColor) {
    return FloatingActionButton(
      heroTag: 'expandable_fab',
      onPressed: _toggle,
      backgroundColor: bgColor,
      elevation: 4,
      child: AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _expandAnimation.value * 0.785, // 45 degrees
            child: Icon(
              _isOpen ? widget.closeIcon : widget.icon,
              color: fgColor,
            ),
          );
        },
      ),
    );
  }
}

class _FabActionButton extends StatelessWidget {
  final FabAction action;
  final VoidCallback onPressed;

  const _FabActionButton({
    required this.action,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (action.label != null)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.of(context).neutralPastel,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              action.label!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        FloatingActionButton.small(
          heroTag: 'fab_action_${action.label ?? action.icon.hashCode}',
          onPressed: onPressed,
          backgroundColor: action.color ?? ThemeColors.of(context).primary,
          child: Icon(action.icon, size: 20, color: ThemeColors.of(context).surface),
        ),
      ],
    );
  }
}

/// Ao do FAB expansvel
class FabAction {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? color;

  const FabAction({
    required this.icon,
    this.label,
    required this.onPressed,
    this.color,
  });
}

/// Boto com estado de loading integrado
class LoadingButton extends StatefulWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExpanded;
  final LoadingButtonStyle style;

  const LoadingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isExpanded = true,
    this.style = LoadingButtonStyle.elevated,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading || widget.onPressed == null) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? ThemeColors.of(context).primary;
    final fgColor = widget.foregroundColor ?? ThemeColors.of(context).surface;

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(fgColor),
            ),
          )
        else if (widget.icon != null)
          Icon(widget.icon, size: 20),
        if (!_isLoading && widget.icon != null)
          const SizedBox(width: 8),
        if (!_isLoading)
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (_isLoading)
          const SizedBox(width: 8),
        if (_isLoading)
          Text(
            'Aguarde...',
            style: TextStyle(
              fontSize: 14,
              color: Color.alphaBlend(ThemeColors.of(context).surfaceOverlay20, fgColor),
            ),
          ),
      ],
    );

    if (widget.isExpanded) {
      buttonContent = SizedBox(
        width: double.infinity,
        child: buttonContent,
      );
    }

    switch (widget.style) {
      case LoadingButtonStyle.elevated:
        return ElevatedButton(
          onPressed: _isLoading ? null : _handlePress,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.4), bgColor),
            disabledForegroundColor: Color.alphaBlend(ThemeColors.of(context).surfaceOverlay20, fgColor),
          ),
          child: buttonContent,
        );
      case LoadingButtonStyle.outlined:
        return OutlinedButton(
          onPressed: _isLoading ? null : _handlePress,
          style: OutlinedButton.styleFrom(
            foregroundColor: bgColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: bgColor, width: 1.5),
          ),
          child: buttonContent,
        );
      case LoadingButtonStyle.text:
        return TextButton(
          onPressed: _isLoading ? null : _handlePress,
          style: TextButton.styleFrom(
            foregroundColor: bgColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: buttonContent,
        );
    }
  }
}

enum LoadingButtonStyle { elevated, outlined, text }

/// Grupo de botes de segmentos (tab-like)
class SegmentedButtons<T> extends StatelessWidget {
  final List<SegmentItem<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final Color? selectedColor;
  final bool isExpanded;

  const SegmentedButtons({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.selectedColor,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? ThemeColors.of(context).primary;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        children: segments.map((segment) {
          final isSelected = segment.value == selected;
          return Expanded(
            flex: isExpanded ? 1 : 0,
            child: GestureDetector(
              onTap: () {
                if (!isSelected) {
                  HapticFeedback.selectionClick();
                  onChanged(segment.value);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color : ThemeColors.of(context).transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.7), color),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (segment.icon != null) ...[
                      Icon(
                        segment.icon,
                        size: 18,
                        color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).grey600,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      segment.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SegmentItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SegmentItem({
    required this.value,
    required this.label,
    this.icon,
  });
}






