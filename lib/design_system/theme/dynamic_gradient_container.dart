mport 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/design_system/theme/dynamic_gradients.dart';

/// Widget helper para usar gradientes dinâmicos sem ConsumerWidget
class DynamicGradientContainer extends ConsumerWidget {
  final LinearGradient Function(WidgetRef ref) gradientBuilder;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final BorderRadiusGeometry? borderRadius;

  const DynamicGradientContainer({
    super.key,
    required this.gradientBuilder,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        gradient: gradientBuilder(ref),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// Builders específicos para cada gradiente
class GradientBuilders {
  static LinearGradient primaryHeader(WidgetRef ref) => DynamicGradients.primaryHeader(ref);
  static LinearGradient darkBackground(WidgetRef ref) => DynamicGradients.darkBackground(ref);
  static LinearGradient success(WidgetRef ref) => DynamicGradients.success(ref);
  static LinearGradient alert(WidgetRef ref) => DynamicGradients.alert(ref);
  static LinearGradient blueCyan(WidgetRef ref) => DynamicGradients.blueCyan(ref);
  static LinearGradient greenProduct(WidgetRef ref) => DynamicGradients.greenProduct(ref);
  static LinearGradient strategyDetail(WidgetRef ref) => DynamicGradients.strategyDetail(ref);
  static LinearGradient syncBlue(WidgetRef ref) => DynamicGradients.syncBlue(ref);
  static LinearGradient produtos(WidgetRef ref) => DynamicModuleGradients.produtos(ref);
  static LinearGradient precificacao(WidgetRef ref) => DynamicModuleGradients.precificacao(ref);
}


