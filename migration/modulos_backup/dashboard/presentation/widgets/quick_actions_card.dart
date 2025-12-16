import 'package:flutter/material.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';
import 'package:tagbean/design_system/design_system.dart';

class QuickActionsCard extends StatelessWidget {
  final VoidCallback onAdicionarProduto;
  final VoidCallback onAdicionarTag;
  final VoidCallback onSincronizar;
  final VoidCallback onrelatÃ³rios;
  
  const QuickActionsCard({
    super.key,
    required this.onAdicionarProduto,
    required this.onAdicionarTag,
    required this.onSincronizar,
    required this.onrelatÃ³rios,
  });
  
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(
          isMobile ? 14 : (isTablet ? 15 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: isMobile ? 15 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          AppSizes.paddingMdLg.get(isMobile, isTablet),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  color: AppThemeColors.greenMaterial,
                  size: AppSizes.iconMedium.get(isMobile, isTablet),
                ),
                SizedBox(
                  width: AppSizes.paddingSmAlt.get(isMobile, isTablet),
                ),
                Expanded(
                  child: Text(
                    'Ações Rápidas',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 16,
                        mobileFontSize: 14,
                        tabletFontSize: 15,
                      ),
                      fontWeight: FontWeight.bold,
                      color: AppThemeColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.paddingMd.get(isMobile, isTablet),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHorizontalActionCard(
                  context,
                  icon: Icons.add_shopping_cart_rounded,
                  label: 'Adicionar Produto',
                  subtitle: 'Cadastrar novo item no estoque',
                  gradient: [AppThemeColors.blueMain, AppThemeColors.blueCyan],
                  onTap: onAdicionarProduto,
                ),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildHorizontalActionCard(
                  context,
                  icon: Icons.label_rounded,
                  label: 'Criar Tag',
                  subtitle: 'Gerar etiquetas para produtos',
                  gradient: [AppThemeColors.blueCyan, AppThemeColors.blueMaterial],
                  onTap: onAdicionarTag,
                ),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildHorizontalActionCard(
                  context,
                  icon: Icons.sync_rounded,
                  label: 'Sincronizar',
                  subtitle: 'Atualizar dados com sistema',
                  gradient: [AppThemeColors.tealMain, AppThemeColors.greenMaterial],
                  onTap: onSincronizar,
                ),
                SizedBox(height: AppSizes.paddingBase.get(isMobile, isTablet)),
                _buildHorizontalActionCard(
                  context,
                  icon: Icons.assessment_rounded,
                  label: 'Relatórios',
                  subtitle: 'Visualizar análises e métricas',
                  gradient: [AppThemeColors.orangeMain, AppThemeColors.yellowGold],
                  onTap: onrelatÃ³rios,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // NOTA: _buildActionButton removido (morto)

  Widget _buildHorizontalActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingSm.get(isMobile, isTablet)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.paddingSm.get(isMobile, isTablet)),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingXs.get(isMobile, isTablet)),
              decoration: BoxDecoration(
                color: AppThemeColors.surfaceOverlay20,
                borderRadius: BorderRadius.circular(AppSizes.paddingXs.get(isMobile, isTablet)),
              ),
              child: Icon(
                icon,
                color: AppThemeColors.surface,
                size: AppSizes.iconMedium.get(isMobile, isTablet),
              ),
            ),
            SizedBox(width: AppSizes.paddingSm.get(isMobile, isTablet)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 14,
                        mobileFontSize: 13,
                        tabletFontSize: 13,
                      ),
                      fontWeight: FontWeight.w600,
                      color: AppThemeColors.surface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        baseFontSize: 11,
                        mobileFontSize: 10,
                        tabletFontSize: 10,
                      ),
                      color: AppThemeColors.surface.withValues(alpha: 0.85),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppThemeColors.surfaceOverlay80,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

