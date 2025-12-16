// Enum que define o escopo de trabalho do usuário
enum WorkScope {
  /// Usuário está trabalhando em uma única loja específica
  singleStore(1),

  /// Usuário está gerenciando todas as lojas do seu cliente
  allStores(2),

  /// Administrador da plataforma visualizando todo o sistema
  platform(3);

  const WorkScope(this.value);
  final int value;

  /// Cria a partir do valor inteiro
  static WorkScope fromValue(int value) {
    return WorkScope.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkScope.singleStore,
    );
  }

  /// Cria a partir de string (nome do enum)
  static WorkScope fromString(String name) {
    return WorkScope.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => WorkScope.singleStore,
    );
  }

  /// Descrição amigável do escopo
  String get description {
    switch (this) {
      case WorkScope.singleStore:
        return 'Loja única';
      case WorkScope.allStores:
        return 'Todas as lojas';
      case WorkScope.platform:
        return 'Plataforma';
    }
  }
}

/// Informações resumidas de uma loja
class StoreInfo {
  final String id;
  final String name;
  final String? number;
  final String? cnpj;
  final String? address;
  final bool isActive;

  const StoreInfo({
    required this.id,
    required this.name,
    this.number,
    this.cnpj,
    this.address,
    this.isActive = true,
  });

  /// Cria a partir do JSON da API
  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as String?,
      cnpj: json['cnpj'] as String?,
      address: json['address'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (number != null) 'number': number,
      if (cnpj != null) 'cnpj': cnpj,
      if (address != null) 'address': address,
      'isActive': isActive,
    };
  }

  @override
  String toString() => 'StoreInfo(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoreInfo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Contexto de trabalho atual do usuário
class WorkContext {
  /// Escopo de trabalho atual
  final WorkScope scope;

  /// ID da loja selecionada (quando scope = SingleStore)
  final String? currentStoreId;

  /// Nome da loja selecionada
  final String? currentStoreName;

  /// ID do cliente ao qual o usuário pertence
  final String? clientId;

  /// Nome do cliente
  final String? clientName;

  /// Lista de lojas disponíveis para o usuário
  final List<StoreInfo> availableStores;

  /// Indica se o usuário pode alternar entre escopos
  final bool canSwitchScope;

  /// Texto de exibição do contexto atual
  final String displayText;

  const WorkContext({
    required this.scope,
    this.currentStoreId,
    this.currentStoreName,
    this.clientId,
    this.clientName,
    this.availableStores = const [],
    this.canSwitchScope = false,
    this.displayText = '',
  });

  /// Cria a partir do JSON da API
  factory WorkContext.fromJson(Map<String, dynamic> json) {
    // Backend usa 'workScope', não 'scope'
    final scopeValue = json['workScope'] ?? json['scope'];
    WorkScope scope;

    if (scopeValue is int) {
      scope = WorkScope.fromValue(scopeValue);
    } else if (scopeValue is String) {
      scope = WorkScope.fromString(scopeValue);
    } else {
      scope = WorkScope.singleStore;
    }

    return WorkContext(
      scope: scope,
      currentStoreId: json['currentStoreId'] as String?,
      currentStoreName: json['currentStoreName'] as String?,
      clientId: json['clientId'] as String?,
      clientName: json['clientName'] as String?,
      availableStores: (json['availableStores'] as List<dynamic>?)
              ?.map((e) => StoreInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      // Backend usa 'canManageAllStores', não 'canSwitchScope'
      canSwitchScope: json['canManageAllStores'] as bool? ?? json['canSwitchScope'] as bool? ?? false,
      displayText: json['displayText'] as String? ?? '',
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'scope': scope.value,
      if (currentStoreId != null) 'currentStoreId': currentStoreId,
      if (currentStoreName != null) 'currentStoreName': currentStoreName,
      if (clientId != null) 'clientId': clientId,
      if (clientName != null) 'clientName': clientName,
      'availableStores': availableStores.map((e) => e.toJson()).toList(),
      'canSwitchScope': canSwitchScope,
      'displayText': displayText,
    };
  }

  /// Alias para scope - compatibilidade com nomes do backend
  WorkScope get workScope => scope;

  /// Alias para canSwitchScope - compatibilidade com nomes do backend
  bool get canManageAllStores => canSwitchScope;

  /// Verifica se está no modo de loja única
  bool get isSingleStore => scope == WorkScope.singleStore;

  /// Verifica se está no modo de todas as lojas
  bool get isAllStores => scope == WorkScope.allStores;

  /// Verifica se está no modo plataforma
  bool get isPlatform => scope == WorkScope.platform;

  /// Verifica se tem múltiplas lojas disponíveis
  bool get hasMultipleStores => availableStores.length > 1;

  /// Obtém a loja atual selecionada
  StoreInfo? get currentStore {
    if (currentStoreId == null) return null;
    try {
      return availableStores.firstWhere((s) => s.id == currentStoreId);
    } catch (_) {
      return null;
    }
  }

  /// Texto formatado para exibição
  String get formattedDisplayText {
    if (displayText.isNotEmpty) return displayText;

    switch (scope) {
      case WorkScope.singleStore:
        return currentStoreName ?? 'Loja não selecionada';
      case WorkScope.allStores:
        final count = availableStores.length;
        return 'Todas as lojas ($count)';
      case WorkScope.platform:
        return 'Plataforma TagBean';
    }
  }

  /// Copia com modificações
  WorkContext copyWith({
    WorkScope? scope,
    String? currentStoreId,
    String? currentStoreName,
    String? clientId,
    String? clientName,
    List<StoreInfo>? availableStores,
    bool? canSwitchScope,
    String? displayText,
  }) {
    return WorkContext(
      scope: scope ?? this.scope,
      currentStoreId: currentStoreId ?? this.currentStoreId,
      currentStoreName: currentStoreName ?? this.currentStoreName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      availableStores: availableStores ?? this.availableStores,
      canSwitchScope: canSwitchScope ?? this.canSwitchScope,
      displayText: displayText ?? this.displayText,
    );
  }

  /// Contexto vazio/inicial
  static const WorkContext empty = WorkContext(
    scope: WorkScope.singleStore,
    availableStores: [],
    canSwitchScope: false,
  );

  @override
  String toString() {
    return 'WorkContext(scope: ${scope.name}, store: $currentStoreName, stores: ${availableStores.length})';
  }
}

/// Request para alterar o contexto de trabalho
class SetWorkContextRequest {
  /// Novo escopo desejado
  final WorkScope scope;

  /// ID da loja (obrigatório se scope = SingleStore)
  final String? storeId;

  const SetWorkContextRequest({
    required this.scope,
    this.storeId,
  });

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'scope': scope.value,
      if (storeId != null) 'storeId': storeId,
    };
  }
}

/// Resposta da API ao alterar contexto
class WorkContextResponse {
  final bool success;
  final String message;
  final WorkContext? workContext;
  final String? newToken;

  const WorkContextResponse({
    required this.success,
    required this.message,
    this.workContext,
    this.newToken,
  });

  /// Cria a partir do JSON da API
  factory WorkContextResponse.fromJson(Map<String, dynamic> json) {
    return WorkContextResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      workContext: json['workContext'] != null
          ? WorkContext.fromJson(json['workContext'] as Map<String, dynamic>)
          : null,
      newToken: json['newToken'] as String?,
    );
  }

  @override
  String toString() {
    return 'WorkContextResponse(success: $success, message: $message)';
  }
}



