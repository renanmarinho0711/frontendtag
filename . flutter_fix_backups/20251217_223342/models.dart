/// Modelo base para entidades com ID
library;

abstract class BaseModel {

  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;



  const BaseModel({

    required this.id,

    required this.createdAt,

    required this.updatedAt,

  });



  Map<String, dynamic> toJson();

}



/// Produto

/// Mapeado para: ProductResponseDto do backend

/// Atualizado com campos de integração Minew

class Produto extends BaseModel {

  final String codigo;

  final String nome;

  final String? descricao;

  final double preco;

  final double? precoCusto;

  final double? precoPromocional;

  final String? categoriaId;

  final String? categoriaNome;

  final String? codigoBarras;

  final int? estoque;

  final bool ativo;

  final String? imageUrl;

  

  /// Quantidade de tags vinculadas ao produto

  final int? boundTagCount;

  

  /// Lista de MACs das tags vinculadas

  final List<String>? boundTagMacs;

  

  // Novos campos de integração Minew

  final String? sku; // Código SKU do produto

  final String? marca; // Marca do produto

  final String? fornecedor; // Fornecedor do produto

  final double? precoMembro; // Preço especial para membros

  final String? unidade; // Unidade de medida (KG, UN, L, etc.)

  final String? especificacao; // Especificações técnicas do produto

  final String? origem; // País/região de origem

  final bool syncWithMinew; // Se deve sincronizar com Minew Cloud

  final String? minewSyncStatus; // synced, pending, error, not_synced

  final DateTime? lastMinewSync; // Última sincronização com Minew

  final String? minewProductId; // ID do produto na Minew Cloud



  const Produto({

    required super.id,

    required super.createdAt,

    required super.updatedAt,

    required this.codigo,

    required this.nome,

    this.descricao,

    required this.preco,

    this.precoCusto,

    this.precoPromocional,

    this.categoriaId,

    this.categoriaNome,

    this.codigoBarras,

    this.estoque,

    this.ativo = true,

    this.imageUrl,

    this.boundTagCount,

    this.boundTagMacs,

    // Novos campos Minew

    this.sku,

    this.marca,

    this.fornecedor,

    this.precoMembro,

    this.unidade,

    this.especificacao,

    this.origem,

    this.syncWithMinew = false,

    this.minewSyncStatus,

    this.lastMinewSync,

    this.minewProductId,

  });

  

  /// Verifica se o produto tem tags vinculadas

  bool get hasTag => (boundTagCount ?? 0) > 0 || (boundTagMacs?.isNotEmpty ?? false);

  

  /// Verifica se o produto está sincronizado com Minew

  bool get isSynced => minewSyncStatus == 'synced';

  

  /// Verifica se há erro de sincronização

  bool get hasSyncError => minewSyncStatus == 'error';

  

  /// Verifica se está pendente de sincronização

  bool get isPendingSync => minewSyncStatus == 'pending';

  

  /// Retorna o preço promocional se existir, senão o preço normal

  double get precoAtual => precoPromocional ?? preco;

  

  /// Verifica se tem promoção ativa

  bool get temPromocao => precoPromocional != null && precoPromocional! < preco;

  

  /// Calcula desconto em percentual

  double get descontoPercentual => temPromocao 

      ? ((preco - precoPromocional!) / preco * 100) 

      : 0.0;



  factory Produto.fromJson(Map<String, dynamic> json) {

    return Produto(

      id: json['id'] as String,

      createdAt: DateTime.parse(json['createdAt'] as String),

      updatedAt: DateTime.parse(json['updatedAt'] as String),

      codigo: (json['código']).toString() ?? json['barcode'] ?? '',

      nome: (json['nome']).toString() ?? json['name'] ?? '',

      descricao: (json['descricao']).toString() ?? json['description'],

      // ignore: argument_type_not_assignable
      preco: (json['preco'] ?? json['price'] ?? 0 as num).toDouble(),

      precoCusto: json['precoCusto'] != null 

          ? (json['precoCusto'] as num).toDouble() 

          : json['costPrice'] != null 

              ? (json['costPrice'] as num).toDouble() 

              : null,

      precoPromocional: json['precoPromocional'] != null 

          ? (json['precoPromocional'] as num).toDouble() 

          : null,

      categoriaId: json['categoriaId'] as String?,

      categoriaNome: ((json['categoriaNome'] ?? json['category']) as String?) ?? '',

      codigoBarras: ((json['codigoBarras'] ?? json['barcode']) as String?) ?? '',

      estoque: ((json['estoque'] ?? json['stock']) as int?) ?? 0,

      ativo: ((json['ativo'] ?? json['isActive'] ?? true) as bool),

      imageUrl: ((json['imageUrl'] as String?) ?? ''),

      boundTagCount: ((json['boundTagCount'] as int?) ?? 0),

      boundTagMacs: (json['boundTagMacs'] as List<dynamic>?)?.cast<String>(),

      // Novos campos Minew

      sku: json['sku'] as String?,

      marca: (json['marca'] ?? json['brand']) as String?,

      fornecedor: (json['fornecedor'] ?? json['supplier']) as String?,

      precoMembro: json['precoMembro'] != null 

          ? (json['precoMembro'] as num).toDouble()

          : json['memberPrice'] != null

              ? (json['memberPrice'] as num).toDouble()

              : null,

      unidade: (json['unidade'] ?? json['unit']) as String?,

      especificacao: (json['especificacao'] ?? json['specification']) as String?,

      origem: (json['origem'] ?? json['origin']) as String?,

      syncWithMinew: json['syncWithMinew'] as bool? ?? false,

      minewSyncStatus: json['minewSyncStatus'] as String?,

      lastMinewSync: json['lastMinewSync'] != null 

          ? DateTime.parse(json['lastMinewSync'] as String)

          : null,

      minewProductId: json['minewProductId'] as String?,

    );

  }



  @override

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'createdAt': createdAt.toIso8601String(),

      'updatedAt': updatedAt.toIso8601String(),

      'código': codigo,

      'nome': nome,

      'descricao': descricao,

      'preco': preco,

      'precoCusto': precoCusto,

      'precoPromocional': precoPromocional,

      'categoriaId': categoriaId,

      'categoriaNome': categoriaNome,

      'codigoBarras': codigoBarras,

      'estoque': estoque,

      'ativo': ativo,

      'imageUrl': imageUrl,

      'boundTagCount': boundTagCount,

      'boundTagMacs': boundTagMacs,

      // Novos campos Minew

      'sku': sku,

      'marca': marca,

      'fornecedor': fornecedor,

      'precoMembro': precoMembro,

      'unidade': unidade,

      'especificacao': especificacao,

      'origem': origem,

      'syncWithMinew': syncWithMinew,

      'minewSyncStatus': minewSyncStatus,

      'lastMinewSync': lastMinewSync?.toIso8601String(),

      'minewProductId': minewProductId,

    };

  }

  

  /// Cria uma cópia com alterações

  Produto copyWith({

    String? id,

    DateTime? createdAt,

    DateTime? updatedAt,

    String? codigo,

    String? nome,

    String? descricao,

    double? preco,

    double? precoCusto,

    double? precoPromocional,

    String? categoriaId,

    String? categoriaNome,

    String? codigoBarras,

    int? estoque,

    bool? ativo,

    String? imageUrl,

    int? boundTagCount,

    List<String>? boundTagMacs,

    String? sku,

    String? marca,

    String? fornecedor,

    double? precoMembro,

    String? unidade,

    String? especificacao,

    String? origem,

    bool? syncWithMinew,

    String? minewSyncStatus,

    DateTime? lastMinewSync,

    String? minewProductId,

  }) {

    return Produto(

      id: id ?? this.id,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,

      codigo: codigo ?? this.codigo,

      nome: nome ?? this.nome,

      descricao: descricao ?? this.descricao,

      preco: preco ?? this.preco,

      precoCusto: precoCusto ?? this.precoCusto,

      precoPromocional: precoPromocional ?? this.precoPromocional,

      categoriaId: categoriaId ?? this.categoriaId,

      categoriaNome: categoriaNome ?? this.categoriaNome,

      codigoBarras: codigoBarras ?? this.codigoBarras,

      estoque: estoque ?? this.estoque,

      ativo: ativo ?? this.ativo,

      imageUrl: imageUrl ?? this.imageUrl,

      boundTagCount: boundTagCount ?? this.boundTagCount,

      boundTagMacs: boundTagMacs ?? this.boundTagMacs,

      sku: sku ?? this.sku,

      marca: marca ?? this.marca,

      fornecedor: fornecedor ?? this.fornecedor,

      precoMembro: precoMembro ?? this.precoMembro,

      unidade: unidade ?? this.unidade,

      especificacao: especificacao ?? this.especificacao,

      origem: origem ?? this.origem,

      syncWithMinew: syncWithMinew ?? this.syncWithMinew,

      minewSyncStatus: minewSyncStatus ?? this.minewSyncStatus,

      lastMinewSync: lastMinewSync ?? this.lastMinewSync,

      minewProductId: minewProductId ?? this.minewProductId,

    );

  }

}



/// Categoria

class Categoria extends BaseModel {

  final String nome;

  final String? descricao;

  final String? icone;

  final String? cor;

  final String? parentId;

  final int produtosCount;

  final bool ativa;



  const Categoria({

    required super.id,

    required super.createdAt,

    required super.updatedAt,

    required this.nome,

    this.descricao,

    this.icone,

    this.cor,

    this.parentId,

    this.produtosCount = 0,

    this.ativa = true,

  });



  factory Categoria.fromJson(Map<String, dynamic> json) {

    return Categoria(

      id: json['id'] as String,

      createdAt: DateTime.parse(json['createdAt'] as String),

      updatedAt: DateTime.parse(json['updatedAt'] as String),

      nome: json['nome'] as String,

      descricao: json['descricao'] as String?,

      icone: json['icone'] as String?,

      cor: json['cor'] as String?,

      parentId: json['parentId'] as String?,

      produtosCount: json['produtosCount'] as int? ?? 0,

      ativa: json['ativa'] as bool? ?? true,

    );

  }



  @override

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'createdAt': createdAt.toIso8601String(),

      'updatedAt': updatedAt.toIso8601String(),

      'nome': nome,

      'descricao': descricao,

      'icone': icone,

      'cor': cor,

      'parentId': parentId,

      'produtosCount': produtosCount,

      'ativa': ativa,

    };

  }

}



/// Etiqueta ESL

class Etiqueta extends BaseModel {

  final String mac;

  final String? produtoId;

  final String? produtoNome;

  final String status; // online, offline, baixaBateria

  final int? bateria;

  final DateTime? ultimaAtualizacao;

  final String? setor;

  final String? corredor;

  final String? prateleira;



  const Etiqueta({

    required super.id,

    required super.createdAt,

    required super.updatedAt,

    required this.mac,

    this.produtoId,

    this.produtoNome,

    required this.status,

    this.bateria,

    this.ultimaAtualizacao,

    this.setor,

    this.corredor,

    this.prateleira,

  });



  factory Etiqueta.fromJson(Map<String, dynamic> json) {

    return Etiqueta(

      id: json['id'] as String,

      createdAt: DateTime.parse(json['createdAt'] as String),

      updatedAt: DateTime.parse(json['updatedAt'] as String),

      mac: json['mac'] as String,

      produtoId: json['produtoId'] as String?,

      produtoNome: json['produtoNome'] as String?,

      status: json['status'] as String,

      bateria: json['bateria'] as int?,

      ultimaAtualizacao: json['ultimaAtualizacao'] != null

          ? DateTime.parse(json['ultimaAtualizacao'] as String)

          : null,

      setor: json['setor'] as String?,

      corredor: json['corredor'] as String?,

      prateleira: json['prateleira'] as String?,

    );

  }



  @override

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'createdAt': createdAt.toIso8601String(),

      'updatedAt': updatedAt.toIso8601String(),

      'mac': mac,

      'produtoId': produtoId,

      'produtoNome': produtoNome,

      'status': status,

      'bateria': bateria,

      'ultimaAtualizacao': ultimaAtualizacao?.toIso8601String(),

      'setor': setor,

      'corredor': corredor,

      'prateleira': prateleira,

    };

  }

}



/// Usuário

class Usuario extends BaseModel {

  final String nome;

  final String email;

  final String? avatar;

  final String role; // admin, gerente, operador

  final bool ativo;



  const Usuario({

    required super.id,

    required super.createdAt,

    required super.updatedAt,

    required this.nome,

    required this.email,

    this.avatar,

    required this.role,

    this.ativo = true,

  });



  factory Usuario.fromJson(Map<String, dynamic> json) {

    return Usuario(

      id: json['id'] as String,

      createdAt: DateTime.parse(json['createdAt'] as String),

      updatedAt: DateTime.parse(json['updatedAt'] as String),

      nome: json['nome'] as String,

      email: json['email'] as String,

      avatar: json['avatar'] as String?,

      role: json['role'] as String,

      ativo: json['ativo'] as bool? ?? true,

    );

  }



  @override

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'createdAt': createdAt.toIso8601String(),

      'updatedAt': updatedAt.toIso8601String(),

      'nome': nome,

      'email': email,

      'avatar': avatar,

      'role': role,

      'ativo': ativo,

    };

  }

}







