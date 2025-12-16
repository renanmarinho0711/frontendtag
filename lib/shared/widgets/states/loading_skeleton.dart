mport 'package:flutter/material.dart';
import 'package:tagbean/design_system/components/common/common_widgets.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Widget de loading skeleton para listas
/// 
/// Exibe placeholders animados enquanto os dados carregam.
/// Proporciona melhor UX do que um simples spinner.
/// 
/// Uso:
/// ```dart
/// if (isLoading)
///   LoadingSkeleton(itemCount: 5)
/// else
///   ListView.builder(...)
/// ```
class LoadingSkeleton extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;
  final Widget? customItem;

  const LoadingSkeleton({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.all(16),
    this.customItem,
  });

  /// Factory para skeleton de produtos
  factory LoadingSkeleton.products({int count = 5}) {
    return LoadingSkeleton(
      itemCount: count,
      itemHeight: 100,
      customItem: const _ProductSkeletonItem(),
    );
  }

  /// Factory para skeleton de tags
  factory LoadingSkeleton.tags({int count = 5}) {
    return LoadingSkeleton(
      itemCount: count,
      itemHeight: 72,
      customItem: const _TagSkeletonItem(),
    );
  }

  /// Factory para skeleton de cards
  factory LoadingSkeleton.cards({int count = 3}) {
    return LoadingSkeleton(
      itemCount: count,
      itemHeight: 120,
      customItem: const _CardSkeletonItem(),
    );
  }

  /// Factory para skeleton de lista simples
  factory LoadingSkeleton.simple({int count = 5}) {
    return LoadingSkeleton(
      itemCount: count,
      itemHeight: 56,
      customItem: const _SimpleSkeletonItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: customItem ?? _DefaultSkeletonItem(height: itemHeight),
      ),
    );
  }
}

/// Item skeleton padrão
class _DefaultSkeletonItem extends StatelessWidget {
  final double height;

  const _DefaultSkeletonItem({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).shadowVeryLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const ShimmerLoading(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

/// Skeleton item para produtos
class _ProductSkeletonItem extends StatelessWidget {
  const _ProductSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagem
          const ShimmerLoading(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(width: 12),
          // Conteúdo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ShimmerLoading(
                  width: 150,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(height: 8),
                ShimmerLoading(
                  width: 100,
                  height: 12,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(height: 8),
                ShimmerLoading(
                  width: 80,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          // Preço
          const ShimmerLoading(
            width: 60,
            height: 20,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}

/// Skeleton item para tags
class _TagSkeletonItem extends StatelessWidget {
  const _TagSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícone
          const ShimmerLoading(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          const SizedBox(width: 12),
          // Conteúdo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ShimmerLoading(
                  width: 120,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(height: 6),
                ShimmerLoading(
                  width: 80,
                  height: 10,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          // Status
          const ShimmerLoading(
            width: 60,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ],
      ),
    );
  }
}

/// Skeleton item para cards
class _CardSkeletonItem extends StatelessWidget {
  const _CardSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Header
          Row(
            children: [
              ShimmerLoading(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      width: 120,
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 6),
                    ShimmerLoading(
                      width: 80,
                      height: 12,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Conteúdo
          ShimmerLoading(
            width: double.infinity,
            height: 12,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          SizedBox(height: 8),
          ShimmerLoading(
            width: 200,
            height: 12,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}

/// Skeleton item simples (linha única)
class _SimpleSkeletonItem extends StatelessWidget {
  const _SimpleSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ThemeColors.of(context).borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: const [
          ShimmerLoading(
            width: 32,
            height: 32,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ShimmerLoading(
              width: double.infinity,
              height: 14,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          SizedBox(width: 12),
          ShimmerLoading(
            width: 24,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}

/// Skeleton para grid de cards
class GridSkeleton extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets padding;

  const GridSkeleton({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (_, index) => Container(
        decoration: BoxDecoration(
          color: ThemeColors.of(context).surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.of(context).neutralLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const ShimmerLoading(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}




