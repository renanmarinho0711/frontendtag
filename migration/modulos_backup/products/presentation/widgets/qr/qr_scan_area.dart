import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

/// Widget de área de escaneamento QR/NFC
/// Área visual onde o usuário deve posicionar o código
/// 
/// Para usar scanner real de câmera, use [onOpenCamera] callback
/// que abrirá o BarcodeScannerWidget em tela cheia
class QrScanArea extends StatelessWidget {
  final bool isScanning;
  final bool hasCapture;
  final String? capturedValue;
  final String label;
  final Color primaryColor;
  final AnimationController? pulseController;
  final AnimationController? scanController;
  final VoidCallback? onTapToScan;
  final VoidCallback? onManualInput;
  
  /// Callback para abrir câmera real de escaneamento
  final VoidCallback? onOpenCamera;

  const QrScanArea({
    super.key,
    required this.isScanning,
    required this.label,
    required this.primaryColor,
    this.hasCapture = false,
    this.capturedValue,
    this.pulseController,
    this.scanController,
    this.onTapToScan,
    this.onManualInput,
    this.onOpenCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppThemeColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasCapture ? AppThemeColors.success : primaryColor.withValues(alpha: 0.3),
          width: hasCapture ? 2 : 1,
        ),
      ),
      child: hasCapture ? _buildCapturedState() : _buildScanState(context),
    );
  }

  Widget _buildScanState(BuildContext context) {
    if (isScanning) {
      return _buildScanningOverlay();
    }
    return _buildIdleState(context);
  }

  Widget _buildIdleState(BuildContext context) {
    return InkWell(
      onTap: onTapToScan,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone animado
          if (pulseController != null)
            AnimatedBuilder(
              animation: pulseController!,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.dashboardSectionGap),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1 + (pulseController!.value * 0.1)),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3 + (pulseController!.value * 0.3)),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 48,
                    color: primaryColor,
                  ),
                );
              },
            )
          else
            Container(
              padding: const EdgeInsets.all(AppSpacing.dashboardSectionGap),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                size: 48,
                color: primaryColor,
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Toque para escanear',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppThemeColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppThemeColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Botão para abrir câmera real
          if (onOpenCamera != null)
            ElevatedButton.icon(
              onPressed: onOpenCamera,
              icon: const Icon(Icons.camera_alt_rounded, size: 20),
              label: const Text('Abrir Câmera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: AppThemeColors.surface,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          
          const SizedBox(height: AppSpacing.sm),
          
          TextButton.icon(
            onPressed: onManualInput,
            icon: Icon(Icons.keyboard_rounded, size: 18, color: primaryColor),
            label: Text(
              'Digitar manualmente',
              style: TextStyle(color: primaryColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Grid de linhas de scan
        if (scanController != null)
          AnimatedBuilder(
            animation: scanController!,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(200, 200),
                painter: _ScanLinePainter(
                  progress: scanController!.value,
                  color: primaryColor,
                ),
              );
            },
          ),
        // Texto de status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppThemeColors.surface),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Escaneando...',
                style: TextStyle(
                  color: AppThemeColors.surface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCapturedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppThemeColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppThemeColors.success,
              size: 48,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            capturedValue ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Capturado com sucesso',
            style: TextStyle(
              fontSize: 13,
              color: AppThemeColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter para linhas de scan animadas
class _ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScanLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2;

    // Desenha linhas de scan
    final lineY = size.height * progress;
    canvas.drawLine(
      Offset(0, lineY),
      Offset(size.width, lineY),
      paint..color = color.withValues(alpha: 0.8),
    );

    // Cantos do frame
    final cornerPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const cornerSize = 30.0;

    // Top-left
    canvas.drawLine(Offset.zero, const Offset(cornerSize, 0), cornerPaint);
    canvas.drawLine(Offset.zero, const Offset(0, cornerSize), cornerPaint);

    // Top-right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerSize, 0), cornerPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerSize), cornerPaint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height), Offset(cornerSize, size.height), cornerPaint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerSize), cornerPaint);

    // Bottom-right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerSize, size.height), cornerPaint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerSize), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
