import 'package:flutter/material.dart';

import 'package:tagbean/design_system/design_system.dart';




// =============================================================================

// PRODUCT STATUS ENUM

// =============================================================================



enum ProductStatus {

  ativo('Ativo'),

  inativo('Inativo'),

  pausado('Pausado'),

  descontinuado('Descontinuado');



  final String label;

  const ProductStatus(this.label);



  factory ProductStatus.fromString(String? value) {

    return ProductStatus.values.firstWhere(

      (e) => e.label.toLowerCase() == value?.toLowerCase(),

      orElse: () => ProductStatus.ativo,

    );

  }



  Color get color {

    switch (this) {

      case ProductStatus.ativo:

        return AppThemeColors.success;

      case ProductStatus.inativo:

        return AppThemeColors.textSecondary;

      case ProductStatus.pausado:

        return AppThemeColors.warning;

      case ProductStatus.descontinuado:

        return AppThemeColors.error;

    }

  }



  /// Obtém a cor dinâmica do status (requer BuildContext)

  Color dynamicColor(BuildContext context) {

    final colors = ThemeColors.of(context);

    switch (this) {

      case ProductStatus.ativo:

        return colors.success;

      case ProductStatus.inativo:

        return colors.textSecondary;

      case ProductStatus.pausado:

        return colors.warning;

      case ProductStatus.descontinuado:

        return colors.error;

    }

  }

}



// =============================================================================

// PRODUCT MODEL

// =============================================================================



class ProductModel {

  final String id;

  final String codigo;

  final String nome;

  final String? descricao;

  final double preco;

  final double? precoKg;

  final double? precoPromocional;

  final String categoria;

  final String? categoriaId;

  final String? tag;

  final String? tagId;

  final ProductStatus status;

  final String? unidade;

  final double? estoque;

  final double? estoqueMinimo;

  final String? ultimaAtualizacao;

  final DateTime? dataAtualizacao;

  final Color cor;

  final IconData icone;

  final String? imagem;

  final String? codigoInterno;

  final String? fornecedor;

  final String? marca;

  final double? margemLucro;

  final double? custoMedio;

  // Novos campos de integra��o Minew

  final String? sku;

  final double? precoMembro;

  final String? especificacao;

  final String? origem;

  final bool syncWithMinew;

  final String? minewSyncStatus; // synced, pending, error, not_synced

  final DateTime? lastMinewSync;

  final String? minewProductId;



  const ProductModel({

    required this.id,

    required this.codigo,

    required this.nome,

    this.descricao,

    required this.preco,

    this.precoKg,

    this.precoPromocional,

    required this.categoria,

    this.categoriaId,

    this.tag,

    this.tagId,

    this.status = ProductStatus.ativo,

    this.unidade,

    this.estoque,

    this.estoqueMinimo,

    this.ultimaAtualizacao,

    this.dataAtualizacao,

    this.cor = AppThemeColors.blueMaterial,

    this.icone = Icons.inventory_2_rounded,

    this.imagem,

    this.codigoInterno,

    this.fornecedor,

    this.marca,

    this.margemLucro,

    this.custoMedio,

    // Novos campos Minew

    this.sku,

    this.precoMembro,

    this.especificacao,

    this.origem,

    this.syncWithMinew = false,

    this.minewSyncStatus,

    this.lastMinewSync,

    this.minewProductId,

  });



  bool get hasTag => tag != null && tag!.isNotEmpty;

  bool get hasPromocao => precoPromocional != null && precoPromocional! < preco;

  bool get estoqueEmAlerta => estoque != null && estoqueMinimo != null && estoque! <= estoqueMinimo!;

  double get desconto => hasPromocao ? ((preco - precoPromocional!) / preco) * 100 : 0;

  

  // Novos getters para status Minew

  bool get isSynced => minewSyncStatus == 'synced';

  bool get hasSyncError => minewSyncStatus == 'error';

  bool get isPendingSync => minewSyncStatus == 'pending';

  bool get hasPrecoMembro => precoMembro != null && precoMembro! > 0;

  

  /// Getter para verificar se o produto est� ativo

  bool get isAtivo => status == ProductStatus.ativo;

  

  /// Getter para label do status

  String get statusLabel => status.label;



  ProductModel copyWith({

    String? id,

    String? codigo,

    String? nome,

    String? descricao,

    double? preco,

    double? precoKg,

    double? precoPromocional,

    String? categoria,

    String? categoriaId,

    String? tag,

    String? tagId,

    ProductStatus? status,

    String? unidade,

    double? estoque,
 // ignore: argument_type_not_assignable

    double? estoqueMinimo,

    String? ultimaAtualizacao,

    DateTime? dataAtualizacao,

    Color? cor,

    IconData? icone,

    // ignore: argument_type_not_assignable
    String? imagem,

    // ignore: argument_type_not_assignable
    String? codigoInterno,

    String? fornecedor,

    String? marca,

    double? margemLucro,

    double? custoMedio,

    // Novos campos Minew

    String? sku,

    double? precoMembro,

    String? especificacao,

    String? origem,

    bool? syncWithMinew,

    String? minewSyncStatus,

    DateTime? lastMinewSync,

    String? minewProductId,

  }) {

    return ProductModel(

      id: id ?? this.id,

      codigo: codigo ?? this.codigo,

      nome: nome ?? this.nome,

      descricao: descricao ?? this.descricao,

      preco: preco ?? this.preco,

      precoKg: precoKg ?? this.precoKg,

      precoPromocional: precoPromocional ?? this.precoPromocional,

      categoria: categoria ?? this.categoria,

      categoriaId: categoriaId ?? this.categoriaId,

      tag: tag ?? this.tag,

      tagId: tagId ?? this.tagId,

      status: status ?? this.status,

      unidade: unidade ?? this.unidade,

      estoque: estoque ?? this.estoque,

      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,

      ultimaAtualizacao: ultimaAtualizacao ?? this.ultimaAtualizacao,

      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,

      cor: cor ?? this.cor,

      icone: icone ?? this.icone,

      imagem: imagem ?? this.imagem,

      codigoInterno: codigoInterno ?? this.codigoInterno,

      fornecedor: fornecedor ?? this.fornecedor,

      marca: marca ?? this.marca,

      margemLucro: margemLucro ?? this.margemLucro,

      custoMedio: custoMedio ?? this.custoMedio,

      // Novos campos Minew

      sku: sku ?? this.sku,

      precoMembro: precoMembro ?? this.precoMembro,

      especificacao: especificacao ?? this.especificacao,

      origem: origem ?? this.origem,

      syncWithMinew: syncWithMinew ?? this.syncWithMinew,

      minewSyncStatus: minewSyncStatus ?? this.minewSyncStatus,

      lastMinewSync: lastMinewSync ?? this.lastMinewSync,

      minewProductId: minewProductId ?? this.minewProductId,

    );

  }



  factory ProductModel.fromJson(Map<String, dynamic> json) {

    return ProductModel(

      id: json['id']?.toString() ?? '',

      codigo: json['código']?.toString() ?? json['barcode']?.toString() ?? '',

      nome: json['nome']?.toString() ?? json['name']?.toString() ?? '',

      descricao: json['descricao']?.toString() ?? json['description']?.toString(),

      preco: (json['preco'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble() ?? 0.0,

      precoKg: (json['precoKg'] as num?)?.toDouble(),

      precoPromocional: (json['precoPromocional'] as num?)?.toDouble(),

      categoria: json['categoria']?.toString() ?? json['category']?.toString() ?? '',

      categoriaId: json['categoriaId']?.toString(),

      tag: json['tag']?.toString(),

      tagId: json['tagId']?.toString(),

      status: ProductStatus.fromString(json['status']?.toString() ?? (json['isActive'] == true ? 'Ativo' : 'Inativo')),

      unidade: json['unidade']?.toString() ?? json['unit']?.toString(),

      estoque: (json['estoque'] as num?)?.toDouble() ?? (json['stock'] as num?)?.toDouble(),

      estoqueMinimo: (json['estoqueMinimo'] as num?)?.toDouble() ?? (json['minStock'] as num?)?.toDouble(),

      ultimaAtualizacao: json['ultimaAtualizacao']?.toString() ?? json['updatedAt']?.toString(),

      dataAtualizacao: json['dataAtualizacao'] != null

          ? DateTime.tryParse(json['dataAtualizacao'].toString())

          : json['updatedAt'] != null

              ? DateTime.tryParse(json['updatedAt'].toString())

              : null,

      cor: _parseColor(json['cor']),

      icone: _parseIcon(json['icone']),

      imagem: json['imagem']?.toString() ?? json['imageUrl']?.toString(),

      codigoInterno: json['codigoInterno']?.toString(),

      fornecedor: json['fornecedor']?.toString() ?? json['supplier']?.toString(),

      marca: json['marca']?.toString() ?? json['brand']?.toString(),

      margemLucro: (json['margemLucro'] as num?)?.toDouble(),

      custoMedio: (json['custoMedio'] as num?)?.toDouble() ?? (json['costPrice'] as num?)?.toDouble(),

      // Novos campos Minew

      sku: json['sku']?.toString(),

      precoMembro: (json['precoMembro'] as num?)?.toDouble() ?? (json['memberPrice'] as num?)?.toDouble(),

      especificacao: json['especificacao']?.toString() ?? json['specification']?.toString(),

      origem: json['origem']?.toString() ?? json['origin']?.toString(),

      syncWithMinew: json['syncWithMinew'] as bool? ?? false,

      minewSyncStatus: json['minewSyncStatus']?.toString(),

      lastMinewSync: json['lastMinewSync'] != null

          ? DateTime.tryParse(json['lastMinewSync'].toString())

          : null,

      minewProductId: json['minewProductId']?.toString(),

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'código': codigo,

      'nome': nome,

      'descricao': descricao,

      'preco': preco,

      'precoKg': precoKg,

      // ignore: argument_type_not_assignable
      'precoPromocional': precoPromocional,
 // ignore: argument_type_not_assignable

      'categoria': categoria,

      'categoriaId': categoriaId,

      'tag': tag,

      'tagId': tagId,

      'status': status.label,

      'unidade': unidade,

      'estoque': estoque,

      'estoqueMinimo': estoqueMinimo,

      'ultimaAtualizacao': ultimaAtualizacao,

      'dataAtualizacao': dataAtualizacao?.toIso8601String(),

      'imagem': imagem,

      'codigoInterno': codigoInterno,

      'fornecedor': fornecedor,

      'marca': marca,

      'margemLucro': margemLucro,

      'custoMedio': custoMedio,

      // Novos campos Minew

      'sku': sku,

      'precoMembro': precoMembro,

      'especificacao': especificacao,

      'origem': origem,

      'syncWithMinew': syncWithMinew,

      'minewSyncStatus': minewSyncStatus,

      'lastMinewSync': lastMinewSync?.toIso8601String(),

      'minewProductId': minewProductId,

    };

  }



  /// Factory para converter do modelo Produto (shared/models) para ProductModel

  factory ProductModel.fromProduto(dynamic produto) {

    // Suporta tanto Map quanto objeto Produto

    if (produto is Map<String, dynamic>) {

      return ProductModel.fromJson(produto);

    }

    

    // Assume que � um objeto Produto da camada de dados

    return ProductModel(

      id: produto.id?.toString() ?? '',

      codigo: produto.codigo?.toString() ?? '',

      nome: produto.nome?.toString() ?? '',

      descricao: produto.descricao?.toString(),

      preco: (produto.preco as num?)?.toDouble() ?? 0.0,

      precoPromocional: (produto.precoPromocional as num?)?.toDouble(),

      categoria: produto.categoriaNome?.toString() ?? 'Outros',

      categoriaId: produto.categoriaId?.toString(),

      status: produto.ativo == true ? ProductStatus.ativo : ProductStatus.inativo,

      estoque: (produto.estoque as num?)?.toDouble(),

      // ignore: argument_type_not_assignable
      dataAtualizacao: produto.updatedAt,

      imagem: produto.imageUrl?.toString(),

      custoMedio: (produto.precoCusto as num?)?.toDouble(),

      // Novos campos Minew (se dispon�veis no objeto Produto)

      sku: produto.sku?.toString(),

      marca: produto.marca?.toString(),

      fornecedor: produto.fornecedor?.toString(),

      precoMembro: (produto.precoMembro as num?)?.toDouble(),

      unidade: produto.unidade?.toString(),

      especificacao: produto.especificacao?.toString(),

      origem: produto.origem?.toString(),

      // ignore: argument_type_not_assignable
      syncWithMinew: produto.syncWithMinew ?? false,

      minewSyncStatus: produto.minewSyncStatus?.toString(),

      // ignore: argument_type_not_assignable
      lastMinewSync: produto.lastMinewSync,

      minewProductId: produto.minewProductId?.toString(),

    );

  }



  static Color _parseColor(dynamic cor) {

    if (cor is Color) return cor;

    if (cor is int) return Color(cor);

    return AppThemeColors.blueMaterial;

  }



  static IconData _parseIcon(dynamic icone) {

    if (icone is IconData) return icone;

    // Default icon

    return Icons.inventory_2_rounded;

  }

}



// =============================================================================

// PRODUCT STATISTICS MODEL

// =============================================================================



class ProductStatisticsModel {

  final int totalProdutos;

  final int comTag;

  final int semTag;

  final int ativos;

  final int inativos;

  final int categorias;

  final double valorEstoque;

  final double ticketMedio;

  final double margemMedia;

  final DateTime ultimaAtualizacao;

  final double crescimentoMensal;

  final int produtosMaisVendidos;

  final int alertasEstoque;

  final int tagsDisponiveis;



  const ProductStatisticsModel({

    this.totalProdutos = 0,

    this.comTag = 0,

    this.semTag = 0,

    this.ativos = 0,

    this.inativos = 0,

    this.categorias = 0,

    this.valorEstoque = 0.0,

    this.ticketMedio = 0.0,

    this.margemMedia = 0.0,

    required this.ultimaAtualizacao,

    this.crescimentoMensal = 0.0,

    this.produtosMaisVendidos = 0,

    this.alertasEstoque = 0,

    this.tagsDisponiveis = 0,

  });



  double get percentualComTag => totalProdutos > 0 ? (comTag / totalProdutos) * 100 : 0;

  double get percentualAtivos => totalProdutos > 0 ? (ativos / totalProdutos) * 100 : 0;



  factory ProductStatisticsModel.fromJson(Map<String, dynamic> json) {

    return ProductStatisticsModel(

      totalProdutos: json['totalProdutos'] as int? ?? 0,

      comTag: json['comTag'] as int? ?? 0,

      semTag: json['semTag'] as int? ?? 0,

      ativos: json['ativos'] as int? ?? 0,

      inativos: json['inativos'] as int? ?? 0,

      categorias: json['categorias'] as int? ?? 0,

      valorEstoque: (json['valorEstoque'] as num?)?.toDouble() ?? 0.0,

      ticketMedio: (json['ticketMedio'] as num?)?.toDouble() ?? 0.0,

      margemMedia: (json['margemMedia'] as num?)?.toDouble() ?? 0.0,

      ultimaAtualizacao: json['ultimaAtualizacao'] != null

          ? DateTime.parse(json['ultimaAtualizacao'].toString())

          : DateTime.now(),

      crescimentoMensal: (json['crescimentoMensal'] as num?)?.toDouble() ?? 0.0,

      produtosMaisVendidos: json['produtosMaisVendidos'] as int? ?? 0,

      alertasEstoque: json['alertasEstoque'] as int? ?? 0,

      tagsDisponiveis: json['tagsDisponiveis'] as int? ?? 0,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'totalProdutos': totalProdutos,

      'comTag': comTag,

      'semTag': semTag,

      'ativos': ativos,

      'inativos': inativos,

      'categorias': categorias,

      'valorEstoque': valorEstoque,

      'ticketMedio': ticketMedio,

      'margemMedia': margemMedia,

      'ultimaAtualizacao': ultimaAtualizacao.toIso8601String(),

      'crescimentoMensal': crescimentoMensal,

      'produtosMaisVendidos': produtosMaisVendidos,

      'alertasEstoque': alertasEstoque,

      'tagsDisponiveis': tagsDisponiveis,

    };

  }

}



// =============================================================================

// PRODUCT CATEGORY STATS MODEL

// =============================================================================



class ProductCategoryStatsModel {

  final String id;

  final String nome;

  final IconData icone;

  final Color cor;

  final List<Color> gradient;

  final int quantidade;

  final double percentual;

  final double faturamento;

  final double crescimento;

  final int tagAssociadas;



  const ProductCategoryStatsModel({

    required this.id,

    required this.nome,

    required this.icone,

    required this.cor,

    required this.gradient,

    this.quantidade = 0,

    this.percentual = 0.0,

    this.faturamento = 0.0,

    this.crescimento = 0.0,

    this.tagAssociadas = 0,

  });



  bool get crescimentoPositivo => crescimento > 0;



  factory ProductCategoryStatsModel.fromJson(Map<String, dynamic> json) {

    final cor = json['cor'] is Color 

        ? json['cor'] as Color 

        : AppThemeColors.blueMaterial;

    

    return ProductCategoryStatsModel(

      id: json['id']?.toString() ?? '',

      nome: json['nome']?.toString() ?? '',

      icone: json['icone'] is IconData ? json['icone'] as IconData : Icons.category_rounded,

      cor: cor,

      gradient: json['gradient'] is List 

          ? (json['gradient'] as List).map((e) => e is Color ? e : cor).toList().cast<Color>()

          : [cor, cor],

      quantidade: json['quantidade'] as int? ?? 0,

      percentual: (json['percentual'] as num?)?.toDouble() ?? 0.0,

      faturamento: (json['faturamento'] as num?)?.toDouble() ?? 0.0,

      crescimento: (json['crescimento'] as num?)?.toDouble() ?? 0.0,

      tagAssociadas: json['tagAssociadas'] as int? ?? 0,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'nome': nome,

      'quantidade': quantidade,

      'percentual': percentual,

      'faturamento': faturamento,

      'crescimento': crescimento,

      'tagAssociadas': tagAssociadas,

    };

  }

}



// =============================================================================

// PRICE HISTORY MODEL

// =============================================================================



/// Alias para compatibilidade

typedef PriceHistoryItem = PriceHistoryModel;



class PriceHistoryModel {

  final String id;

  final DateTime data;

  final String dataFormatada;

  final String usuario;

  final double precoAnterior;

  final double precoNovo;

  final String? motivo;



  const PriceHistoryModel({

    required this.id,

    required this.data,

    required this.dataFormatada,

    required this.usuario,

    required this.precoAnterior,

    required this.precoNovo,

    this.motivo,

  });



  double get variacao => precoNovo - precoAnterior;

  double get variacaoPercentual => precoAnterior > 0 

      ? ((precoNovo - precoAnterior) / precoAnterior) * 100 

      : 0;

  bool get aumento => precoNovo > precoAnterior;



  factory PriceHistoryModel.fromJson(Map<String, dynamic> json) {

    // Suporta tanto formato portugu�s quanto ingl�s do backend

    final data = json['data'] ?? json['date'];

    final parsedData = data is DateTime 

        ? data 

        : DateTime.tryParse(data?.toString() ?? '') ?? DateTime.now();

    

    return PriceHistoryModel(

      id: json['id']?.toString() ?? '',

      data: parsedData,

      dataFormatada: json['dataFormatada']?.toString() 

          ?? '${parsedData.day.toString().padLeft(2, '0')}/${parsedData.month.toString().padLeft(2, '0')}/${parsedData.year}',

      usuario: json['usuario']?.toString() 

          ?? json['changedBy']?.toString() 

          ?? json['user']?.toString() 

          ?? 'Sistema',

      // ignore: argument_type_not_assignable
      precoAnterior: (json['precoAnterior'] ?? json['previousPrice'] ?? json['oldPrice'] ?? 0).toDouble(),

      // ignore: argument_type_not_assignable
      precoNovo: (json['precoNovo'] ?? json['newPrice'] ?? json['price'] ?? 0).toDouble(),

      motivo: json['motivo']?.toString() ?? json['reason']?.toString(),

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'data': data.toIso8601String(),

      'dataFormatada': dataFormatada,

      'usuario': usuario,

      'precoAnterior': precoAnterior,

      'precoNovo': precoNovo,

      'motivo': motivo,

    };

  }

}



// =============================================================================

// PRODUCT DETAILS MODEL

// =============================================================================



class ProductDetailsModel {

  final ProductModel product;

  final ProductStatisticsModel? estatisticas;

  final List<PriceHistoryModel> historicoPrecos;



  const ProductDetailsModel({

    required this.product,

    this.estatisticas,

    this.historicoPrecos = const [],

  });



  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {

    return ProductDetailsModel(

      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>? ?? json),

      estatisticas: json['estatisticas'] != null 

          ? ProductStatisticsModel.fromJson(json['estatisticas'] as Map<String, dynamic>)

          : null,

      historicoPrecos: (json['historicoPrecos'] as List<dynamic>?)

              ?.map((e) => PriceHistoryModel.fromJson(e as Map<String, dynamic>))

              .toList() ??

          [],

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'product': product.toJson(),

      'estatisticas': estatisticas?.toJson(),

      'historicoPrecos': historicoPrecos.map((e) => e.toJson()).toList(),

    };

  }

}



// =============================================================================

// STOCK ITEM MODEL

// =============================================================================



class StockItemModel {

  final String id;

  final String productId;

  final String nome;

  final String categoria;

  final double estoqueAtual;

  final double estoqueMinimo;

  final double estoqueMaximo;

  final String unidade;

  final DateTime? ultimaMovimentacao;

  final String? fornecedor;

  final double? custoUnitario;

  final double? valorTotal;

  final bool emAlerta;

  final bool esgotado;



  const StockItemModel({

    required this.id,

    required this.productId,

    required this.nome,

    required this.categoria,

    this.estoqueAtual = 0,

    this.estoqueMinimo = 0,

    this.estoqueMaximo = 0,

    this.unidade = 'un',

    this.ultimaMovimentacao,

    this.fornecedor,

    this.custoUnitario,

    this.valorTotal,

    this.emAlerta = false,

    this.esgotado = false,

  });



  double get percentualEstoque => estoqueMaximo > 0 

      ? (estoqueAtual / estoqueMaximo) * 100 

      : 0;



  // Aliases para compatibilidade

  double get quantidade => estoqueAtual;

  String get sku => id;

  DateTime? get ultimaAtualizacao => ultimaMovimentacao;

  double? get valorUnitario => custoUnitario;



  String get status {

    if (esgotado || estoqueAtual <= 0) return 'Esgotado';

    if (emAlerta || estoqueAtual <= estoqueMinimo) return 'Cr�tico';

    if (estoqueAtual <= estoqueMinimo * 1.5) return 'Baixo';

    return 'OK';

  }



  Color get statusColor {

    if (esgotado || estoqueAtual <= 0) return AppThemeColors.error;

    if (emAlerta || estoqueAtual <= estoqueMinimo) return AppThemeColors.warning;

    return AppThemeColors.success;

  }



  /// Obtém a cor dinâmica do status (requer BuildContext)

  Color dynamicStatusColor(BuildContext context) {

    final colors = ThemeColors.of(context);

    if (esgotado || estoqueAtual <= 0) return colors.error;

    if (emAlerta || estoqueAtual <= estoqueMinimo) return colors.warning;

    return colors.success;

  }



  factory StockItemModel.fromJson(Map<String, dynamic> json) {

    return StockItemModel(

      id: json['id']?.toString() ?? '',

      productId: json['productId']?.toString() ?? '',

      nome: json['nome']?.toString() ?? '',

      categoria: json['categoria']?.toString() ?? '',

      estoqueAtual: (json['estoqueAtual'] as num?)?.toDouble() ?? 0,

      estoqueMinimo: (json['estoqueMinimo'] as num?)?.toDouble() ?? 0,

      estoqueMaximo: (json['estoqueMaximo'] as num?)?.toDouble() ?? 0,

      unidade: json['unidade']?.toString() ?? 'un',

      ultimaMovimentacao: json['ultimaMovimentacao'] != null

          ? DateTime.tryParse(json['ultimaMovimentacao'].toString())

          : null,

      fornecedor: json['fornecedor']?.toString(),

      custoUnitario: (json['custoUnitario'] as num?)?.toDouble(),

      valorTotal: (json['valorTotal'] as num?)?.toDouble(),

      emAlerta: json['emAlerta'] as bool? ?? false,

      esgotado: json['esgotado'] as bool? ?? false,

    );

  }



  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'productId': productId,

      'nome': nome,

      'categoria': categoria,

      'estoqueAtual': estoqueAtual,

      'estoqueMinimo': estoqueMinimo,

      'estoqueMaximo': estoqueMaximo,

      'unidade': unidade,

      'ultimaMovimentacao': ultimaMovimentacao?.toIso8601String(),

      'fornecedor': fornecedor,

      'custoUnitario': custoUnitario,

      'valorTotal': valorTotal,

      'emAlerta': emAlerta,

      'esgotado': esgotado,

    };

  }

}







