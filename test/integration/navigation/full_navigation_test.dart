// Testes E2E de Navegação Completa
/// Verifica toda a navegação do aplicativo
library;


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🧭 Testes de Navegação Completa', () {
    
    Future<void> login(WidgetTester tester) async {
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

    testWidgets('TC400 - Navegação completa por todos os módulos', (tester) async {
      await login(tester);
      
      // Dashboard
      expect(find.text('Dashboard'), findsOneWidget);
      
      // Produtos
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Produto'), findsWidgets);
      
      // Tags
      await tester.tap(find.text('Tags'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Tag'), findsWidgets);
      
      // Sincronização
      await tester.tap(find.text('Sincronização'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Sincronização'), findsWidgets);
      
      // Estratégias
      await tester.tap(find.text('Estratégias'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Estratégia'), findsWidgets);
      
      // Precificação
      await tester.tap(find.text('Precificação'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Precificação'), findsWidgets);
      
      // Categorias
      await tester.tap(find.text('Categorias'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Categoria'), findsWidgets);
      
      // Importação
      await tester.tap(find.text('Importação'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Import'), findsWidgets);
      
      // Relatórios
      await tester.tap(find.text('Relatórios'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Relatório'), findsWidgets);
      
      // Configurações
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Configurações'), findsWidgets);
      
      // Volta para Dashboard
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('TC401 - Navegação com botão voltar', (tester) async {
      await login(tester);
      
      // Vai para Produtos
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      
      // Clica em um produto para ver detalhes
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      
      // Volta
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Verifica que voltou para lista
      expect(find.textContaining('Produto'), findsWidgets);
    });

    testWidgets('TC402 - Menu lateral funciona corretamente', (tester) async {
      await login(tester);
      
      // Abre menu lateral (se existir)
      final menuButton = find.byIcon(Icons.menu);
      if (menuButton.evaluate().isNotEmpty) {
        await tester.tap(menuButton);
        await tester.pumpAndSettle();
        
        // Verifica itens do menu
        expect(find.text('Dashboard'), findsWidgets);
        expect(find.text('Produtos'), findsWidgets);
        expect(find.text('Tags'), findsWidgets);
      }
    });

    testWidgets('TC403 - Breadcrumb funciona corretamente', (tester) async {
      await login(tester);
      
      // Vai para Produtos
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      
      // Clica em um produto
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      
      // Clica no breadcrumb para voltar
      final breadcrumb = find.text('Produtos');
      if (breadcrumb.evaluate().isNotEmpty) {
        await tester.tap(breadcrumb);
        await tester.pumpAndSettle();
        
        expect(find.textContaining('Produto'), findsWidgets);
      }
    });

    testWidgets('TC404 - Navegação por tabs funciona', (tester) async {
      await login(tester);
      
      // Vai para Relatórios (tem tabs)
      await tester.tap(find.text('Relatórios'));
      await tester.pumpAndSettle();
      
      // Navega entre tabs se existirem
      final tabs = find.byType(Tab);
      if (tabs.evaluate().length > 1) {
        await tester.tap(tabs.at(1));
        await tester.pumpAndSettle();
        
        await tester.tap(tabs.at(0));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('TC405 - Quick actions funcionam', (tester) async {
      await login(tester);
      
      // Procura por ações rápidas no dashboard
      final quickAction = find.byKey(const Key('quick_action_add_product'));
      if (quickAction.evaluate().isNotEmpty) {
        await tester.tap(quickAction);
        await tester.pumpAndSettle();
        
        // Verifica que navegou para adicionar produto
        expect(find.textContaining('Novo Produto'), findsWidgets);
      }
    });
  });
}
