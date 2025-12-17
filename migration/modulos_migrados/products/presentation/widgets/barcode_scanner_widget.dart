import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tagbean/design_system/design_system.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';


/// Widget de Scanner de Código de Barras usando a câmera do dispositivo
/// 
/// Usa a biblioteca mobile_scanner para leitura de:
/// - Códigos de barras (EAN-8, EAN-13, UPC-A, UPC-E)
/// - QR Codes
/// - Data Matrix
/// - Code 128, Code 39, ITF, etc.
/// 
/// Uso:
/// ```dart
/// BarcodeScannerWidget(
///   onBarcodeDetected: (barcode) {
///     print('Código detectado: $barcode');
///     // Buscar produto, preencher campo, etc.
///   },
///   onClose: () => Navigator.pop(context),
/// )
/// ```
class BarcodeScannerWidget extends StatefulWidget {
  /// Callback chamado quando um código de barras é detectado
  final void Function(String barcode, BarcodeFormat format) onBarcodeDetected;
  
  /// Callback para fechar o scanner
  final VoidCallback? onClose;
  
  /// Título exibido no overlay
  final String title;
  
  /// Subtítulo/instrução exibida no overlay
  final String subtitle;
  
  /// Cor primária do overlay
  final Color? primaryColor;
  
  /// Se deve fechar automaticamente após detectar código
  final bool autoClose;
  
  /// Se deve vibrar ao detectar código
  final bool hapticFeedback;

  const BarcodeScannerWidget({
    super.key,
    required this.onBarcodeDetected,
    this.onClose,
    this.title = 'Escanear Código',
    this.subtitle = 'Posicione o código de barras dentro da área',
    this.primaryColor,
    this.autoClose = true,
    this.hapticFeedback = true,
  });

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget>
    with SingleTickerProviderStateMixin {
  
  late MobileScannerController _controller;
  late AnimationController _animationController;
  
  bool _isFlashOn = false;
  bool _hasDetected = false;
  String? _detectedCode;

  @override
  void initState() {
    super.initState();
    
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 500,
    );
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_hasDetected) return; // Evita múltiplas detecções
    
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;
    
    final code = barcode.rawValue!;
    final format = barcode.format;
    
    setState(() {
      _hasDetected = true;
      _detectedCode = code;
    });
    
    if (widget.hapticFeedback) {
      HapticFeedback.heavyImpact();
    }
    
    // Chama callback
    widget.onBarcodeDetected(code, format);
    
    // Fecha automaticamente se configurado
    if (widget.autoClose && widget.onClose != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onClose?.call();
      });
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller.toggleTorch();
    HapticFeedback.selectionClick();
  }

  void _switchCamera() {
    _controller.switchCamera();
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).neutralBlack,
      body: Stack(
        children: [
          // Câmera
          MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetected,
            errorBuilder: (context, error, child) {
              return _buildErrorWidget(context, error);
            },
          ),
          
          // Overlay com área de scan
          _buildScanOverlay(context),
          
          // Header com controles
          _buildHeader(),
          
          // Indicador de código detectado
          if (_hasDetected) _buildDetectedIndicator(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            // Botão fechar
            _buildControlButton(context, icon: Icons.close_rounded,
              onTap: widget.onClose,
              tooltip: 'Fechar',
            ),
            
            const Spacer(),
            
            // Botão flash
            _buildControlButton(context, icon: _isFlashOn 
                  ? Icons.flash_on_rounded 
                  : Icons.flash_off_rounded,
              onTap: _toggleFlash,
              tooltip: _isFlashOn ? 'Desligar flash' : 'Ligar flash',
              isActive: _isFlashOn,
            ),
            
            const SizedBox(width: AppSpacing.md),
            
            // Botão trocar câmera
            _buildControlButton(context, icon: Icons.cameraswitch_rounded,
              onTap: _switchCamera,
              tooltip: 'Trocar câmera',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
    required String tooltip,
    bool isActive = false,
  }) {
    return Material(
      color: isActive 
          ? widget.primaryColor 
          : ThemeColors.of(context).neutralBlack.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Icon(
            icon,
            color: ThemeColors.of(context).surface,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildScanOverlay(BuildContext context) {
    return CustomPaint(
      painter: ScanOverlayPainter(
        scanAreaSize: 280,
        borderColor: _hasDetected 
            ? ThemeColors.of(context).success 
            : widget.primaryColor,
        overlayColor: ThemeColors.of(context).neutralBlack.withValues(alpha: 0.6),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Área de scan com animação
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                children: [
                  // Cantos decorativos
                  _buildCorners(context),
                  
                  // Linha de scan animada
                  if (!_hasDetected)
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Positioned(
                          top: 20 + (_animationController.value * 240),
                          left: 20,
                          right: 20,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ThemeColors.of(context).transparent,
                                  widget.primaryColor,
                                  ThemeColors.of(context).transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Título
            Text(
              _hasDetected ? 'Código Detectado!' : widget.title,
              style: AppTextStyles.title.copyWith(
                color: ThemeColors.of(context).surface,
              ),
            ),
            
            const SizedBox(height: AppSpacing.sm),
            
            // Subtítulo
            Text(
              _hasDetected ? _detectedCode ?? '' : widget.subtitle,
              style: AppTextStyles.body.copyWith(
                color: ThemeColors.of(context).surfaceOverlay80,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorners(BuildContext context) {
    final color = _hasDetected 
        ? ThemeColors.of(context).success 
        : widget.primaryColor;
    
    return Stack(
      children: [
        // Top-left
        Positioned(
          top: 0,
          left: 0,
          child: _buildCorner(backgroundColor, topLeft: true),
        ),
        // Top-right
        Positioned(
          top: 0,
          right: 0,
          child: _buildCorner(backgroundColor, topRight: true),
        ),
        // Bottom-left
        Positioned(
          bottom: 0,
          left: 0,
          child: _buildCorner(backgroundColor, bottomLeft: true),
        ),
        // Bottom-right
        Positioned(
          bottom: 0,
          right: 0,
          child: _buildCorner(backgroundColor, bottomRight: true),
        ),
      ],
    );
  }

  Widget _buildCorner(
    Color color, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return CustomPaint(
      size: const Size(40, 40),
      painter: CornerPainter(
        color: color,
        strokeWidth: 4,
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      ),
    );
  }

  Widget _buildDetectedIndicator(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 150),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).success,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          // boxShadow removido pois AppShadows não é const
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: ThemeColors.of(context).surface,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Código lido com sucesso!',
              style: AppTextStyles.buttonPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, MobileScannerException error) {
    String message;
    IconData icon;
    
    switch (error.errorCode) {
      case MobileScannerErrorCode.permissionDenied:
        message = 'Permissão de câmera negada.\nAcesse as configurações para permitir.';
        icon = Icons.no_photography_rounded;
        break;
      case MobileScannerErrorCode.controllerAlreadyInitialized:
      case MobileScannerErrorCode.controllerDisposed:
      case MobileScannerErrorCode.controllerUninitialized:
        message = 'Erro ao inicializar câmera.\nTente novamente.';
        icon = Icons.error_outline_rounded;
        break;
      default:
        message = 'Erro ao acessar câmera:\n${error.errorDetails?.message ?? "Desconhecido"}';
        icon = Icons.error_outline_rounded;
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: ThemeColors.of(context).error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: ThemeColors.of(context).surface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: widget.onClose,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Voltar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: ThemeColors.of(context).surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter para o overlay com área de scan recortada
class ScanOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Color borderColor;
  final Color overlayColor;

  ScanOverlayPainter({
    required this.scanAreaSize,
    required this.borderColor,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scanRect = Rect.fromCenter(
      center: center,
      width: scanAreaSize,
      height: scanAreaSize,
    );
    
    // Desenha overlay escuro com buraco
    final overlayPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    
    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(ScanOverlayPainter oldDelegate) {
    return oldDelegate.scanAreaSize != scanAreaSize ||
           oldDelegate.borderColor != borderColor ||
           oldDelegate.overlayColor != overlayColor;
  }
}

/// Painter para os cantos decorativos
class CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  CornerPainter({
    required this.color,
    required this.strokeWidth,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    if (topLeft) {
      path.moveTo(0, size.height * 0.5);
      path.lineTo(0, strokeWidth / 2);
      path.arcToPoint(
        Offset(strokeWidth / 2, 0),
        radius: Radius.circular(strokeWidth / 2),
      );
      path.lineTo(size.width * 0.5, 0);
    } else if (topRight) {
      path.moveTo(size.width * 0.5, 0);
      path.lineTo(size.width - strokeWidth / 2, 0);
      path.arcToPoint(
        Offset(size.width, strokeWidth / 2),
        radius: Radius.circular(strokeWidth / 2),
      );
      path.lineTo(size.width, size.height * 0.5);
    } else if (bottomLeft) {
      path.moveTo(0, size.height * 0.5);
      path.lineTo(0, size.height - strokeWidth / 2);
      path.arcToPoint(
        Offset(strokeWidth / 2, size.height),
        radius: Radius.circular(strokeWidth / 2),
      );
      path.lineTo(size.width * 0.5, size.height);
    } else if (bottomRight) {
      path.moveTo(size.width * 0.5, size.height);
      path.lineTo(size.width - strokeWidth / 2, size.height);
      path.arcToPoint(
        Offset(size.width, size.height - strokeWidth / 2),
        radius: Radius.circular(strokeWidth / 2),
      );
      path.lineTo(size.width, size.height * 0.5);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) {
    return oldDelegate.color != color ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Dialog helper para abrir scanner facilmente
class BarcodeScannerDialog {
  /// Abre o scanner em tela cheia e retorna o código detectado
  static Future<String?> show(
    BuildContext context, {
    String title = 'Escanear Código',
    String subtitle = 'Posicione o código de barras dentro da área',
    Color? primaryColor,
  }) async {
    String? result;
    
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BarcodeScannerWidget(
          title: title,
          subtitle: subtitle,
          primaryColor: primaryColor ?? ThemeColors.of(context).brandPrimaryGreen,
          onBarcodeDetected: (barcode, format) {
            result = barcode;
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
    
    return result;
  }
}


