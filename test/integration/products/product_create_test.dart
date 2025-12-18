// Testes E2E de Criação de Produto
/// TC043 - TC055: Cenários de criação de produto
library;


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';
import '../../fixtures/products.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('➕ Testes de Criação de Produto', () {
    
    Future<void> loginAndNavigateToAddProduct(WidgetTester tester) async {
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

      // Navega para produtos
      await tester.tap(find.text('Produtos'));
      await tester.pumpAndSettle();
      
      // Clica em adicionar produto
      await tester.tap(find.byKey(const Key('add_product_button')));
      await tester.pumpAndSettle();
    }

    testWidgets('TC043 - Criar produto com todos os campos', (tester) async {
      await loginAndNavigateToAddProduct(tester);

      // Preenche todos os campos
      await tester.enterText(
        find.byKey(const Key('product_name_field')),
        TestProducts.validProduct['name'] as String,
      );

      await tester.enterText(
        find.byKey(const Key('product_code_field')),
        TestProducts.validProduct['code'] as String,
      );

      await tester.enterText(
        find.byKey(const Key('product_gtin_field')),
        TestProducts.validProduct['gtin'] as String,
      );

      await tester.enterText(
        find.byKey(const Key('product_price_field')),
        TestProducts.validProduct['price'].toString(),
      );

      await tester.enterText(
        find.byKey(const Key('product_cost_field')),
        TestProducts.validProduct['cost'].toString(),
      );

      await tester.enterText(
        find.byKey(const Key('product_stock_field')),
        TestProducts.validProduct['stock'].toString(),
      );

      // Seleciona categoria
      await tester.tap(find.byKey(const Key('product_category_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(TestProducts.validProduct['category'] as String).last);
      await tester.pumpAndSettle();

      // Preenche descrição
      await tester.enterText(
        find.byKey(const Key('product_description_field')),
        TestProducts.validProduct['description'] as String,
      );

      // Salva
      await tester.tap(find.byKey(const Key('save_product_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica sucesso
      expect(find.textContaining('sucesso'), findsOneWidget);
    });

    testWidgets('TC044 - Criar produto apenas com campos obrigatórios', (tester) async {
      await loginAndNavigateToAddProduct(tester);

      await tester.enterText(
        find.byKey(const Key('product_name_field')),
        TestProducts.minimalProduct['name'] as String,
      );

      await tester.enterText(
        find.byKey(const Key('product_price_field')),
        TestProducts.minimalProduct['price'].toString(),
      );

      await tester.tap(find.byKey(const Key('save_product_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.textContaining('sucesso'), findsOneWidget);
    });

    testWidgets('TC045 - Erro ao criar produto sem nome', (tester) async {
      await loginAndNavigateToAddProduct(tester);

      await tester.enterText(
        find.byKey(const Key('product_price_field')),
        '10.00',
      );

      await tester.tap(find.byKey(const Key('save_product_button')));
      await tester.pumpAndSettle();

      expect(find.text('O campo nome é obrigatório'), findsOneWidget);
    });

    testWidgets('TC046 - Erro ao criar produto sem preço', (tester) async {
      await loginAndNavigateToAddProduct(tester);

      await tester.enterText(
        find.byKey(const Key('product_name_field')),
        'Produto Sem Preço',
      );

      await tester.tap(find.byKey(const Key('save_product_button')));
      await tester.pumpAndSettle();

      expect(find.text('O campo preço é obrigatório'), findsOneWidget);
    });

    testWidgets('TC047 - Erro com preço negativo', (tester) async {
      await loginAndNavigateToAddProduct(tester);

      await tester.enterText(
        find.byKey(const Key('product_name_field')),
        'Produto Preço Negativo',
      );

      await tester.enterText(
        find.byKey(const Key('product_price_field')),
        '-10.00',
      );

      await tester.tap(find.byKey(const Key('save_product_button')));
      await tester.pumpAndSettle();

      expect(find.text('O valor não pode ser negativo'), findsOneWidget);
    });

    testWidgets('TC048 - Erro com GTIN inválido', (tester) async {
      await loginAndNavigateToAddProduct(tester);

      await tester.enterText(
        find.byKey(const Key('product_name_field')),
        'Produto GTIN Inválido',
      );

      await tester.enterText(
        find.byKey(const Key('product_price_field')),
        '10.00',
      );

      await tester.enterText(
        find.byKey(const Key('product_gtin_field')),
        '123', // GTIN muito curto
      );

      await tester.tap(find.byKey(const Key('save_product_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('GTIN'), findsOneWidget);
    });

    testWidgets('TC049 - Cancelar criação de produto', (tester) async {
      await loginAndNavigateToAddProduct(tester);

      await tester.enterText(
        find.byKey(const Key('product_name_field')),
        'Produto que será cancelado',
      );

      // Clica em cancelar
      await tester.tap(find.byKey(const Key('cancel_button')));
      await tester.pumpAndSettle();

      // Verifica que voltou para lista
      expect(find.text('Catálogo de Produtos'), findsOneWidget);
    });
  });
}
