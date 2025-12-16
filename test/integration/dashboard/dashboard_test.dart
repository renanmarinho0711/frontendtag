// Testes E2E de Dashboard
/// Cenários de visualização e interação com o dashboard

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('📊 Testes de Dashboard', () {
    
    Future<void> loginAndGoToDashboard(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
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
    }

    testWidgets('TC100 - Visualizar dashboard principal', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Verifica elementos principais
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byKey(const Key('metrics_grid')), findsOneWidget);
    });

    testWidgets('TC101 - Verificar cards de métricas', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Verifica cards de métricas
      expect(find.text('Produtos'), findsWidgets);
      expect(find.text('Tags'), findsWidgets);
      expect(find.text('Sincronização'), findsWidgets);
    });

    testWidgets('TC102 - Navegar para Produtos', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Produtos no menu
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.text('Catálogo de Produtos'), findsOneWidget);
    });

    testWidgets('TC103 - Navegar para Tags', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Tags no menu
      await tester.tap(find.text('Tags'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.text('Gerenciar Tags'), findsWidgets);
    });

    testWidgets('TC104 - Navegar para Sincronização', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Sincronização no menu
      await tester.tap(find.text('Sincronização'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.textContaining('Sincronização'), findsWidgets);
    });

    testWidgets('TC105 - Navegar para Estratégias', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Estratégias no menu
      await tester.tap(find.text('Estratégias'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.textContaining('Estratégias'), findsWidgets);
    });

    testWidgets('TC106 - Navegar para Precificação', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Precificação no menu
      await tester.tap(find.text('Precificação'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.textContaining('Precificação'), findsWidgets);
    });

    testWidgets('TC107 - Navegar para Categorias', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Categorias no menu
      await tester.tap(find.text('Categorias'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.textContaining('Categorias'), findsWidgets);
    });

    testWidgets('TC108 - Navegar para Importação', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Importação no menu
      await tester.tap(find.text('Importação'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.textContaining('Importar'), findsWidgets);
    });

    testWidgets('TC109 - Navegar para Relatórios', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Relatórios no menu
      await tester.tap(find.text('Relatórios'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.textContaining('Relatórios'), findsWidgets);
    });

    testWidgets('TC110 - Navegar para Configurações', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Clica em Configurações no menu
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();
      
      // Verifica navegação
      expect(find.textContaining('Configurações'), findsWidgets);
    });

    testWidgets('TC111 - Pull to refresh no Dashboard', (tester) async {
      await loginAndGoToDashboard(tester);
      
      // Faz pull to refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pump();
      
      // Aguarda atualização
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Verifica que dashboard está visível
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
