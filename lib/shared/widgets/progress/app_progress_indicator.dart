import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Indicador de progresso personalizado
class AppProgressIndicator extends StatelessWidget {
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final String? label;
  final ProgressIndicatorType type;
  final double size;

  const AppProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4,
    this.label,
    this.type = ProgressIndicatorType.circular,
    this.size = 48,
  });

  /// Factory para indicador circular
  factory AppProgressIndicator.circular({
    double? value,
    Color? color,
    double size = 48,
    double strokeWidth = 4,
    String? label,
  }) =>
      AppProgressIndicator(
        value: value,
        color: color,
        strokeWidth: strokeWidth,
        label: label,
        type: ProgressIndicatorType.circular,
        size: size,
      );

  /// Factory para indicador linear
  factory AppProgressIndicator.linear({
    double? value,
    Color? color,
    String? label,
  }) =>
      AppProgressIndicator(
        value: value,
        color: color,
        label: label,
        type: ProgressIndicatorType.linear,
      );

  /// Factory para indicador de porcentagem circular
  factory AppProgressIndicator.percentage({
    required double percentage,
    Color? color,
    double size = 80,
    double strokeWidth = 8,
  }) =>
      AppProgressIndicator(
        value: percentage / 100,
        color: color,
        type: ProgressIndicatorType.circularWithPercentage,
        size: size,
        strokeWidth: strokeWidth,
        label: '${percentage.toInt()}%',
      );

  /// Factory para indicador de steps
  factory AppProgressIndicator.steps({
    required int current,
    required int total,
    Color? color,
  }) =>
      AppProgressIndicator(
        value: current / total,
        color: color,
        type: ProgressIndicatorType.steps,
        label: '$current de $total',
      );

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    final effectiveColor = color ?? colors.primary;
    final effectiveBgColor =
        backgroundColor ?? colors.overlay20;

    switch (type) {
      case ProgressIndicatorType.circular:
        return _buildCircular(effectiveColor, effectiveBgColor);

      case ProgressIndicatorType.linear:
        return _buildLinear(effectiveColor, effectiveBgColor);

      case ProgressIndicatorType.circularWithPercentage:
        return _buildCircularWithPercentage(
            context, effectiveColor, effectiveBgColor);

      case ProgressIndicatorType.steps:
        return _buildSteps(context, effectiveColor, effectiveBgColor);
    }
  }

  Widget _buildCircular(Color color, Color bgColor) {
    Widget indicator;

    if (value != null) {
      indicator = CircularProgressIndicator(
        value: value,
        color: color,
        backgroundColor: bgColor,
        strokeWidth: strokeWidth,
      );
    } else {
      indicator = CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      );
    }

    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: indicator,
          ),
          const SizedBox(height: 8),
          Text(label!),
        ],
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: indicator,
    );
  }

  Widget _buildLinear(Color color, Color bgColor) {
    Widget indicator;

    if (value != null) {
      indicator = LinearProgressIndicator(
        value: value,
        color: color,
        backgroundColor: bgColor,
        minHeight: strokeWidth,
      );
    } else {
      indicator = LinearProgressIndicator(
        color: color,
        minHeight: strokeWidth,
      );
    }

    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label!),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(strokeWidth / 2),
            child: indicator,
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(strokeWidth / 2),
      child: indicator,
    );
  }

  Widget _buildCircularWithPercentage(
    BuildContext context,
    Color color,
    Color bgColor,
  ) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: value ?? 0,
            color: color,
            backgroundColor: bgColor,
            strokeWidth: strokeWidth,
          ),
          Center(
            child: Text(
              label ?? '${((value ?? 0) * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.2,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(
    BuildContext context,
    Color color,
    Color bgColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              label ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value ?? 0,
            color: color,
            backgroundColor: bgColor,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

enum ProgressIndicatorType {
  circular,
  linear,
  circularWithPercentage,
  steps,
}

/// Overlay de progresso para cobrir toda a tela
class ProgressOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? barrierColor;

  const ProgressOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.of(context);
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: barrierColor ?? colors.overlayDark,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppProgressIndicator.circular(),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(message!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Indicador de progresso inline pequeno
class MiniProgressIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const MiniProgressIndicator({
    super.key,
    this.color,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Indicador de progresso para upload/download
class FileProgressIndicator extends StatelessWidget {
  final double progress;
  final String fileName;
  final int? bytesTransferred;
  final int? totalBytes;
  final VoidCallback? onCancel;

  const FileProgressIndicator({
    super.key,
    required this.progress,
    required this.fileName,
    this.bytesTransferred,
    this.totalBytes,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.file_present, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onCancel != null)
                  IconButton(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (bytesTransferred != null && totalBytes != null) ...[
              const SizedBox(height: 4),
              Text(
                '${_formatBytes(bytesTransferred!)} / ${_formatBytes(totalBytes!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Color.alphaBlend(
                    ThemeColors.of(context).surface.withValues(alpha: 0.4), 
                    theme.colorScheme.onSurface
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}





