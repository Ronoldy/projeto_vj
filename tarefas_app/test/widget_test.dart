import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tarefas_app/pages/home_page.dart';

void main() {
  testWidgets('Teste inicial da HomePage', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    // Verifica se o título da página está correto
    expect(find.text('Minhas Tarefas'), findsOneWidget);

    // Verifica se o botão de adicionar existe
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verifica se o botão de refresh existe
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    // Caso queira testar o estado inicial de carregamento
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // Adicione mais testes conforme necessário para:
  // - Adição de tarefas
  // - Edição de tarefas
  // - Exclusão de tarefas
  // - Marcar tarefas como concluídas
}