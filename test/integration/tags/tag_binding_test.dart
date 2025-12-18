// Testes E2E de Vinculação de Tags
/// Cenários de vinculação e desvinculação de tags a produtos
library;


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';
import '../../fixtures/products.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🔗 Testes de Vinculação de Tags', () {
    
    Future<void> loginAndNavigateToTags(WidgetTester tester) async {
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
    }

    testWidgets('TC210 - Vincular tag a produto', (tester) async {
      await loginAndNavigateToTags(tester);

      // Seleciona uma tag disponível
      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Disponíveis'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Clica na primeira tag
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Clica em vincular
      await tester.tap(find.text('Vincular a produto'));
      await tester.pumpAndSettle();

      // Seleciona um produto
      await tester.enterText(
        find.byKey(const Key('product_search_field')),
        TestProducts.searchTerms[0],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Confirma vinculação
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('vinculada'), findsOneWidget);
    });

    testWidgets('TC211 - Desvincular tag de produto', (tester) async {
      await loginAndNavigateToTags(tester);

      // Filtra por vinculadas
      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vinculadas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Clica na primeira tag vinculada
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Clica em desvincular
      await tester.tap(find.text('Desvincular'));
      await tester.pumpAndSettle();

      // Confirma desvinculação
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('desvinculada'), findsOneWidget);
    });

    testWidgets('TC212 - Cancelar vinculação de tag', (tester) async {
      await loginAndNavigateToTags(tester);

      // Filtra por disponíveis
      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Disponíveis'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      // Clica na primeira tag
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Clica em vincular
      await tester.tap(find.text('Vincular a produto'));
      await tester.pumpAndSettle();

      // Cancela
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Verifica que voltou para detalhes da tag
      expect(find.text('Detalhes da Tag'), findsOneWidget);
    });

    testWidgets('TC213 - Vinculação em lote', (tester) async {
      await loginAndNavigateToTags(tester);

      // Vai para vinculação em lote
      await tester.tap(find.text('Operações em Lote'));
      await tester.pumpAndSettle();

      // Verifica que tela de operações em lote está visível
      expect(find.textContaining('Lote'), findsWidgets);
    });
  });
}
