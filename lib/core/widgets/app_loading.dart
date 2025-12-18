import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

/// # Sistema de Loading do TagBean
/// 
/// Indicadores de carregamento padronizados.
/// 
/// ## Tipos:
/// - **Circular**: Indicador circular (padrão)
/// - **Linear**: Barra de progresso
/// - **Skeleton**: Placeholder para conteúdo
/// - **Overlay**: Loading em tela cheia

class AppLoading extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  
  const AppLoading({
    super.key,
    this.message,
    this.size = 24,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = color ?? theme.colorScheme.primary;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: size / 12,
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        ),
        if (message != null) ...[
          SizedBox(height: AppSpacing.gapVerticalMd),
          Text(
            message!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Loading linear
class AppLinearLoading extends StatelessWidget {
  final double? value;
  final Color? color;
  final double height;
  
  const AppLinearLoading({
    super.key,
    this.value,
    this.color,
    this.height = 4,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = color ?? theme.colorScheme.primary;
    
    return SizedBox(
      height: height,
      child: LinearProgressIndicator(
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        // ignore: deprecated_member_use
        backgroundColor: loadingColor.withOpacity(0.2),
      ),
    );
  }
}

/// Loading overlay para tela toda
class AppLoadingOverlay extends StatelessWidget {
  final String? message;
  final bool dismissible;
  
  const AppLoadingOverlay({
    super.key,
    this.message,
    this.dismissible = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: dismissible,
      child: Container(
        color: AppColors.scrim,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.paddingLg),
              child: AppLoading(
                message: message,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton loader para placeholder
class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });
  
  /// Skeleton circular
  const AppSkeleton.circle({
    super.key,
    double? size = 40,
  }) : width = size,
       height = size,
       borderRadius = null;
  
  /// Skeleton de texto
  const AppSkeleton.text({
    super.key,
    this.width,
    double? height = 16,
  }) : height = height,
       borderRadius = null;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey200,
        borderRadius: borderRadius ?? 
            (width == height ? BorderRadius.circular(width! / 2) : AppSpacing.borderRadiusSm),
      ),
    );
  }
}

/// Lista de skeletons
class AppSkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double spacing;
  
  const AppSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.spacing = 16,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return AppSkeleton(
          height: itemHeight,
          borderRadius: AppSpacing.borderRadiusMd,
        );
      },
    );
  }
}
