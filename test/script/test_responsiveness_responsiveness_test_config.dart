// Configuração central para testes de responsividade
library;

import 'package:flutter/material.dart';

/// Breakpoints de teste para simular diferentes dispositivos
class ResponsivenessBreakpoints {
  // Mobile pequeno (iPhone SE, Galaxy S8)
  static const Size mobileSmall = Size(320, 568);
  
  // Mobile médio (iPhone 12, Pixel 5)
  static const Size mobileMedium = Size(375, 812);
  
  // Mobile grande (iPhone 14 Pro Max, Galaxy S22 Ultra)
  static const Size mobileLarge = Size(428, 926);
  
  // Tablet pequeno (iPad Mini)
  static const Size tabletSmall = Size(744, 1133);
  
  // Tablet médio (iPad Air)
  static const Size tabletMedium = Size(820, 1180);
  
  // Tablet grande (iPad Pro 12.9)
  static const Size tabletLarge = Size(1024, 1366);
  
  // Desktop pequeno
  static const Size desktopSmall = Size(1280, 720);
  
  // Desktop médio
  static const Size desktopMedium = Size(1440, 900);
  
  // Desktop grande
  static const Size desktopLarge = Size(1920, 1080);
  
  // Desktop ultra-wide
  static const Size desktopUltraWide = Size(2560, 1080);
  
  // Tamanhos intermediários para detectar problemas de transição
  static const List<Size> transitionSizes = [
    Size(350, 700),   // Entre mobile small e medium
    Size(400, 850),   // Entre mobile medium e large
    Size(550, 900),   // Zona crítica mobile -> tablet
    Size(600, 1000),  // Breakpoint comum
    Size(700, 1100),  // Entre mobile e tablet
    Size(768, 1024),  // Breakpoint iPad clássico
    Size(850, 1200),  // Entre tablet small e medium
    Size(900, 1300),  // Breakpoint comum
    Size(1000, 1400), // Entre tablet e desktop
    Size(1100, 800),  // Desktop landscape pequeno
    Size(1200, 850),  // Breakpoint comum
    Size(1366, 768),  // Laptop comum
    Size(1600, 900),  // Desktop médio
  ];
  
  /// Todos os tamanhos para teste completo
  static List<Size> get allSizes => [
    mobileSmall,
    mobileMedium,
    mobileLarge,
    tabletSmall,
    tabletMedium,
    tabletLarge,
    desktopSmall,
    desktopMedium,
    desktopLarge,
    desktopUltraWide,
    ... transitionSizes,
  ].. sort((a, b) => a.width. compareTo(b. width));
  
  /// Simula arrastar a janela horizontalmente (muitos tamanhos intermediários)
  static List<Size> get dragSimulation {
    final sizes = <Size>[];
    for (int width = 280; width <= 2000; width += 20) {
      // Altura proporcional com algumas variações
      final height = (width * 1.6).clamp(500.0, 1200.0);
      sizes.add(Size(width.toDouble(), height));
    }
    return sizes;
  }
  
  /// Tamanhos críticos onde overflow geralmente ocorre
  static const List<Size> criticalSizes = [
    Size(280, 500),   // Muito pequeno
    Size(300, 600),
    Size(320, 568),   // iPhone SE
    Size(360, 640),   // Android comum
    Size(375, 667),   // iPhone 8
    Size(414, 896),   // iPhone XR/11
    Size(480, 800),   // Zona de transição
    Size(540, 960),
    Size(600, 1024),  // Breakpoint tablet
    Size(768, 1024),  // iPad
    Size(800, 600),   // Landscape problemático
    Size(1024, 768),  // iPad landscape
  ];
}

/// Tipos de erro de responsividade
enum ResponsivenessErrorType {
  overflow,           // RenderFlex overflow
  pixelOverflow,      // Pixel overflow específico
  textOverflow,       // Texto cortado
  constraintError,    // BoxConstraints error
  layoutError,        // Erro genérico de layout
  renderError,        // Erro de renderização
  assertionError,     // Assertion failed
  infiniteSize,       // Infinite size error
  negativeSize,       // Negative size
  unknown,
}

/// Modelo para armazenar erros encontrados
class ResponsivenessError {
  final String moduleName;
  final String screenName;
  final String widgetPath;
  final Size screenSize;
  final ResponsivenessErrorType errorType;
  final String errorMessage;
  final String?  stackTrace;
  final DateTime timestamp;
  final String?  suggestion;

  ResponsivenessError({
    required this. moduleName,
    required this.screenName,
    required this.widgetPath,
    required this. screenSize,
    required this.errorType,
    required this.errorMessage,
    this.stackTrace,
    DateTime? timestamp,
    this.suggestion,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'module': moduleName,
    'screen': screenName,
    'widgetPath': widgetPath,
    'screenWidth': screenSize.width,
    'screenHeight': screenSize. height,
    'errorType': errorType.name,
    'errorMessage': errorMessage,
    'stackTrace': stackTrace,
    'timestamp': timestamp.toIso8601String(),
    'suggestion':  suggestion,
  };

  @override
  String toString() {
    return '''
╔══════════════════════════════════════════════════════════════════════════════
║ RESPONSIVENESS ERROR DETECTED
╠══════════════════════════════════════════════════════════════════════════════
║ Module:      $moduleName
║ Screen:     $screenName
║ Widget:     $widgetPath
║ Size:       ${screenSize.width. toInt()}x${screenSize. height.toInt()}
║ Type:       ${errorType.name. toUpperCase()}
║ Message:    $errorMessage
${suggestion != null ? '║ Suggestion:  $suggestion' : ''}
╚══════════════════════════════════════════════════════════════════════════════
''';
  }
}

/// Configuração de módulos para teste
class ModuleTestConfig {
  final String name;
  final String path;
  final Widget Function() builder;
  final List<String> subScreens;
  final bool requiresAuth;
  final Map<String, dynamic>? initialData;

  const ModuleTestConfig({
    required this. name,
    required this.path,
    required this.builder,
    this.subScreens = const [],
    this.requiresAuth = false,
    this.initialData,
  });
}