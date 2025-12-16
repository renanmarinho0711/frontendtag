/// Script de Análise de Responsividade - TagBean Flutter
/// 
/// Este script analisa todos os arquivos de tela (screens) do projeto
/// para identificar potenciais problemas de responsividade.
///
/// Execução:
/// ```powershell
/// cd D:\tagbean\frontend
/// dart run test/script/analyze_responsiveness.dart
/// ```

import 'dart:io';

void main() async {
  print('''
╔══════════════════════════════════════════════════════════════════════════════
║           🔍 ANÁLISE DE RESPONSIVIDADE - TAGBEAN FLUTTER                      
║           Analisando todos os módulos Dart para problemas de responsividade   
╚══════════════════════════════════════════════════════════════════════════════
''');

  final projectPath = Directory.current.path;
  final libPath = '$projectPath/lib';
  
  if (!Directory(libPath).existsSync()) {
    print('❌ Erro: Diretório lib não encontrado em $projectPath');
    print('   Execute este script a partir de D:\\tagbean\\frontend');
    exit(1);
  }

  // Configurações de análise
  final analysisResults = <String, ModuleAnalysis>{};
  
  // Padrões problemáticos para responsividade
  // NOTA: Usamos filtros de valor para evitar falsos positivos
  final problematicPatterns = {
    // Larguras fixas grandes (>= 200px sÃ£o problemáticas)
    'hardcoded_width': RegExp(r'width:\s*(\d+\.?\d*)\s*[,\)]', caseSensitive: false),
    // Alturas fixas grandes (>= 200px sÃ£o problemáticas)
    'hardcoded_height': RegExp(r'height:\s*(\d+\.?\d*)\s*[,\)]', caseSensitive: false),
    // Size com valores grandes
    'hardcoded_size': RegExp(r'Size\(\s*(\d+\.?\d*)\s*,\s*(\d+\.?\d*)\s*\)', caseSensitive: false),
    // Padding muito grande (>= 50px)
    'hardcoded_padding_large': RegExp(r'EdgeInsets\.all\(\s*(\d+\.?\d*)\s*\)', caseSensitive: false),
    // Positioned com valores fixos grandes (>= 100px)
    'hardcoded_positioned': RegExp(r'Positioned\(\s*(?:left|right|top|bottom):\s*(\d+\.?\d*)', caseSensitive: false),
    // fontSize muito grande (>= 32px pode ser problema em mobile pequeno)
    'hardcoded_fontsize': RegExp(r'fontSize:\s*(\d+\.?\d*)', caseSensitive: false),
    // BoxConstraints com valores fixos grandes
    'hardcoded_constraints': RegExp(r'BoxConstraints\(\s*(?:minWidth|maxWidth|minHeight|maxHeight):\s*(\d+\.?\d*)', caseSensitive: false),
    // UnconstrainedBox pode causar overflow
    'unconstrained_box': RegExp(r'UnconstrainedBox\(', caseSensitive: false),
    // OverflowBox pode esconder problemas
    'overflow_box': RegExp(r'OverflowBox\(', caseSensitive: false),
    // Flexible(flex: 0) - anti-pattern que não permite encolher
    'flexible_flex_zero': RegExp(r'Flexible\(\s*flex:\s*0', caseSensitive: false),
    // SizedBox com width fixo grande dentro de Row (potencial overflow)
    'sizedbox_width_in_row': RegExp(r'SizedBox\(\s*width:\s*(\d+\.?\d*)', caseSensitive: false),
  };
  
  // Limites para considerar como problema
  final valueLimits = {
    'hardcoded_width': 250.0,        // >= 250px é problema
    'hardcoded_height': 250.0,       // >= 250px é problema
    'hardcoded_size': 200.0,         // >= 200px é problema
    'hardcoded_padding_large': 60.0, // >= 60px é problema
    'hardcoded_positioned': 150.0,   // >= 150px é problema
    'hardcoded_fontsize': 32.0,      // >= 32px é problema
    'hardcoded_constraints': 300.0,  // >= 300px é problema
    'sizedbox_width_in_row': 100.0,  // >= 100px pode causar overflow em telas pequenas
  };

  // Padrões bons para responsividade
  final goodPatterns = {
    'mediaQuery': RegExp(r'MediaQuery\.of\(context\)', caseSensitive: false),
    'layoutBuilder': RegExp(r'LayoutBuilder\(', caseSensitive: false),
    'responsive_framework': RegExp(r'ResponsiveBreakpoints|ResponsiveWrapper', caseSensitive: false),
    'flexible': RegExp(r'Flexible\(', caseSensitive: false),
    'expanded': RegExp(r'Expanded\(', caseSensitive: false),
    'fittedBox': RegExp(r'FittedBox\(', caseSensitive: false),
    'aspectRatio': RegExp(r'AspectRatio\(', caseSensitive: false),
    'fractionallySizedBox': RegExp(r'FractionallySizedBox\(', caseSensitive: false),
    'intrinsicWidth': RegExp(r'IntrinsicWidth\(', caseSensitive: false),
    'intrinsicHeight': RegExp(r'IntrinsicHeight\(', caseSensitive: false),
    'wrap': RegExp(r'Wrap\(', caseSensitive: false),
    'singleChildScrollView': RegExp(r'SingleChildScrollView\(', caseSensitive: false),
    'listView': RegExp(r'ListView\(|ListView\.builder', caseSensitive: false),
    'gridView': RegExp(r'GridView\(|GridView\.builder', caseSensitive: false),
  };

  // Encontrar todas as telas
  final screensDir = Directory('$libPath/features');
  if (!screensDir.existsSync()) {
    print('❌ Erro: Diretório features não encontrado');
    exit(1);
  }

  final dartFiles = <File>[];
  await _findDartFiles(screensDir, dartFiles);

  print('📁 Encontrados ${dartFiles.length} arquivos Dart para análise\n');

  int totalIssues = 0;
  int totalGoodPractices = 0;

  for (final file in dartFiles) {
    final relativePath = file.path.replaceAll(projectPath, '');
    final content = await file.readAsString();
    
    // Extrair nome do módulo
    final moduleMatch = RegExp(r'features[/\\](\w+)[/\\]').firstMatch(relativePath);
    final moduleName = moduleMatch?.group(1) ?? 'unknown';
    
    // Análise do arquivo
    final issues = <ResponsivenessIssue>[];
    final goodPractices = <String>[];

    // Verificar padrões problemáticos
    for (final entry in problematicPatterns.entries) {
      final matches = entry.value.allMatches(content);
      for (final match in matches) {
        // Filtrar por limites de valor
        final limit = valueLimits[entry.key];
        if (limit != null) {
          final valueStr = match.group(1);
          if (valueStr != null) {
            final value = double.tryParse(valueStr) ?? 0;
            // Ignorar valores abaixo do limite
            if (value < limit) continue;
          }
        }
        
        // Ignorar padrões dentro de comentários
        final lineStart = content.lastIndexOf('\n', match.start) + 1;
        final lineContent = content.substring(lineStart, match.start);
        if (lineContent.contains('//') || lineContent.trim().startsWith('*')) continue;
        
        final lineNumber = _getLineNumber(content, match.start);
        issues.add(ResponsivenessIssue(
          type: entry.key,
          lineNumber: lineNumber,
          matchedText: match.group(0) ?? '',
          severity: _getSeverity(entry.key),
          suggestion: _getSuggestion(entry.key),
        ));
      }
    }

    // Verificar boas práticas
    for (final entry in goodPatterns.entries) {
      if (entry.value.hasMatch(content)) {
        goodPractices.add(entry.key);
      }
    }

    // Adicionar ao resultado
    if (!analysisResults.containsKey(moduleName)) {
      analysisResults[moduleName] = ModuleAnalysis(moduleName);
    }
    
    analysisResults[moduleName]!.files.add(FileAnalysis(
      path: relativePath,
      issues: issues,
      goodPractices: goodPractices,
    ));

    totalIssues += issues.length;
    totalGoodPractices += goodPractices.length;
  }

  // Imprimir relatório
  print('═' * 80);
  print(' RELATÓRIO DE ANÁLISE DE RESPONSIVIDADE');
  print('═' * 80);
  print('');

  // Resumo por módulo
  print('📊 RESUMO POR MÓDULO:');
  print('-' * 80);
  
  final sortedModules = analysisResults.entries.toList()
    ..sort((a, b) => b.value.totalIssues.compareTo(a.value.totalIssues));

  for (final entry in sortedModules) {
    final module = entry.value;
    final issueCount = module.totalIssues;
    final goodCount = module.totalGoodPractices;
    final status = issueCount == 0 ? '✅' : (issueCount <= 5 ? '⚠️' : '❌');
    
    print('$status ${module.name.toUpperCase().padRight(20)} | Issues: ${issueCount.toString().padLeft(3)} | Boas práticas: ${goodCount.toString().padLeft(3)}');
  }

  print('');
  print('═' * 80);
  print(' DETALHES DOS PROBLEMAS ENCONTRADOS');
  print('═' * 80);
  print('');

  // Detalhes por módulo
  for (final entry in sortedModules) {
    final module = entry.value;
    if (module.totalIssues == 0) continue;

    print('');
    print('🔸 MÓDULO: ${module.name.toUpperCase()}');
    print('─' * 60);

    for (final file in module.files) {
      if (file.issues.isEmpty) continue;
      
      print('  📄 ${file.path}');
      
      // Agrupar por tipo de issue
      final byType = <String, List<ResponsivenessIssue>>{};
      for (final issue in file.issues) {
        byType.putIfAbsent(issue.type, () => []).add(issue);
      }
      
      for (final typeEntry in byType.entries) {
        final count = typeEntry.value.length;
        final severity = typeEntry.value.first.severity;
        final severityIcon = severity == 'high' ? '🔴' : (severity == 'medium' ? '🟡' : '🟢');
        
        print('     $severityIcon ${typeEntry.key}: $count ocorrência(s)');
        
        // Mostrar até 3 exemplos
        for (var i = 0; i < typeEntry.value.length && i < 3; i++) {
          final issue = typeEntry.value[i];
          print('        └─ Linha ${issue.lineNumber}: ${issue.matchedText.substring(0, issue.matchedText.length.clamp(0, 40))}...');
        }
        
        print('        💡 ${typeEntry.value.first.suggestion}');
      }
    }
  }

  // Estatísticas finais
  print('');
  print('═' * 80);
  print(' ESTATÍSTICAS FINAIS');
  print('═' * 80);
  print('');
  print('📁 Arquivos analisados:    ${dartFiles.length}');
  print('📦 Módulos analisados:     ${analysisResults.length}');
  print('❌ Total de issues:        $totalIssues');
  print('✅ Boas práticas usadas:   $totalGoodPractices');
  print('');

  // Score de responsividade
  final score = totalIssues == 0 
    ? 100 
    : ((totalGoodPractices / (totalIssues + totalGoodPractices)) * 100).round();
  
  final scoreEmoji = score >= 80 ? '🏆' : (score >= 60 ? '👍' : (score >= 40 ? '⚠️' : '❌'));
  
  print('$scoreEmoji SCORE DE RESPONSIVIDADE: $score%');
  print('');

  // Recomendações
  print('═' * 80);
  print(' RECOMENDAÇÕES');
  print('═' * 80);
  print('');
  
  if (totalIssues > 0) {
    print('🔧 AÇÕES RECOMENDADAS:');
    print('');
    print('1. Substituir valores hardcoded por MediaQuery ou LayoutBuilder');
    print('2. Usar Flexible/Expanded em Rows e Columns');
    print('3. Implementar breakpoints responsivos');
    print('4. Testar em diferentes tamanhos de tela');
    print('5. Usar SingleChildScrollView para conteúdo que pode overflow');
    print('');
    print('📚 RECURSOS:');
    print('   - https://flutter.dev/docs/development/ui/layout/responsive');
    print('   - https://pub.dev/packages/responsive_framework');
    print('');
  } else {
    print('🎉 Parabéns! Seu código segue boas práticas de responsividade!');
    print('');
  }

  exit(totalIssues > 0 ? 1 : 0);
}

Future<void> _findDartFiles(Directory dir, List<File> files) async {
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && 
        entity.path.endsWith('.dart') &&
        entity.path.contains('screen')) {
      files.add(entity);
    }
  }
}

int _getLineNumber(String content, int offset) {
  return content.substring(0, offset).split('\n').length;
}

String _getSeverity(String patternType) {
  switch (patternType) {
    case 'hardcoded_width':
    case 'hardcoded_height':
    case 'hardcoded_size':
      return 'high';
    case 'unconstrained_box':
    case 'overflow_box':
      return 'high';
    case 'hardcoded_padding_large':
    case 'hardcoded_positioned':
      return 'medium';
    case 'hardcoded_fontsize':
    case 'hardcoded_constraints':
      return 'low';
    default:
      return 'medium';
  }
}

String _getSuggestion(String patternType) {
  switch (patternType) {
    case 'hardcoded_width':
      return 'Use MediaQuery.of(context).size.width * fator ou Flexible/Expanded';
    case 'hardcoded_height':
      return 'Use MediaQuery.of(context).size.height * fator ou constraints';
    case 'hardcoded_size':
      return 'Use LayoutBuilder para tamanhos adaptativos';
    case 'hardcoded_padding_large':
      return 'Use EdgeInsets.symmetric com valores menores ou proporcionais';
    case 'hardcoded_positioned':
      return 'Use Positioned com porcentagens ou MediaQuery';
    case 'hardcoded_fontsize':
      return 'Use Theme.of(context).textTheme ou tamanhos relativos (fontSize >= 32 pode causar overflow em telas pequenas)';
    case 'unconstrained_box':
      return 'UnconstrainedBox pode causar overflow - use com cuidado';
    case 'overflow_box':
      return 'OverflowBox pode causar problemas de layout - revise o uso';
    case 'hardcoded_constraints':
      return 'Use LayoutBuilder ou MediaQuery para constraints dinâmicos';
    default:
      return 'Revise este código para melhor responsividade';
  }
}

class ResponsivenessIssue {
  final String type;
  final int lineNumber;
  final String matchedText;
  final String severity;
  final String suggestion;

  ResponsivenessIssue({
    required this.type,
    required this.lineNumber,
    required this.matchedText,
    required this.severity,
    required this.suggestion,
  });
}

class FileAnalysis {
  final String path;
  final List<ResponsivenessIssue> issues;
  final List<String> goodPractices;

  FileAnalysis({
    required this.path,
    required this.issues,
    required this.goodPractices,
  });
}

class ModuleAnalysis {
  final String name;
  final List<FileAnalysis> files = [];

  ModuleAnalysis(this.name);

  int get totalIssues => files.fold(0, (sum, f) => sum + f.issues.length);
  int get totalGoodPractices => files.fold(0, (sum, f) => sum + f.goodPractices.length);
}
