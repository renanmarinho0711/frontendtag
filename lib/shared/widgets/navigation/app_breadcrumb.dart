mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Widget de breadcrumb para navegao intuitiva
class AppBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final TextStyle? textStyle;
  final Color? separatorColor;

  const AppBreadcrumb({
    super.key,
    required this.items,
    this.textStyle,
    this.separatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: separatorColor ?? ThemeColors.of(context).grey400,
                ),
              ),
            _BreadcrumbItemWidget(
              item: items[i],
              isLast: i == items.length - 1,
              textStyle: textStyle,
            ),
          ],
        ],
      ),
    );
  }
}

class _BreadcrumbItemWidget extends StatelessWidget {
  final BreadcrumbItem item;
  final bool isLast;
  final TextStyle? textStyle;

  const _BreadcrumbItemWidget({
    required this.item,
    required this.isLast,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
          color: isLast ? ThemeColors.of(context).textPrimary : ThemeColors.of(context).textSecondary,
        );

    if (isLast || item.onTap == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon,
              size: 16,
              color: isLast ? ThemeColors.of(context).textPrimary : ThemeColors.of(context).textSecondary,
            ),
            const SizedBox(width: 4),
          ],
          Text(item.label, style: style),
        ],
      );
    }

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 16,
                color: ThemeColors.of(context).primary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              item.label,
              style: style.copyWith(color: ThemeColors.of(context).primary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Item do breadcrumb
class BreadcrumbItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.icon,
    this.onTap,
  });
}

/// Indicador de etapas para formulrios wizard
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? ThemeColors.of(context).primary;
    final inactive = inactiveColor ?? ThemeColors.of(context).grey300!;
    final completed = completedColor ?? ThemeColors.of(context).successIcon;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            for (int i = 0; i < totalSteps; i++) ...[
              if (i > 0)
                Expanded(
                  child: Container(
                    height: 2,
                    color: i <= currentStep ? completed : inactive,
                  ),
                ),
              _StepCircle(
                stepNumber: i + 1,
                isCompleted: i < currentStep,
                isActive: i == currentStep,
                activeColor: active,
                inactiveColor: inactive,
                completedColor: completed,
              ),
            ],
          ],
        ),
        if (stepLabels != null && stepLabels!.length == totalSteps) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < totalSteps; i++)
                Expanded(
                  child: Text(
                    stepLabels![i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: i == currentStep ? FontWeight.w600 : FontWeight.normal,
                      color: i <= currentStep 
                          ? ThemeColors.of(context).textPrimary 
                          : ThemeColors.of(context).textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final bool isCompleted;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;

  const _StepCircle({
    required this.stepNumber,
    required this.isCompleted,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.completedColor,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    Widget child;

    if (isCompleted) {
      backgroundColor = completedColor;
      foregroundColor = ThemeColors.of(context).surface;
      child = Icon(Icons.check_rounded, size: 16, color: ThemeColors.of(context).surface);
    } else if (isActive) {
      backgroundColor = activeColor;
      foregroundColor = ThemeColors.of(context).surface;
      child = Text(
        '$stepNumber',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: foregroundColor,
        ),
      );
    } else {
      backgroundColor = inactiveColor;
      foregroundColor = ThemeColors.of(context).grey600!;
      child = Text(
        '$stepNumber',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: foregroundColor,
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Color.alphaBlend(activeColor.withValues(alpha: 0.4), ThemeColors.of(context).surface),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(child: child),
    );
  }
}

/// Indicador de progresso linear com label
class LabeledProgress extends StatelessWidget {
  final double value;
  final String? label;
  final String? valueLabel;
  final Color? color;
  final double height;

  const LabeledProgress({
    super.key,
    required this.value,
    this.label,
    this.valueLabel,
    this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? ThemeColors.of(context).primary;
    final displayValue = (value * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || valueLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ThemeColors.of(context).textSecondary,
                    ),
                  ),
                Text(
                  valueLabel ?? '$displayValue%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) {
              return LinearProgressIndicator(
                value: animatedValue,
                minHeight: height,
                backgroundColor: ThemeColors.of(context).grey200,
                valueColor: AlwaysStoppedAnimation(progressColor),
              );
            },
          ),
        ),
      ],
    );
  }
}





