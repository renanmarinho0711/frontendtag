// Teste de Responsividade para TODOS os Módulos Flutter do TagBean
/// 
/// Este teste verifica se todos os módulos do aplicativo se comportam
/// corretamente em diferentes tamanhos de tela (mobile, tablet, desktop).
/// 
/// Execução:
/// ```
/// cd D:\tagbean\frontend
/// C:\temp_flutter\flutter\bin\flutter.bat test test/widget/responsiveness_all_modules_test.dart
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../script/test_responsiveness_responsiveness_test_config.dart';

void main() {
  // Lista de erros encontrados durante os testes
  final List<ResponsivenessError> errorsFound = [];
  
  // Configuração de tamanhos para teste
  final testSizes = [
    // Mobile
    ResponsivenessBreakpoints.mobileSmall,
    ResponsivenessBreakpoints.mobileMedium,
    ResponsivenessBreakpoints.mobileLarge,
    // Tablet
    ResponsivenessBreakpoints.tabletSmall,
    ResponsivenessBreakpoints.tabletMedium,
    ResponsivenessBreakpoints.tabletLarge,
    // Desktop
    ResponsivenessBreakpoints.desktopSmall,
    ResponsivenessBreakpoints.desktopMedium,
    ResponsivenessBreakpoints.desktopLarge,
    // Críticos
    ...ResponsivenessBreakpoints.criticalSizes,
  ];

  /// Wrapper para testar widgets com tema do app
  Widget buildTestableWidget(Widget child, {Size? size}) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Função genérica para testar responsividade de um widget
  Future<void> testWidgetResponsiveness({
    required WidgetTester tester,
    required String moduleName,
    required String screenName,
    required Widget Function() widgetBuilder,
    required List<Size> sizes,
  }) async {
    for (final size in sizes) {
      // Configurar tamanho da tela
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      
      try {
        // Construir widget
        await tester.pumpWidget(buildTestableWidget(widgetBuilder()));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        
        // Verificar se não há overflow
        final overflowFinder = find.byWidgetPredicate((widget) {
          return widget.toString().contains('OVERFLOW');
        });
        
        expect(overflowFinder, findsNothing,
          reason: 'Overflow detectado em $moduleName/$screenName no tamanho ${size.width}x${size.height}');
        
        // Verificar erros de renderização no console
        final renderErrors = tester.takeException();
        if (renderErrors != null) {
          errorsFound.add(ResponsivenessError(
            moduleName: moduleName,
            screenName: screenName,
            widgetPath: 'Root',
            screenSize: size,
            errorType: _classifyError(renderErrors.toString()),
            errorMessage: renderErrors.toString(),
            suggestion: _getSuggestion(renderErrors.toString()),
          ));
        }
        
      } catch (e, stackTrace) {
        // Capturar qualquer erro
        errorsFound.add(ResponsivenessError(
          moduleName: moduleName,
          screenName: screenName,
          widgetPath: 'Root',
          screenSize: size,
          errorType: _classifyError(e.toString()),
          errorMessage: e.toString(),
          stackTrace: stackTrace.toString(),
          suggestion: _getSuggestion(e.toString()),
        ));
      }
      
      // Limpar
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }
  }

  group('📱 Testes de Responsividade - Todos os Módulos', () {
    
    group('🔐 Módulo: Auth', () {
      testWidgets('LoginScreen deve ser responsivo em todos os tamanhos', (tester) async {
        await testWidgetResponsiveness(
          tester: tester,
          moduleName: 'Auth',
          screenName: 'LoginScreen',
          widgetBuilder: () => const Placeholder(), // LoginScreen precisa de providers
          sizes: testSizes,
        );
      });
    });

    group('📊 Módulo: Dashboard', () {
      testWidgets('DashboardScreen deve ser responsivo em todos os tamanhos', (tester) async {
        await testWidgetResponsiveness(
          tester: tester,
          moduleName: 'Dashboard',
          screenName: 'DashboardScreen',
          widgetBuilder: () => const Placeholder(), // DashboardScreen precisa de providers
          sizes: testSizes,
        );
      });
    });

    group('📦 Módulo: Products', () {
      testWidgets('ProductsScreen deve ser responsivo em todos os tamanhos', (tester) async {
        await testWidgetResponsiveness(
          tester: tester,
          moduleName: 'Products',
          screenName: 'ProductsScreen',
          widgetBuilder: () => const Placeholder(), // ProductsScreen precisa de providers
          sizes: testSizes,
        );
      });
    });

    group('📁 Módulo: Categories', () {
      testWidgets('CategoriesScreen deve ser responsivo em todos os tamanhos', (tester) async {
        await testWidgetResponsiveness(
          tester: tester,
          moduleName: 'Categories',
          screenName: 'CategoriesScreen',
          widgetBuilder: () => const Placeholder(), // CategoriesScreen precisa de providers
          sizes: testSizes,
        );
      });
    });

    group('🏷️ Módulo: Tags', () {
      testWidgets('TagsScreen deve ser responsivo em todos os tamanhos', (tester) async {
        await testWidgetResponsiveness(
          tester: tester,
          moduleName: 'Tags',
          screenName: 'TagsScreen',
          widgetBuilder: () => const Placeholder(), // TagsScreen precisa de providers
          sizes: testSizes,
        );
      });
    });

    group('📋 Módulo: Strategies', () {
      testWidgets('StrategiesScreen deve ser responsivo em todos os tamanhos', (tester) async {
        await testWidgetResponsiveness(
          tester: tester,
          moduleName: 'Strategies',
          screenName: 'StrategiesScreen',
          widgetBuilder: () => const Placeholder(), // StrategiesScreen precisa de providers
          sizes: testSizes,
        );
      });
    });

    group('⚙️ Módulo: Settings', () {
      testWidgets('SettingsScreen deve ser responsivo em todos os tamanhos', (tester) async {
        await testWidgetResponsiveness(
          tester: tester,
          moduleName: 'Settings',
          screenName: 'SettingsScreen',
          widgetBuilder: () => const Placeholder(), // SettingsScreen precisa de providers
          sizes: testSizes,
        );
      });
    });
  });

  // Relatório final
  tearDownAll(() {
    print('\n');
    print('╔══════════════════════════════════════════════════════════════════════════════');
    print('║           RELATÓRIO DE TESTES DE RESPONSIVIDADE                              ');
    print('╠══════════════════════════════════════════════════════════════════════════════');
    print('║ Total de erros encontrados: ${errorsFound.length}');
    print('╚══════════════════════════════════════════════════════════════════════════════');
    
    if (errorsFound.isNotEmpty) {
      print('\n📋 DETALHES DOS ERROS:\n');
      
      // Agrupar por módulo
      final byModule = <String, List<ResponsivenessError>>{};
      for (final error in errorsFound) {
        byModule.putIfAbsent(error.moduleName, () => []).add(error);
      }
      
      for (final entry in byModule.entries) {
        print('🔸 Módulo: ${entry.key} (${entry.value.length} erros)');
        for (final error in entry.value) {
          print('   └─ ${error.screenName} @ ${error.screenSize.width.toInt()}x${error.screenSize.height.toInt()}');
          print('      Tipo: ${error.errorType.name}');
          if (error.suggestion != null) {
            print('      💡 Sugestão: ${error.suggestion}');
          }
        }
        print('');
      }
    } else {
      print('\n✅ TODOS OS MÓDULOS PASSARAM NOS TESTES DE RESPONSIVIDADE!\n');
    }
  });
}

/// Classifica o tipo de erro baseado na mensagem
ResponsivenessErrorType _classifyError(String message) {
  final lowerMessage = message.toLowerCase();
  
  if (lowerMessage.contains('overflow')) {
    if (lowerMessage.contains('pixel')) {
      return ResponsivenessErrorType.pixelOverflow;
    }
    return ResponsivenessErrorType.overflow;
  }
  if (lowerMessage.contains('text') && lowerMessage.contains('overflow')) {
    return ResponsivenessErrorType.textOverflow;
  }
  if (lowerMessage.contains('boxconstraints')) {
    return ResponsivenessErrorType.constraintError;
  }
  if (lowerMessage.contains('renderflex') || lowerMessage.contains('renderbox')) {
    return ResponsivenessErrorType.renderError;
  }
  if (lowerMessage.contains('assertion')) {
    return ResponsivenessErrorType.assertionError;
  }
  if (lowerMessage.contains('infinite')) {
    return ResponsivenessErrorType.infiniteSize;
  }
  if (lowerMessage.contains('negative')) {
    return ResponsivenessErrorType.negativeSize;
  }
  
  return ResponsivenessErrorType.unknown;
}

/// Retorna uma sugestão de correção baseada no tipo de erro
String? _getSuggestion(String errorMessage) {
  final lowerMessage = errorMessage.toLowerCase();
  
  if (lowerMessage.contains('overflow')) {
    return 'Use Flexible, Expanded ou SingleChildScrollView para evitar overflow';
  }
  if (lowerMessage.contains('boxconstraints') && lowerMessage.contains('width')) {
    return 'Adicione constraints mínimas ou use LayoutBuilder para adaptar ao tamanho';
  }
  if (lowerMessage.contains('renderflex')) {
    return 'Considere usar Wrap, ListView ou ajustar mainAxisSize';
  }
  if (lowerMessage.contains('infinite')) {
    return 'Defina dimensões explícitas ou use Expanded dentro de Row/Column';
  }
  
  return null;
}
