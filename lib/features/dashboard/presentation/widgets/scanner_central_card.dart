import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/core/utils/responsive_helper.dart';

/// BLOCO 7: Centro de Scanner (Para Mobile)
/// Acesso rpido s funes de scanner que so o core do sistema
class ScannerCentralCard extends StatelessWidget {
  final VoidCallback? onAbrirScanner;
  final VoidCallback? onScanearTag;
  final VoidCallback? onScanearCodigoBarras;
  final VoidCallback? onScanearQRCode;

  const ScannerCentralCard({
    super.key,
    this.onAbrirScanner,
    this.onScanearTag,
    this.onScanearCodigoBarras,
    this.onScanearQRCode,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    // Remove card styling in mobile - just gradient background without card shape
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.of(context).greenMaterial,
            ThemeColors.of(context).greenDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Only apply border radius on desktop/tablet
        borderRadius: isMobile ? null : BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Ttulo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner_rounded,
                color: ThemeColors.of(context).surface,
                size: isMobile ? 24 : 28,
              ),
              const SizedBox(width: 10),
              Text(
                'SCANNER CENTRAL',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.of(context).surface,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 24),
          
          // Boto principal de scanner
          Material(
            color: ThemeColors.of(context).surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onAbrirScanner,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 20 : 24,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeColors.of(context).greenMaterial.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: ThemeColors.of(context).greenMaterial,
                        size: isMobile ? 40 : 48,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ABRIR SCANNER',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.of(context).greenMaterial,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          
          // Pergunta
          Text(
            'O que voc quer escanear?',
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: ThemeColors.of(context).surfaceOverlay90,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          
          // Opes de scanner
          Row(
            children: [
              Expanded(
                child: _buildScanOption(
                  context,
                  icon: Icons.sell_rounded,
                  label: 'Tag ESL',
                  onTap: onScanearTag,
                  isMobile: isMobile,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildScanOption(
                  context,
                  icon: Icons.qr_code_rounded,
                  label: 'Cdigo de Barras',
                  onTap: onScanearCodigoBarras,
                  isMobile: isMobile,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildScanOption(
                  context,
                  icon: Icons.qr_code_2_rounded,
                  label: 'QR Code',
                  onTap: onScanearQRCode,
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          
          // Dica
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).surfaceOverlay15,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: ThemeColors.of(context).amberLight,
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dica: Voc pode escanear diretamente e o sistema detecta automaticamente o tipo',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: ThemeColors.of(context).surfaceOverlay90,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isMobile,
  }) {
    return Material(
      color: ThemeColors.of(context).surfaceOverlay15,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 12 : 14,
            horizontal: isMobile ? 8 : 12,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: ThemeColors.of(context).surface,
                size: isMobile ? 24 : 28,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 11,
                  color: ThemeColors.of(context).surface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}





