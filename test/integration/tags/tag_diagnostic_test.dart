// Testes E2E de Diagnóstico de Tags
/// Cenários de diagnóstico e teste de tags

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';
import '../../fixtures/tags.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🔍 Testes de Diagnóstico de Tags', () {
    
    Future<void> loginAndNavigateToDiagnostic(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Login
      await tester.enterText(
        find.byKey(const Key('email_field')), 
        TestUsers.admin['email']!,
      );
      await tester.enterText(
        find.byKey(const Key('password_field')), 
        TestUsers.admin['password']!,
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navega para tags
      await tester.tap(find.text('Tags'));
      await tester.pumpAndSettle();

      // Vai para diagnóstico
      await tester.tap(find.text('Diagnóstico'));
      await tester.pumpAndSettle();
    }

    testWidgets('TC220 - Acessar tela de diagnóstico', (tester) async {
      await loginAndNavigateToDiagnostic(tester);

      expect(find.textContaining('Diagnóstico'), findsWidgets);
    });

    testWidgets('TC221 - Executar teste de bateria', (tester) async {
      await loginAndNavigateToDiagnostic(tester);

      // Clica em teste de bateria
      await tester.tap(find.text(TestTags.diagnosticTests[0])); // 'Bateria'
      await tester.pumpAndSettle();

      // Inicia teste
      await tester.tap(find.text('Iniciar Teste'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica resultado
      expect(find.textContaining('Bateria'), findsWidgets);
    });

    testWidgets('TC222 - Executar teste de conexão', (tester) async {
      await loginAndNavigateToDiagnostic(tester);

      // Clica em teste de conexão
      await tester.tap(find.text(TestTags.diagnosticTests[1])); // 'Conexão'
      await tester.pumpAndSettle();

      // Inicia teste
      await tester.tap(find.text('Iniciar Teste'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica resultado
      expect(find.textContaining('Conexão'), findsWidgets);
    });

    testWidgets('TC223 - Executar teste de atualização de preço', (tester) async {
      await loginAndNavigateToDiagnostic(tester);

      // Clica em teste de atualização
      await tester.tap(find.text(TestTags.diagnosticTests[2])); // 'Atualização de preço'
      await tester.pumpAndSettle();

      // Inicia teste
      await tester.tap(find.text('Iniciar Teste'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica resultado
      expect(find.textContaining('preço'), findsWidgets);
    });

    testWidgets('TC224 - Ver histórico de diagnósticos', (tester) async {
      await loginAndNavigateToDiagnostic(tester);

      // Clica em histórico
      await tester.tap(find.text('Histórico'));
      await tester.pumpAndSettle();

      // Verifica que mostra histórico
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC225 - Diagnóstico de tag específica', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Login
      await tester.enterText(
        find.byKey(const Key('email_field')), 
        TestUsers.admin['email']!,
      );
      await tester.enterText(
        find.byKey(const Key('password_field')), 
        TestUsers.admin['password']!,
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navega para tags
      await tester.tap(find.text('Tags'));
      await tester.pumpAndSettle();

      // Clica na primeira tag
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Clica em diagnosticar
      await tester.tap(find.text('Diagnosticar'));
      await tester.pumpAndSettle();

      // Verifica que mostra diagnóstico da tag
      expect(find.textContaining('Diagnóstico'), findsWidgets);
    });
  });
}
