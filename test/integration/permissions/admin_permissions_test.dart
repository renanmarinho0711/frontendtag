// Testes E2E de Permissões de Admin
/// Verifica que o administrador tem acesso a todas as funcionalidades

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('👑 Testes de Permissões Admin', () {
    
    Future<void> loginAsAdmin(WidgetTester tester) async {
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

    testWidgets('TC300 - Admin pode acessar Dashboard', (tester) async {
      await loginAsAdmin(tester);
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('TC301 - Admin pode acessar Produtos', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Produto'), findsWidgets);
    });

    testWidgets('TC302 - Admin pode acessar Tags', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Tags'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Tag'), findsWidgets);
    });

    testWidgets('TC303 - Admin pode acessar Sincronização', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Sincronização'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Sincronização'), findsWidgets);
    });

    testWidgets('TC304 - Admin pode acessar Estratégias', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Estratégias'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Estratégia'), findsWidgets);
    });

    testWidgets('TC305 - Admin pode acessar Precificação', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Precificação'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Precificação'), findsWidgets);
    });

    testWidgets('TC306 - Admin pode acessar Categorias', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Categorias'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Categoria'), findsWidgets);
    });

    testWidgets('TC307 - Admin pode acessar Importação', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Importação'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Import'), findsWidgets);
    });

    testWidgets('TC308 - Admin pode acessar Relatórios', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Relatórios'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Relatório'), findsWidgets);
    });

    testWidgets('TC309 - Admin pode acessar Configurações', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Configurações'), findsWidgets);
    });

    testWidgets('TC310 - Admin pode gerenciar usuários', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Usuários'));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Usuário'), findsWidgets);
    });

    testWidgets('TC311 - Admin pode criar produto', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      
      // Verifica que botão de adicionar está visível
      expect(find.byKey(const Key('add_product_button')), findsOneWidget);
    });

    testWidgets('TC312 - Admin pode deletar produto', (tester) async {
      await loginAsAdmin(tester);
      
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      
      // Clica em um produto
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      
      // Verifica que botão de excluir está visível
      expect(find.text('Excluir'), findsOneWidget);
    });
  });
}
