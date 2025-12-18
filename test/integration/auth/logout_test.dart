/// Testes E2E de Logout
/// TC024 - TC026: Cenários de logout
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🚪 Testes de Logout', () {
    
    Future<void> performLogin(WidgetTester tester) async {
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

    testWidgets('TC024 - Logout com sucesso', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Faz login primeiro
      await performLogin(tester);
      
      // Abre menu de perfil
      await tester.tap(find.byKey(const Key('profile_avatar')));
      await tester.pumpAndSettle();

      // Clica em Sair
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();

      // Confirma logout
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      // Verifica que voltou para login
      expect(find.text('Bem-vindo'), findsOneWidget);
    });

    testWidgets('TC025 - Cancelar logout', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      await performLogin(tester);
      
      await tester.tap(find.byKey(const Key('profile_avatar')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();

      // Cancela
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Verifica que continua no Dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('TC026 - SessÃ£o limpa após logout', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      await performLogin(tester);
      
      // Faz logout
      await tester.tap(find.byKey(const Key('profile_avatar')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      // Verifica que deve ir para login, não para dashboard
      expect(find.text('Bem-vindo'), findsOneWidget);
    });
  });
}
