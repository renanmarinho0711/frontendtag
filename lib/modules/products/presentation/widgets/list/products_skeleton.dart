import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

/// Skeleton card para estado de carregamento da lista de produtos
class ProductSkeletonCard extends StatelessWidget {
  const ProductSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 900;

    return Container(
      margin:
          EdgeInsets.only(bottom: AppSizes.paddingBase.get(isMobile, isTablet)),
      padding: EdgeInsets.all(AppSizes.paddingMd.get(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        children: [
          // ícone skeleton
          Container(
            width: AppSizes.iconHeroMd.get(isMobile, isTablet),
            height: AppSizes.iconHeroMd.get(isMobile, isTablet),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay20,
              borderRadius: AppRadius.lg,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título skeleton
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondaryOverlay20,
                    borderRadius: AppRadius.xxxs,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Categoria skeleton
                Container(
                  width: 150,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondaryOverlay20,
                    borderRadius: AppRadius.xxxs,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Tag skeleton
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).textSecondaryOverlay20,
                    borderRadius: AppRadius.xxxs,
                  ),
                ),
              ],
            ),
          ),
          // PREÇO skeleton
          Container(
            width: 60,
            height: 20,
            decoration: BoxDecoration(
              color: ThemeColors.of(context).textSecondaryOverlay20,
              borderRadius: AppRadius.xxxs,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de skeletons para estado de carregamento
class ProductSkeletonList extends StatelessWidget {
  final int count;

  const ProductSkeletonList({
    super.key,
    this.count = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (_) => const ProductSkeletonCard(),
      ),
    );
  }
}




