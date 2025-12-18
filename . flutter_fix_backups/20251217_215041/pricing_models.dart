import 'package:flutter/material.dart';
import 'package:tagbean/design_system/design_system.dart';

// =============================================================================
// PRICING ADJUSTMENT TYPE ENUM
// =============================================================================

enum AdjustmentType {
  percentual('percentual', 'Percentual'),
  porcentagem('porcentagem', 'Porcentagem'), // alias para percentual
  fixo('fixo', 'Valor Fixo'),
  individual('individual', 'Individual');

  final String value;
  final String label;
  const AdjustmentType(this.value, this.label);

  factory AdjustmentType.fromString(String? value) {
    return AdjustmentType.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => AdjustmentType.percentual,
    );
  }
}

// =============================================================================
// OPERATION TYPE ENUM
// =============================================================================

enum OperationType {
  aumentar('aumentar', 'Aumentar'),
  aumento('aumento', 'Aumento'), // alias para aumentar
  diminuir('diminuir', 'Diminuir'),
  reducao('reducao', 'Redu��o'); // alias para diminuir

  final String value;
  final String label;
  const OperationType(this.value, this.label);

  factory OperationType.fromString(String? value) {
    return OperationType.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => OperationType.aumentar,
    );
  }
}

// =============================================================================
// APPLY SCOPE ENUM
// =============================================================================

enum ApplyScope {
  todos('todos', 'Todos os produtos'),
  categoria('categoria', 'Por categoria'),
  marca('marca', 'Por marca'),
  selecionados('selecionados', 'Produtos selecionados'),
  lista('lista', 'Lista de produtos'),
  faixaPreco('faixaPreco', 'Faixa de pre�o');

  final String value;
  final String label;
  const ApplyScope(this.value, this.label);

  factory ApplyScope.fromString(String? value) {
    return ApplyScope.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => ApplyScope.todos,
    );
  }
}

// =============================================================================
// PRICING PRODUCT MODEL
// =============================================================================

class PricingProductModel {
  final String id;
  final String nome;
  final String? codigo;
  final String categoria;
  final String? marca;
  final double precoAtual;
  final double custo;
  final double precoNovo;
  final double margemAtual;
  final double margemNova;
  final Color cor;
  final String? tag;
  final bool ativo;
  final bool selecionado;

  const PricingProductModel({
    required this.id,
    required this.nome,
    this.codigo,
    required this.categoria,
    this.marca,
    required this.precoAtual,
    required this.custo,
    required this.precoNovo,
    required this.margemAtual,
    required this.margemNova,
    this.cor = const Color(0xFF2196F3),
    this.tag,
    this.ativo = true,
    this.selecionado = false,
  });

  double get variacao => precoNovo - precoAtual;
  double get variacaoPercentual => precoAtual > 0 
      ? ((precoNovo - precoAtual) / precoAtual) * 100 
      : 0;
  bool get hasTag => tag != null && tag!.isNotEmpty;
  bool get margemMenor => margemNova < margemAtual;

  PricingProductModel copyWith({
    String? id,
    String? nome,
    String? codigo,
    String? categoria,
    String? marca,
    double? precoAtual,
    double? custo,
    double? precoNovo,
    double? margemAtual,
    double? margemNova,
    Color? cor,
    String? tag,
    bool? ativo,
    bool? selecionado,
  }) {
    return PricingProductModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigo: codigo ?? this.codigo,
      categoria: categoria ?? this.categoria,
      marca: marca ?? this.marca,
      precoAtual: precoAtual ?? this.precoAtual,
      custo: custo ?? this.custo,
      precoNovo: precoNovo ?? this.precoNovo,
      margemAtual: margemAtual ?? this.margemAtual,
      margemNova: margemNova ?? this.margemNova,
      cor: cor ?? this.cor,
      tag: tag ?? this.tag,
      ativo: ativo ?? this.ativo,
      selecionado: selecionado ?? this.selecionado,
    );
  }

  factory PricingProductModel.fromJson(Map<String, dynamic> json) {
    // Suporta tanto snake_case quanto camelCase da API
    final currentPrice = (json['currentPrice'] ?? json['preco_atual'] ?? json['price'] ?? 0).toDouble();
    final newPrice = (json['newPrice'] ?? json['preco_novo'] ?? currentPrice).toDouble();
    final cost = (json['cost'] ?? json['custo'] ?? currentPrice * 0.6).toDouble();
    final currentMargin = (json['currentMargin'] ?? json['margem_atual'] ?? json['margin'] ?? 0).toDouble();
    final newMargin = (json['newMargin'] ?? json['margem_nova'] ?? currentMargin).toDouble();
    
    return PricingProductModel(
      id: json['id']?.toString() ?? '',
      nome: json['name']?.toString() ?? json['nome']?.toString() ?? '',
      categoria: json['category']?.toString() ?? json['categoryName']?.toString() ?? json['categoria']?.toString() ?? '',
      marca: json['brand']?.toString() ?? json['marca']?.toString(),
      precoAtual: currentPrice,
      custo: cost,
      precoNovo: newPrice,
      margemAtual: currentMargin,
      margemNova: newMargin,
      cor: json['cor'] is Color ? json['cor'] as Color : const Color(0xFF2196F3),
      tag: json['tag']?.toString() ?? json['barcode']?.toString(),
      ativo: json['isActive'] as bool? ?? json['ativo'] as bool? ?? true,
      selecionado: json['selecionado'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'categoria': categoria,
      'marca': marca,
      'preco_atual': precoAtual,
      'custo': custo,
      'preco_novo': precoNovo,
      'margem_atual': margemAtual,
      'margem_nova': margemNova,
      'tag': tag,
      'ativo': ativo,
      'selecionado': selecionado,
    };
  }
}

// =============================================================================
// PRICING ADJUSTMENT CONFIG MODEL
// =============================================================================

class PricingAdjustmentConfigModel {
  final AdjustmentType tipoAjuste;
  final OperationType tipoOperacao;
  final ApplyScope aplicarEm;
  final String? categoriaSelecionada;
  final String? marcaSelecionada;
  final List<String>? produtosSelecionados;
  final double valor; // percentual ou valor fixo
  final bool respeitarMargemMinima;
  final double margemMinimaSeguranca;
  final double? margemMinima;
  final bool aplicarApenasProdutosAtivos;
  final bool notificarTags;

  const PricingAdjustmentConfigModel({
    this.tipoAjuste = AdjustmentType.percentual,
    this.tipoOperacao = OperationType.aumentar,
    this.aplicarEm = ApplyScope.todos,
    this.categoriaSelecionada,
    this.marcaSelecionada,
    this.produtosSelecionados,
    this.valor = 0.0,
    this.respeitarMargemMinima = true,
    this.margemMinimaSeguranca = 15.0,
    this.margemMinima,
    this.aplicarApenasProdutosAtivos = true,
    this.notificarTags = true,
  });

  PricingAdjustmentConfigModel copyWith({
    AdjustmentType? tipoAjuste,
    OperationType? tipoOperacao,
    ApplyScope? aplicarEm,
    String? categoriaSelecionada,
    String? marcaSelecionada,
    List<String>? produtosSelecionados,
    double? valor,
    bool? respeitarMargemMinima,
    double? margemMinimaSeguranca,
    double? margemMinima,
    bool? aplicarApenasProdutosAtivos,
    bool? notificarTags,
  }) {
    return PricingAdjustmentConfigModel(
      tipoAjuste: tipoAjuste ?? this.tipoAjuste,
      tipoOperacao: tipoOperacao ?? this.tipoOperacao,
      aplicarEm: aplicarEm ?? this.aplicarEm,
      categoriaSelecionada: categoriaSelecionada ?? this.categoriaSelecionada,
      marcaSelecionada: marcaSelecionada ?? this.marcaSelecionada,
      produtosSelecionados: produtosSelecionados ?? this.produtosSelecionados,
      valor: valor ?? this.valor,
      respeitarMargemMinima: respeitarMargemMinima ?? this.respeitarMargemMinima,
      margemMinimaSeguranca: margemMinimaSeguranca ?? this.margemMinimaSeguranca,
      margemMinima: margemMinima ?? this.margemMinima,
      aplicarApenasProdutosAtivos: aplicarApenasProdutosAtivos ?? this.aplicarApenasProdutosAtivos,
      notificarTags: notificarTags ?? this.notificarTags,
    );
  }

  factory PricingAdjustmentConfigModel.fromJson(Map<String, dynamic> json) {
    return PricingAdjustmentConfigModel(
      tipoAjuste: AdjustmentType.fromString(json['tipoAjuste']?.toString()),
      tipoOperacao: OperationType.fromString(json['tipoOperação']?.toString()),
      aplicarEm: ApplyScope.fromString(json['aplicarEm']?.toString()),
      categoriaSelecionada: json['categoriaSelecionada']?.toString(),
      marcaSelecionada: json['marcaSelecionada']?.toString(),
      produtosSelecionados: (json['produtosSelecionados'] as List?)?.map((e) => e.toString()).toList(),
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      respeitarMargemMinima: json['respeitarMargemMinima'] as bool? ?? true,
      margemMinimaSeguranca: (json['margemMinimaSegurança'] as num?)?.toDouble() ?? 15.0,
      margemMinima: (json['margemMinima'] as num?)?.toDouble(),
      aplicarApenasProdutosAtivos: json['aplicarApenasProdutosAtivos'] as bool? ?? true,
      notificarTags: json['notificarTags'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoAjuste': tipoAjuste.value,
      'tipoOperação': tipoOperacao.value,
      'aplicarEm': aplicarEm.value,
      'categoriaSelecionada': categoriaSelecionada,
      'marcaSelecionada': marcaSelecionada,
      'produtosSelecionados': produtosSelecionados,
      'valor': valor,
      'respeitarMargemMinima': respeitarMargemMinima,
      'margemMinimaSegurança': margemMinimaSeguranca,
      'margemMinima': margemMinima,
      'aplicarApenasProdutosAtivos': aplicarApenasProdutosAtivos,
      'notificarTags': notificarTags,
    };
  }
}

// =============================================================================
// PRICING SIMULATION RESULT MODEL
// =============================================================================

class PricingSimulationResultModel {
  final int produtosAfetados;
  final double impactoTotal;
  final double margemMediaAtual;
  final double margemMediaNova;
  final List<PricingProductModel> produtos;
  final DateTime dataSimulacao;

  const PricingSimulationResultModel({
    this.produtosAfetados = 0,
    this.impactoTotal = 0.0,
    this.margemMediaAtual = 0.0,
    this.margemMediaNova = 0.0,
    this.produtos = const [],
    required this.dataSimulacao,
  });

  double get variacaoMargem => margemMediaNova - margemMediaAtual;
  bool get margemMelhorou => margemMediaNova > margemMediaAtual;

  factory PricingSimulationResultModel.fromJson(Map<String, dynamic> json) {
    return PricingSimulationResultModel(
      produtosAfetados: json['produtosAfetados'] as int? ?? 0,
      impactoTotal: (json['impactoTotal'] as num?)?.toDouble() ?? 0.0,
      margemMediaAtual: (json['margemMediaAtual'] as num?)?.toDouble() ?? 0.0,
      margemMediaNova: (json['margemMediaNova'] as num?)?.toDouble() ?? 0.0,
      produtos: (json['produtos'] as List<dynamic>?)
              ?.map((e) => PricingProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      dataSimulacao: json['dataSimulacao'] != null
          ? DateTime.parse(json['dataSimulacao'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produtosAfetados': produtosAfetados,
      'impactoTotal': impactoTotal,
      'margemMediaAtual': margemMediaAtual,
      'margemMediaNova': margemMediaNova,
      'produtos': produtos.map((e) => e.toJson()).toList(),
      'dataSimulacao': dataSimulacao.toIso8601String(),
    };
  }
}

// =============================================================================
// MARGIN REVIEW MODEL
// =============================================================================

class MarginReviewModel {
  final String id;
  final String nome;
  final String categoria;
  final double precoVenda;
  final double custoCompra;
  final double margemAtual;
  final double margemIdeal;
  final double margemMinima;
  final String status; // 'saudavel', 'atencao', 'critico'
  final String? sugestao;

  const MarginReviewModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.precoVenda,
    required this.custoCompra,
    required this.margemAtual,
    required this.margemIdeal,
    required this.margemMinima,
    this.status = 'saudavel',
    this.sugestao,
  });

  /// Alias para custoCompra - usado em algumas telas
  double get custo => custoCompra;
  
  /// Alias para precoVenda - usado em algumas telas
  double get precoAtual => precoVenda;

  double get precoSugerido => custoCompra * (1 + margemIdeal / 100);
  double get diferenca => margemAtual - margemIdeal;
  bool get abaixoMinimo => margemAtual < margemMinima;
  bool get acimaideal => margemAtual >= margemIdeal;

  /// �cone baseado no status
  IconData get statusIcon {
    switch (status) {
      case 'critico':
        return Icons.warning_rounded;
      case 'atencao':
        return Icons.info_outline_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
  
  /// Label do status para exibi��o
  String get statusLabel {
    switch (status) {
      case 'critico':
        return 'Cr�tico';
      case 'atencao':
        return 'Aten��o';
      default:
        return 'Saud�vel';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'critico':
        return const Color(0xFFFF5252);
      case 'atencao':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  factory MarginReviewModel.fromJson(Map<String, dynamic> json) {
    // Mapear campos da API (camelCase) para o modelo
    final price = (json['price'] ?? json['precoVenda'] ?? 0).toDouble();
    final cost = (json['cost'] ?? json['custoCompra'] ?? price * 0.6).toDouble();
    final margin = (json['margin'] ?? json['margemAtual'] ?? 0).toDouble();
    
    // Determinar status baseado na margem
    String status = json['status']?.toString() ?? 'saudavel';
    if (status.isEmpty || status == 'null') {
      if (margin < 10) {
        status = 'critico';
      } else if (margin < 20) {
        status = 'atencao';
      } else {
        status = 'saudavel';
      }
    }
    
    return MarginReviewModel(
      id: json['id']?.toString() ?? '',
      nome: json['name']?.toString() ?? json['nome']?.toString() ?? '',
      categoria: json['category']?.toString() ?? json['categoria']?.toString() ?? '',
      precoVenda: price,
      custoCompra: cost,
      margemAtual: margin,
      margemIdeal: (json['targetMargin'] ?? json['margemIdeal'] ?? 30).toDouble(),
      margemMinima: (json['minMargin'] ?? json['margemMinima'] ?? 10).toDouble(),
      status: status,
      sugestao: json['suggestion']?.toString() ?? json['sugestao']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'categoria': categoria,
      'precoVenda': precoVenda,
      'custoCompra': custoCompra,
      'margemAtual': margemAtual,
      'margemIdeal': margemIdeal,
      'margemMinima': margemMinima,
      'status': status,
      'sugestao': sugestao,
    };
  }
}

// =============================================================================
// PRICE HISTORY ENTRY
// =============================================================================

/// Entrada do hist�rico de pre�os
class PriceHistoryEntry {
  final String id;
  final DateTime date;
  final double price;
  final double? previousPrice;
  final String? reason;
  final String? user;

  const PriceHistoryEntry({
    required this.id,
    required this.date,
    required this.price,
    this.previousPrice,
    this.reason,
    this.user,
  });

  double get variation => previousPrice != null && previousPrice! > 0
      ? ((price - previousPrice!) / previousPrice!) * 100
      : 0;

  factory PriceHistoryEntry.fromJson(Map<String, dynamic> json) {
    return PriceHistoryEntry(
      id: json['id']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      previousPrice: (json['previousPrice'] as num?)?.toDouble(),
      reason: json['reason']?.toString(),
      user: json['user']?.toString(),
    );
  }
}

// =============================================================================
// AI SUGGESTION MODEL
// =============================================================================

class AiSuggestionModel {
  final String id;
  final String? produtoId;
  final String tipo; // 'aumento', 'reducao', 'manutencao'
  final String produtoNome;
  final double precoAtual;
  final double precoSugerido;
  final double variacao; // percentual
  final int confianca; // 0-100
  final String motivo;
  final String impactoVendas;
  final String impactoMargem;
  final bool aceita;
  final DateTime dataGeracao;

  const AiSuggestionModel({
    required this.id,
    this.produtoId,
    required this.tipo,
    required this.produtoNome,
    required this.precoAtual,
    required this.precoSugerido,
    required this.variacao,
    this.confianca = 0,
    required this.motivo,
    this.impactoVendas = '0%',
    this.impactoMargem = '0%',
    this.aceita = false,
    required this.dataGeracao,
  });

  /// Alias para produtoNome (compatibilidade com UI)
  String get produto => produtoNome;

  Color get tipoColor {
    switch (tipo) {
      case 'aumento':
        return const Color(0xFF4CAF50);
      case 'reducao':
        return const Color(0xFFFF5252);
      case 'manutencao':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF2196F3);
    }
  }

  IconData get tipoIcon {
    switch (tipo) {
      case 'aumento':
        return Icons.trending_up_rounded;
      case 'reducao':
        return Icons.trending_down_rounded;
      case 'manutencao':
        return Icons.horizontal_rule_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  AiSuggestionModel copyWith({
    String? id,
    String? produtoId,
    String? tipo,
    String? produtoNome,
    double? precoAtual,
    double? precoSugerido,
    double? variacao,
    int? confianca,
    String? motivo,
    String? impactoVendas,
    String? impactoMargem,
    bool? aceita,
    DateTime? dataGeracao,
  }) {
    return AiSuggestionModel(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      tipo: tipo ?? this.tipo,
      produtoNome: produtoNome ?? this.produtoNome,
      precoAtual: precoAtual ?? this.precoAtual,
      precoSugerido: precoSugerido ?? this.precoSugerido,
      variacao: variacao ?? this.variacao,
      confianca: confianca ?? this.confianca,
      motivo: motivo ?? this.motivo,
      impactoVendas: impactoVendas ?? this.impactoVendas,
      impactoMargem: impactoMargem ?? this.impactoMargem,
      aceita: aceita ?? this.aceita,
      dataGeracao: dataGeracao ?? this.dataGeracao,
    );
  }

  factory AiSuggestionModel.fromJson(Map<String, dynamic> json) {
    // Mapear campos da API PriceOptimizationSuggestionDto
    final currentPrice = (json['currentPrice'] ?? json['preco_atual'] ?? 0).toDouble();
    final suggestedPrice = (json['suggestedPrice'] ?? json['preco_sugerido'] ?? currentPrice).toDouble();
    final impact = suggestedPrice - currentPrice;
    
    // Determinar tipo baseado no impacto
    String tipo = json['tipo']?.toString() ?? '';
    if (tipo.isEmpty) {
      if (impact > 0) {
        tipo = 'aumento';
      } else if (impact < 0) {
        tipo = 'reducao';
      } else {
        tipo = 'manutencao';
      }
    }
    
    return AiSuggestionModel(
      id: json['id']?.toString() ?? json['productId']?.toString() ?? '',
      produtoId: json['productId']?.toString(),
      tipo: tipo,
      produtoNome: json['productName']?.toString() ?? json['produto_nome']?.toString() ?? '',
      precoAtual: currentPrice,
      precoSugerido: suggestedPrice,
      variacao: currentPrice > 0 ? ((suggestedPrice - currentPrice) / currentPrice) * 100 : 0,
      confianca: (json['priority'] as int? ?? 3) * 20, // priority 1-5 => 20-100%
      motivo: json['reason']?.toString() ?? json['motivo']?.toString() ?? '',
      impactoVendas: json['impacto_vendas']?.toString() ?? '0%',
      impactoMargem: '${((json['suggestedMargin'] ?? 0) - (json['currentMargin'] ?? 0)).toStringAsFixed(1)}%',
      aceita: json['aceita'] as bool? ?? false,
      dataGeracao: json['data_geracao'] != null
          ? DateTime.parse(json['data_geracao'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'produto_nome': produtoNome,
      'preco_atual': precoAtual,
      'preco_sugerido': precoSugerido,
      'variacao': variacao,
      'confianca': confianca,
      'motivo': motivo,
      'impacto_vendas': impactoVendas,
      'impacto_margem': impactoMargem,
      'aceita': aceita,
      'data_geracao': dataGeracao.toIso8601String(),
    };
  }
}

// =============================================================================
// PRICING HISTORY MODEL
// =============================================================================

class PricingHistoryModel {
  final String id;
  final String? produtoId;
  final String produtoNome;
  final String tipo; // 'automatico', 'manual', 'ia', 'lote'
  final double precoAntigo;
  final double precoNovo;
  final String motivacao;
  final String usuario;
  final DateTime dataAjuste;
  final bool revertido;

  const PricingHistoryModel({
    required this.id,
    this.produtoId,
    required this.produtoNome,
    required this.tipo,
    required this.precoAntigo,
    required this.precoNovo,
    required this.motivacao,
    required this.usuario,
    required this.dataAjuste,
    this.revertido = false,
  });

  double get variacao => precoAntigo > 0 
      ? ((precoNovo - precoAntigo) / precoAntigo) * 100 
      : 0;
  bool get isAumento => precoNovo > precoAntigo;
  
  // Aliases para compatibilidade
  String get motivo => motivacao;
  DateTime get data => dataAjuste;
  
  Color get tipoColor {
    switch (tipo) {
      case 'automatico':
        return const Color(0xFF4CAF50);
      case 'manual':
        return const Color(0xFF2196F3);
      case 'ia':
        return AppThemeColors.blueCyan;
      case 'lote':
        return AppThemeColors.orangeDark;
      default:
        return AppThemeColors.textSecondary;
    }
  }

  /// Obtém a cor dinâmica do tipo (requer BuildContext)
  Color dynamicTipoColor(BuildContext context) {
    final colors = ThemeColors.of(context);
    switch (tipo) {
      case 'automatico':
        return colors.success;
      case 'manual':
        return colors.blueMain;
      case 'ia':
        return colors.blueCyan;
      case 'lote':
        return colors.orangeDark;
      default:
        return colors.textSecondary;
    }
  }

  IconData get tipoIcon {
    switch (tipo) {
      case 'automatico':
        return Icons.auto_mode_rounded;
      case 'manual':
        return Icons.edit_rounded;
      case 'ia':
        return Icons.psychology_rounded;
      case 'lote':
        return Icons.inventory_rounded;
      default:
        return Icons.change_circle_rounded;
    }
  }

  String get tipoLabel {
    switch (tipo) {
      case 'automatico':
        return 'Ajuste Autom�tico';
      case 'manual':
        return 'Ajuste Manual';
      case 'ia':
        return 'Sugest�o IA';
      case 'lote':
        return 'Ajuste em Lote';
      default:
        return 'Ajuste';
    }
  }

  PricingHistoryModel copyWith({
    String? id,
    String? produtoId,
    String? produtoNome,
    String? tipo,
    double? precoAntigo,
    double? precoNovo,
    String? motivacao,
    String? usuario,
    DateTime? dataAjuste,
    bool? revertido,
  }) {
    return PricingHistoryModel(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      produtoNome: produtoNome ?? this.produtoNome,
      tipo: tipo ?? this.tipo,
      precoAntigo: precoAntigo ?? this.precoAntigo,
      precoNovo: precoNovo ?? this.precoNovo,
      motivacao: motivacao ?? this.motivacao,
      usuario: usuario ?? this.usuario,
      dataAjuste: dataAjuste ?? this.dataAjuste,
      revertido: revertido ?? this.revertido,
    );
  }

  factory PricingHistoryModel.fromJson(Map<String, dynamic> json) {
    // Mapear campos da API PriceHistoryDto
    return PricingHistoryModel(
      id: json['id']?.toString() ?? '',
      produtoId: json['productId']?.toString(),
      produtoNome: json['productName']?.toString() ?? json['produto_nome']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? 'manual',
      precoAntigo: (json['oldPrice'] ?? json['preco_antigo'] ?? 0).toDouble(),
      precoNovo: (json['newPrice'] ?? json['preco_novo'] ?? 0).toDouble(),
      motivacao: json['reason']?.toString() ?? json['motivacao']?.toString() ?? '',
      usuario: json['changedBy']?.toString() ?? json['usuario']?.toString() ?? 'Sistema',
      dataAjuste: DateTime.tryParse(json['changedAt']?.toString() ?? json['data_ajuste']?.toString() ?? '') ?? DateTime.now(),
      revertido: json['revertido'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produto_nome': produtoNome,
      'tipo': tipo,
      'preco_antigo': precoAntigo,
      'preco_novo': precoNovo,
      'motivacao': motivacao,
      'usuario': usuario,
      'data_ajuste': dataAjuste.toIso8601String(),
      'revertido': revertido,
    };
  }
}

// =============================================================================
// DYNAMIC PRICING CONFIG MODEL
// =============================================================================

class DynamicPricingConfigModel {
  final bool ativo;
  final double margemMinima;
  final double margemMaxima;
  final double ajusteMaximoDiario;
  final String horarioPico;
  final String horarioVale;
  final bool considerarConcorrencia;
  final bool considerarDemanda;
  final bool considerarSazonalidade;
  final int frequenciaAtualizacao; // em horas
  final List<String> categoriasExcluidas;
  final DateTime? ultimaExecucao;

  const DynamicPricingConfigModel({
    this.ativo = false,
    this.margemMinima = 10.0,
    this.margemMaxima = 50.0,
    this.ajusteMaximoDiario = 10.0,
    this.horarioPico = '12:00',
    this.horarioVale = '03:00',
    this.considerarConcorrencia = true,
    this.considerarDemanda = true,
    this.considerarSazonalidade = true,
    this.frequenciaAtualizacao = 24,
    this.categoriasExcluidas = const [],
    this.ultimaExecucao,
  });

  DynamicPricingConfigModel copyWith({
    bool? ativo,
    double? margemMinima,
    double? margemMaxima,
    double? ajusteMaximoDiario,
    String? horarioPico,
    String? horarioVale,
    bool? considerarConcorrencia,
    bool? considerarDemanda,
    bool? considerarSazonalidade,
    int? frequenciaAtualizacao,
    List<String>? categoriasExcluidas,
    DateTime? ultimaExecucao,
  }) {
    return DynamicPricingConfigModel(
      ativo: ativo ?? this.ativo,
      margemMinima: margemMinima ?? this.margemMinima,
      margemMaxima: margemMaxima ?? this.margemMaxima,
      ajusteMaximoDiario: ajusteMaximoDiario ?? this.ajusteMaximoDiario,
      horarioPico: horarioPico ?? this.horarioPico,
      horarioVale: horarioVale ?? this.horarioVale,
      considerarConcorrencia: considerarConcorrencia ?? this.considerarConcorrencia,
      considerarDemanda: considerarDemanda ?? this.considerarDemanda,
      considerarSazonalidade: considerarSazonalidade ?? this.considerarSazonalidade,
      frequenciaAtualizacao: frequenciaAtualizacao ?? this.frequenciaAtualizacao,
      categoriasExcluidas: categoriasExcluidas ?? this.categoriasExcluidas,
      ultimaExecucao: ultimaExecucao ?? this.ultimaExecucao,
    );
  }

  factory DynamicPricingConfigModel.fromJson(Map<String, dynamic> json) {
    return DynamicPricingConfigModel(
      ativo: json['ativo'] as bool? ?? false,
      margemMinima: (json['margemMinima'] as num?)?.toDouble() ?? 10.0,
      margemMaxima: (json['margemMaxima'] as num?)?.toDouble() ?? 50.0,
      ajusteMaximoDiario: (json['ajusteMaximoDiario'] as num?)?.toDouble() ?? 10.0,
      horarioPico: json['horarioPico'] as String? ?? '12:00',
      horarioVale: json['horarioVale'] as String? ?? '03:00',
      considerarConcorrencia: json['considerarConcorrencia'] as bool? ?? true,
      considerarDemanda: json['considerarDemanda'] as bool? ?? true,
      considerarSazonalidade: json['considerarSazonalidade'] as bool? ?? true,
      frequenciaAtualizacao: json['frequenciaAtualizacao'] as int? ?? 24,
      categoriasExcluidas: (json['categoriasExcluidas'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      ultimaExecucao: json['ultimaExecucao'] != null
          ? DateTime.parse(json['ultimaExecucao'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ativo': ativo,
      'margemMinima': margemMinima,
      'margemMaxima': margemMaxima,
      'ajusteMaximoDiario': ajusteMaximoDiario,
      'horarioPico': horarioPico,
      'horarioVale': horarioVale,
      'considerarConcorrencia': considerarConcorrencia,
      'considerarDemanda': considerarDemanda,
      'considerarSazonalidade': considerarSazonalidade,
      'frequenciaAtualizacao': frequenciaAtualizacao,
      'categoriasExcluidas': categoriasExcluidas,
      'ultimaExecucao': ultimaExecucao?.toIso8601String(),
    };
  }
}



