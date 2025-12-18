// Testes E2E de Listagem de Tags
/// Cenários de listagem, busca e filtros de tags
library;


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';
import '../../fixtures/tags.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🏷️ Testes de Listagem de Tags', () {
    
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

    testWidgets('TC200 - Visualizar lista de tags', (tester) async {
      await loginAndNavigateToTags(tester);

      // Verifica que a lista carregou
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC201 - Buscar tag por MAC Address', (tester) async {
      await loginAndNavigateToTags(tester);

      await tester.enterText(
        find.byKey(const Key('search_field')),
        TestTags.validTag['macAddress'] as String,
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verifica resultado da busca
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC202 - Filtrar por status disponível', (tester) async {
      await loginAndNavigateToTags(tester);

      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text(TestTags.tagStatuses[1])); // 'Disponíveis'
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC203 - Filtrar por status vinculada', (tester) async {
      await loginAndNavigateToTags(tester);

      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text(TestTags.tagStatuses[2])); // 'Vinculadas'
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC204 - Filtrar por tipo de tag', (tester) async {
      await loginAndNavigateToTags(tester);

      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text(TestTags.tagTypes[0])); // 'gd29'
      await tester.pumpAndSettle();

      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('TC205 - Pull to refresh na lista de tags', (tester) async {
      await loginAndNavigateToTags(tester);

      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pump();

      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
