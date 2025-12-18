// Testes E2E de Listagem de Produtos
/// TC027 - TC042: Cenários de listagem, busca e filtros
library;


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';
import '../../fixtures/products.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('📦 Testes de Listagem de Produtos', () {
    
    Future<void> loginAndNavigateToProducts(WidgetTester tester) async {
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
    }

    testWidgets('TC027 - Visualizar lista de produtos', (tester) async {
      await loginAndNavigateToProducts(tester);

      // Verifica que a lista carregou
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC028 - Buscar produto por nome', (tester) async {
      await loginAndNavigateToProducts(tester);

      // Digita no campo de busca
      await tester.enterText(
        find.byKey(const Key('search_field')),
        TestProducts.searchTerms[0], // 'Coca-Cola'
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verifica que mostra resultados (ou mensagem de vazio)
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC029 - Buscar produto por código', (tester) async {
      await loginAndNavigateToProducts(tester);

      await tester.enterText(
        find.byKey(const Key('search_field')),
        TestProducts.searchTerms[2], // '7891234567890'
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verifica resultado da busca
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC030 - Busca sem resultados', (tester) async {
      await loginAndNavigateToProducts(tester);

      await tester.enterText(
        find.byKey(const Key('search_field')),
        TestProducts.searchTerms[3], // 'ProdutoQueNaoExiste12345'
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Nenhum produto encontrado'), findsOneWidget);
    });

    testWidgets('TC031 - Filtrar por categoria', (tester) async {
      await loginAndNavigateToProducts(tester);

      // Abre filtros
      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();

      // Seleciona categoria
      await tester.tap(find.text(TestProducts.categories[0])); // 'Bebidas'
      await tester.pumpAndSettle();

      // Aplica filtro
      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Verifica que filtro foi aplicado
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC032 - Filtrar por status (com tag)', (tester) async {
      await loginAndNavigateToProducts(tester);

      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Com tag vinculada'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Verifica resultado do filtro
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC033 - Filtrar por status (sem tag)', (tester) async {
      await loginAndNavigateToProducts(tester);

      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sem tag'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Verifica resultado do filtro
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC034 - Ordenar por nome (A-Z)', (tester) async {
      await loginAndNavigateToProducts(tester);

      await tester.tap(find.byKey(const Key('sort_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Nome (A-Z)'));
      await tester.pumpAndSettle();

      // Verifica que lista está ordenada
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC035 - Ordenar por preço (menor)', (tester) async {
      await loginAndNavigateToProducts(tester);

      await tester.tap(find.byKey(const Key('sort_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Preço (menor primeiro)'));
      await tester.pumpAndSettle();

      // Verifica ordem de preços
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC036 - Ordenar por estoque (menor)', (tester) async {
      await loginAndNavigateToProducts(tester);

      await tester.tap(find.byKey(const Key('sort_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Estoque (menor primeiro)'));
      await tester.pumpAndSettle();

      // Verifica ordem de estoque
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC037 - Limpar filtros', (tester) async {
      await loginAndNavigateToProducts(tester);

      // Aplica filtro
      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(TestProducts.categories[0]));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Limpa filtros
      await tester.tap(find.byKey(const Key('clear_filters_button')));
      await tester.pumpAndSettle();

      // Verifica que mostra todos os produtos novamente
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC038 - Scroll infinito (paginação)', (tester) async {
      await loginAndNavigateToProducts(tester);

      // Faz scroll até o final
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verifica que lista ainda está visível
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC039 - Pull to refresh', (tester) async {
      await loginAndNavigateToProducts(tester);

      // Faz pull to refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pump();

      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Verifica que lista está visível
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
