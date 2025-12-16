import 'package:flutter/material.dart';
import 'package:tagbean/features/dashboard/presentation/widgets/navigation/dashboard_navigation_rail.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';
import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';

/// Bottom Navigation bar mobile para o Dashboard
/// 
/// Extrado de dashboard_screen.dart para modularizao
class DashboardMobileBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final ScrollController scrollController;
  final AnimationController? fadeController;
  final VoidCallback? onScrollToSelected;

  const DashboardMobileBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.scrollController,
    this.fadeController,
    this.onScrollToSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.of(context).surface,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.of(context).neutralBlackLight,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              DashboardNavigationRail.getMenuItems(context).length,
              (index) => _buildNavItem(context, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final menuItems = DashboardNavigationRail.getMenuItems(context);
    final item = menuItems[index];
    final isSelected = selectedIndex == index;

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: () {
            if (selectedIndex != index) {
              onItemSelected(index);
              fadeController?.reset();
              fadeController?.forward();
              onScrollToSelected?.call();
              _autoScrollToItem(context, index);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(colors: List<Color>.from(item['gradient']))
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'],
                  color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).grey600,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item['title'],
                  style: TextStyle(
                    color: isSelected ? ThemeColors.of(context).surface : ThemeColors.of(context).grey600,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Auto-scroll para o item selecionado com navegao inteligente
  /// Quando clicar no ltimo visvel  direita/esquerda, avana 3 itens
  void _autoScrollToItem(BuildContext context, int index) {
    if (!scrollController.hasClients) return;

    final totalItems = DashboardNavigationRail.getMenuItems(context).length;
    const itemWidth = 90.0; // largura aproximada de cada item + padding
    const visibleItems = 4; // nmero aproximado de itens visveis

    // Verificar se clicou em um dos ltimos visveis  direita
    final currentOffset = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;
    final viewportWidth = scrollController.position.viewportDimension;
    
    // Calcular posio do item
    final itemOffset = index * itemWidth;
    
    // Se clicar em um item no totalmente visvel  direita, avanar 3 itens
    if (itemOffset > currentOffset + viewportWidth - itemWidth) {
      final targetIndex = (index + 3).clamp(0, totalItems - 1);
      final targetOffset = (targetIndex * itemWidth - viewportWidth + itemWidth * 2).clamp(0.0, maxScroll);
      
      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
    // Se clicar em um item no totalmente visvel  esquerda, retroceder 3 itens
    else if (itemOffset < currentOffset) {
      final targetIndex = (index - 3).clamp(0, totalItems - 1);
      final targetOffset = (targetIndex * itemWidth).clamp(0.0, maxScroll);
      
      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
    // Caso contrrio, centralizar o item selecionado
    else {
      final targetOffset = (itemOffset - viewportWidth / 2 + itemWidth / 2).clamp(0.0, maxScroll);
      
      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}





