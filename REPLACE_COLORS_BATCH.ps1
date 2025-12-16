# Script para migrar cores restantes em tag_edit_screen.dart
# 39 substituições de Color() para ThemeColors.of(context) tokens

$file = "d:\tagbean\frontend\lib\features\tags\presentation\screens\tag_edit_screen.dart"
$content = Get-Content $file -Raw

# Substituições mapeadas: Color(0xHEX) → ThemeColors.of(context).token
$replacements = @(
    # Line 407 - grey600
    @{ old = "                        overflow: TextOverflow.ellipsis,`n                        fontWeight: FontWeight.bold,`n                        color: Color(0xFF6B7280),`n                        letterSpacing: -0.5,`n                      ),"; new = "                        overflow: TextOverflow.ellipsis,`n                        fontWeight: FontWeight.bold,`n                        color: ThemeColors.of(context).grey600,`n                        letterSpacing: -0.5,`n                      )," }
    # Line 436 - grey600
    @{ old = "                             overflow: TextOverflow.ellipsis,`n                             fontWeight: FontWeight.w600,`n                             color: Color(0xFF6B7280),`n                           ),`n                         ),"; new = "                             overflow: TextOverflow.ellipsis,`n                             fontWeight: FontWeight.w600,`n                             color: ThemeColors.of(context).grey600,`n                           ),`n                         )," }
    # Line 498 - grey600 icon
    @{ old = "             child: Column(`n               mainAxisSize: MainAxisSize.min,`n               children: [`n                 Icon(`n                   icon,`n                   color: Color(0xFF6B7280),`n                   size: AppSizes.iconMediumSmall.get(isMobile, isTablet),`n                 ),"; new = "             child: Column(`n               mainAxisSize: MainAxisSize.min,`n               children: [`n                 Icon(`n                   icon,`n                   color: ThemeColors.of(context).grey600,`n                   size: AppSizes.iconMediumSmall.get(isMobile, isTablet),`n                 )," }
    # Line 515 - grey600
    @{ old = "                 overflow: TextOverflow.ellipsis,`n                 fontWeight: FontWeight.bold,`n                 color: Color(0xFF6B7280),`n               ),`n             ),`n             Text(`n               label,"; new = "                 overflow: TextOverflow.ellipsis,`n                 fontWeight: FontWeight.bold,`n                 color: ThemeColors.of(context).grey600,`n               ),`n             ),`n             Text(`n               label," }
    # Line 565 - grey600 inventory icon
    @{ old = "                   child: Icon(`n                     Icons.inventory_2_rounded,`n                     color: Color(0xFF6B7280),`n                     size: AppSizes.iconMediumSmall.get(isMobile, isTablet),`n                   ),"; new = "                   child: Icon(`n                     Icons.inventory_2_rounded,`n                     color: ThemeColors.of(context).grey600,`n                     size: AppSizes.iconMediumSmall.get(isMobile, isTablet),`n                   )," }
    # Line 620 - grey600 open_in_new icon
    @{ old = "                             children: [`n                               Icon(`n                                 Icons.open_in_new_rounded,`n                                 color: Color(0xFF6B7280),`n                                 size: AppSizes.iconMediumSmall`n                                     .get(isMobile, isTablet),`n                               ),"; new = "                             children: [`n                               Icon(`n                                 Icons.open_in_new_rounded,`n                                 color: ThemeColors.of(context).grey600,`n                                 size: AppSizes.iconMediumSmall`n                                     .get(isMobile, isTablet),`n                               )," }
    # Line 711 - grey600 foregroundColor
    @{ old = "                       backgroundColor: ThemeColors.of(context).orangeMain,`n                       foregroundColor: Color(0xFF6B7280),`n                       shape: RoundedRectangleBorder(`n                         borderRadius: BorderRadius.circular(`n                             AppSizes.paddingSm.get(isMobile, isTablet)),`n                       ),"; new = "                       backgroundColor: ThemeColors.of(context).orangeMain,`n                       foregroundColor: ThemeColors.of(context).grey600,`n                       shape: RoundedRectangleBorder(`n                         borderRadius: BorderRadius.circular(`n                             AppSizes.paddingSm.get(isMobile, isTablet)),`n                       )," }
    # Line 733 - grey600 container color
    @{ old = "         decoration: BoxDecoration(`n           color: Color(0xFF6B7280),`n           borderRadius: BorderRadius.circular(`n             isMobile ? 16 : (isTablet ? 18 : 20),`n           ),`n           boxShadow: ["; new = "         decoration: BoxDecoration(`n           color: ThemeColors.of(context).grey600,`n           borderRadius: BorderRadius.circular(`n             isMobile ? 16 : (isTablet ? 18 : 20),`n           ),`n           boxShadow: [" }
    # Line 761 - grey600 analytics icon
    @{ old = "                   child: Icon(`n                     Icons.analytics_rounded,`n                     color: Color(0xFF6B7280),`n                     size: AppSizes.iconSmall.get(isMobile, isTablet),`n                   ),"; new = "                   child: Icon(`n                     Icons.analytics_rounded,`n                     color: ThemeColors.of(context).grey600,`n                     size: AppSizes.iconSmall.get(isMobile, isTablet),`n                   )," }
    # Line 895 - grey600 container color (2nd)
    @{ old = "         decoration: BoxDecoration(`n           color: Color(0xFF6B7280),`n           borderRadius: BorderRadius.circular(`n             isMobile ? 16 : (isTablet ? 18 : 20),`n           ),`n           boxShadow: [`n             BoxShadow(`n               color: ThemeColors.of(context).textPrimaryOverlay05,"; new = "         decoration: BoxDecoration(`n           color: ThemeColors.of(context).grey600,`n           borderRadius: BorderRadius.circular(`n             isMobile ? 16 : (isTablet ? 18 : 20),`n           ),`n           boxShadow: [`n             BoxShadow(`n               color: ThemeColors.of(context).textPrimaryOverlay05," }
    # Line 919 - greenMaterial gradient
    @{ old = "                   decoration: BoxDecoration(`n                     gradient: LinearGradient(`n                       colors: [`n                         Color(0xFF10B981),`n                         ThemeColors.of(context).greenDark`n                       ],`n                     ),"; new = "                   decoration: BoxDecoration(`n                     gradient: LinearGradient(`n                       colors: [`n                         ThemeColors.of(context).greenMaterial,`n                         ThemeColors.of(context).greenDark`n                       ],`n                     )," }
    # Line 928 - grey600 edit icon
    @{ old = "                   child: Icon(`n                     Icons.edit_rounded,`n                     color: Color(0xFF6B7280),`n                     size: AppSizes.iconSmall.get(isMobile, isTablet),`n                   ),"; new = "                   child: Icon(`n                     Icons.edit_rounded,`n                     color: ThemeColors.of(context).grey600,`n                     size: AppSizes.iconSmall.get(isMobile, isTablet),`n                   )," }
    # Line 1125 - grey600 progress indicator
    @{ old = "                           child: CircularProgressIndicator(`n                             strokeWidth: 2,`n                             valueColor: AlwaysStoppedAnimation<Color>(`n                                 Color(0xFF6B7280)),`n                           ),"; new = "                           child: CircularProgressIndicator(`n                             strokeWidth: 2,`n                             valueColor: AlwaysStoppedAnimation<Color>(`n                                 ThemeColors.of(context).grey600),`n                           )," }
    # Line 1150 - grey600 foregroundColor blueMain
    @{ old = "                     backgroundColor: ThemeColors.of(context).blueMain,`n                     foregroundColor: Color(0xFF6B7280),`n                     shape: RoundedRectangleBorder(`n                       borderRadius: BorderRadius.circular(`n                           AppSizes.paddingBase.get(isMobile, isTablet)),`n                     ),"; new = "                     backgroundColor: ThemeColors.of(context).blueMain,`n                     foregroundColor: ThemeColors.of(context).grey600,`n                     shape: RoundedRectangleBorder(`n                       borderRadius: BorderRadius.circular(`n                           AppSizes.paddingBase.get(isMobile, isTablet)),`n                     )," }
)

# Aplicar substituições
foreach ($replacement in $replacements) {
    $content = $content.Replace($replacement.old, $replacement.new)
}

# Salvar arquivo
Set-Content $file -Value $content -Encoding UTF8

Write-Host "✅ Migração concluída!"
Write-Host "✏️  Aplicadas as substituições de Color() → ThemeColors.of(context)"
