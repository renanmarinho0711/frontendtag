mport 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Banner de dica que pode ser dispensado pelo usurio
/// Salva a preferncia localmente para no mostrar novamente
class TipBanner extends StatefulWidget {
  final String tipKey;
  final String title;
  final String message;
  final IconData icon;
  final Color? accentColor;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool showOnlyOnce;

  const TipBanner({
    super.key,
    required this.tipKey,
    required this.title,
    required this.message,
    this.icon = Icons.lightbulb_outline_rounded,
    this.accentColor,
    this.onAction,
    this.actionLabel,
    this.showOnlyOnce = true,
  });

  @override
  State<TipBanner> createState() => _TipBannerState();
}

class _TipBannerState extends State<TipBanner> with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _loadPreference();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPreference() async {
    if (widget.showOnlyOnce) {
      final prefs = await SharedPreferences.getInstance();
      final dismissed = prefs.getBool('tip_${widget.tipKey}') ?? false;
      setState(() {
        _isVisible = !dismissed;
        _isLoading = false;
      });
      if (_isVisible) {
        _controller.forward();
      }
    } else {
      setState(() => _isLoading = false);
      _controller.forward();
    }
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    if (widget.showOnlyOnce) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tip_${widget.tipKey}', true);
    }
    if (mounted) {
      setState(() => _isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || !_isVisible) return const SizedBox.shrink();

    final color = widget.accentColor ?? ThemeColors.of(context).tipCardText;

    return SizeTransition(
      sizeFactor: _animation,
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.alphaBlend(ThemeColors.of(context).surface.withOpacity(0.92), color),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.7), color)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.85), color),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.alphaBlend(ThemeColors.of(context).surfaceOverlay10, color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: ThemeColors.of(context).grey700,
                        height: 1.4,
                      ),
                    ),
                    if (widget.onAction != null && widget.actionLabel != null) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: widget.onAction,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          widget.actionLabel!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: _dismiss,
                icon: Icon(Icons.close_rounded, size: 18, color: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.4), color)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card de onboarding para novos usurios
class OnboardingCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback? onGetStarted;
  final VoidCallback? onSkip;

  const OnboardingCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.gradientColors = [ThemeColors.of(context).moduleDashboard, ThemeColors.of(context).moduleDashboardDark],
    this.onGetStarted,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color.alphaBlend(ThemeColors.of(context).surface.withValues(alpha: 0.7), gradientColors.first),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfacePastel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 40, color: ThemeColors.of(context).surface),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeColors.of(context).surface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Color.alphaBlend(ThemeColors.of(context).neutralBlack.withValues(alpha: 0.1), ThemeColors.of(context).surface),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (onSkip != null)
                Expanded(
                  child: TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'Pular',
                      style: TextStyle(
                        color: Color.alphaBlend(ThemeColors.of(context).neutralBlack.withValues(alpha: 0.2), ThemeColors.of(context).surface),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              if (onGetStarted != null)
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: onGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.of(context).surface,
                      foregroundColor: gradientColors.first,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Comear',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Indicador de primeiro uso com ponto pulsante
class FirstUseIndicator extends StatefulWidget {
  final Widget child;
  final String featureKey;
  final String? tooltipMessage;

  const FirstUseIndicator({
    super.key,
    required this.child,
    required this.featureKey,
    this.tooltipMessage,
  });

  @override
  State<FirstUseIndicator> createState() => _FirstUseIndicatorState();
}

class _FirstUseIndicatorState extends State<FirstUseIndicator>
    with SingleTickerProviderStateMixin {
  bool _showIndicator = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _checkFirstUse();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    final used = prefs.getBool('feature_${widget.featureKey}') ?? false;
    if (mounted) {
      setState(() => _showIndicator = !used);
    }
  }

  Future<void> _markAsUsed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feature_${widget.featureKey}', true);
    if (mounted) {
      setState(() => _showIndicator = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _markAsUsed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.tooltipMessage != null && _showIndicator
              ? Tooltip(
                  message: widget.tooltipMessage!,
                  child: widget.child,
                )
              : widget.child,
          if (_showIndicator)
            Positioned(
              top: -2,
              right: -2,
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.alphaBlend(ThemeColors.of(context).surfaceOverlay60, ThemeColors.of(context).primary),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}






