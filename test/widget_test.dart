// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/app/app.dart';

void main() {
  testWidgets('App smoke test - verifica se inicializa sem erros', (WidgetTester tester) async {
    // Renderiza o app com ProviderScope (necessário para Riverpod)
    await tester.pumpWidget(
      const ProviderScope(
        child: TagBeanApp(),
      ),
    );

    // Aguarda o carregamento inicial
    await tester.pump();

    // Verifica se algum widget foi renderizado (a tela de login ou similar)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
