// Testes E2E de Recuperação de Senha
/// TC014 - TC018: Cenários de recuperação de senha
library;


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🔑 Testes de Recuperação de Senha', () {
    
    testWidgets('TC014 - Solicitar recuperação com email válido', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navega para tela de recuperação
      await tester.tap(find.text('Esqueci a senha'));
      await tester.pumpAndSettle();

      // Preenche email
      await tester.enterText(
        find.byKey(const Key('recovery_email_field')),
        TestUsers.admin['email']!,
      );

      // Clica em enviar
      await tester.tap(find.byKey(const Key('send_recovery_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica mensagem de sucesso
      expect(
        find.textContaining('Email enviado'),
        findsOneWidget,
      );
    });

    testWidgets('TC015 - Solicitar recuperação com email inexistente', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Esqueci a senha'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recovery_email_field')),
        'naoexiste@email.com',
      );

      await tester.tap(find.byKey(const Key('send_recovery_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica mensagem de erro
      expect(
        find.text('Email não cadastrado'),
        findsOneWidget,
      );
    });

    testWidgets('TC016 - Solicitar recuperação com email inválido', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Esqueci a senha'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recovery_email_field')),
        'email_invalido',
      );

      await tester.tap(find.byKey(const Key('send_recovery_button')));
      await tester.pumpAndSettle();

      expect(
        find.text('Por favor, insira um email válido'),
        findsOneWidget,
      );
    });

    testWidgets('TC017 - Reenviar email de recuperação', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Esqueci a senha'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('recovery_email_field')),
        TestUsers.admin['email']!,
      );

      await tester.tap(find.byKey(const Key('send_recovery_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Clica em reenviar
      await tester.tap(find.text('Reenviar email'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        find.textContaining('reenviado'),
        findsOneWidget,
      );
    });

    testWidgets('TC018 - Voltar para login da tela de recuperação', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Esqueci a senha'));
      await tester.pumpAndSettle();

      // Clica em voltar
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verifica que voltou para login
      expect(find.text('Bem-vindo'), findsOneWidget);
    });
  });
}
