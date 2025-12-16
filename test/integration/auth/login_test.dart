/// Testes E2E de Login
/// TC001 - TC013: Todos os cenários de login
/// 
/// Estrutura baseada no Plano Completo de Testes

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagbean/main.dart' as app;
import '../../fixtures/users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🔐 Testes de Login', () {
    
    // ═══════════════════════════════════════════════════════════
    // CENÁRIO 1: Login com sucesso
    // ═══════════════════════════════════════════════════════════
    
    testWidgets('TC001 - Login com credenciais válidas', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda tela de login carregar
      expect(find.text('Bem-vindo'), findsOneWidget);

      // Preenche email válido
      await tester.enterText(
        find.byKey(const Key('email_field')),
        TestUsers.admin['email']!,
      );

      // Preenche senha válida
      await tester.enterText(
        find.byKey(const Key('password_field')),
        TestUsers.admin['password']!,
      );

      // Clica no botão Entrar
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica se foi para o Dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });

    // ═══════════════════════════════════════════════════════════
    // CENÁRIO 2: Login com email inválido
    // ═══════════════════════════════════════════════════════════
    
    testWidgets('TC002 - Login com email inválido (formato)', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Preenche email com formato inválido
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'email_invalido',
      );

      // Preenche qualquer senha
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'qualquersenha',
      );

      // Clica no botão Entrar
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verifica mensagem de erro de validação
      expect(find.text('Por favor, insira um email válido'), findsOneWidget);
      
      // Verifica que continua na tela de login
      expect(find.text('Bem-vindo'), findsOneWidget);
    });

    testWidgets('TC003 - Login com email inexistente', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        TestUsers.invalidUser['email']!,
      );

      await tester.enterText(
        find.byKey(const Key('password_field')),
        TestUsers.admin['password']!,
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica mensagem de erro da API
      expect(find.text('Email ou senha inválidos'), findsOneWidget);
    });

    // ═══════════════════════════════════════════════════════════
    // CENÁRIO 3: Login com senha incorreta
    // ═══════════════════════════════════════════════════════════
    
    testWidgets('TC004 - Login com senha incorreta', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        TestUsers.admin['email']!,
      );

      await tester.enterText(
        find.byKey(const Key('password_field')),
        'SenhaErrada123',
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Email ou senha inválidos'), findsOneWidget);
    });

    testWidgets('TC005 - Login com senha vazia', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        TestUsers.admin['email']!,
      );

      // Deixa senha vazia
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('O campo senha é obrigatório'), findsOneWidget);
    });

    // ═══════════════════════════════════════════════════════════
    // CENÁRIO 4: Login com campos vazios
    // ═══════════════════════════════════════════════════════════
    
    testWidgets('TC006 - Login com todos os campos vazios', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Clica direto em entrar sem preencher nada
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verifica mensagens de campo obrigatório
      expect(find.text('O campo email é obrigatório'), findsOneWidget);
      expect(find.text('O campo senha é obrigatório'), findsOneWidget);
    });

    testWidgets('TC007 - Login apenas com email', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        TestUsers.admin['email']!,
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('O campo senha é obrigatório'), findsOneWidget);
    });

    testWidgets('TC008 - Login apenas com senha', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('password_field')),
        TestUsers.admin['password']!,
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('O campo email é obrigatório'), findsOneWidget);
    });

    // ═══════════════════════════════════════════════════════════
    // CENÁRIO 5: Funcionalidades da tela de login
    // ═══════════════════════════════════════════════════════════
    
    testWidgets('TC009 - Mostrar/Ocultar senha', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Preenche senha
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'MinhaSenha123',
      );

      // Verifica que senha está oculta (obscureText = true)
      final passwordField = tester.widget<TextField>(
        find.byKey(const Key('password_field')),
      );
      expect(passwordField.obscureText, true);

      // Clica no ícone de mostrar senha
      await tester.tap(find.byKey(const Key('toggle_password_visibility')));
      await tester.pumpAndSettle();

      // Verifica que senha está visível
      final passwordFieldVisible = tester.widget<TextField>(
        find.byKey(const Key('password_field')),
      );
      expect(passwordFieldVisible.obscureText, false);
    });

    testWidgets('TC010 - Checkbox Lembrar-me', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verifica que checkbox está desmarcado inicialmente
      final checkbox = tester.widget<Checkbox>(
        find.byKey(const Key('remember_me_checkbox')),
      );
      expect(checkbox.value, false);

      // Marca o checkbox
      await tester.tap(find.byKey(const Key('remember_me_checkbox')));
      await tester.pumpAndSettle();

      // Verifica que checkbox está marcado
      final checkboxMarked = tester.widget<Checkbox>(
        find.byKey(const Key('remember_me_checkbox')),
      );
      expect(checkboxMarked.value, true);
    });

    testWidgets('TC011 - Link Esqueci a senha', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Clica no link "Esqueci a senha"
      await tester.tap(find.text('Esqueci a senha'));
      await tester.pumpAndSettle();

      // Verifica que navegou para tela de recuperação
      expect(find.text('Recuperar Senha'), findsOneWidget);
    });

    // ═══════════════════════════════════════════════════════════
    // CENÁRIO 6: Estados de loading
    // ═══════════════════════════════════════════════════════════
    
    testWidgets('TC012 - Loading durante login', (tester) async {
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
      
      // Verifica que mostra loading (não usar pumpAndSettle aqui)
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Aguarda conclusÃ£o
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    // ═══════════════════════════════════════════════════════════
    // CENÁRIO 7: Múltiplas tentativas de login
    // ═══════════════════════════════════════════════════════════
    
    testWidgets('TC013 - Bloqueio após múltiplas tentativas', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tenta login 5 vezes com senha errada
      for (int i = 0; i < 5; i++) {
        await tester.enterText(
          find.byKey(const Key('email_field')),
          TestUsers.admin['email']!,
        );

        await tester.enterText(
          find.byKey(const Key('password_field')),
          'SenhaErrada$i',
        );

        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Na 6ª tentativa, deve mostrar mensagem de bloqueio
      expect(
        find.textContaining('Muitas tentativas'),
        findsOneWidget,
      );
    });
  });
}
