/// Modelo de usuário retornado pela API

class UserModel {

  final String id;

  final String username;

  final String? clientId;

  final String? clientName;

  @Deprecated('Use availableStores para gerenciar acesso a múltiplas lojas')

  final String? storeId;

  final bool isActive;

  final List<String> roles;

  final DateTime createdAt;

  final DateTime? updatedAt;



  const UserModel({

    required this.id,

    required this.username,

    this.clientId,

    this.clientName,

    this.storeId,

    required this.isActive,

    required this.roles,

    required this.createdAt,

    this.updatedAt,

  });



  /// Cria a partir do JSON da API

  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(

      id: json['id']?.toString() ?? '',

      username: json['username'] as String? ?? '',

      clientId: json['clientId']?.toString(),

      clientName: json['clientName'] as String?,

      storeId: json['storeId'] as String?,

      isActive: json['isActive'] as bool? ?? true,

      roles: (json['roles'] as List<dynamic>?)

              ?.map((e) => e.toString())

              .toList() ??

          [],

      createdAt: json['createdAt'] != null 

          ? DateTime.parse(json['createdAt'] as String)

          : DateTime.now(),

      updatedAt: json['updatedAt'] != null

          ? DateTime.parse(json['updatedAt'] as String)

          : null,

    );

  }



  /// Converte para JSON

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'username': username,

      if (clientId != null) 'clientId': clientId,

      if (clientName != null) 'clientName': clientName,

      if (storeId != null) 'storeId': storeId,

      'isActive': isActive,

      'roles': roles,

      'createdAt': createdAt.toIso8601String(),

      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),

    };

  }



  // ============================================

  // Novos roles hierárquicos

  // ============================================



  /// Retorna o primeiro role (compatibilidade com código que espera 'role' singular)

  String? get role => roles.isNotEmpty ? roles.first : null;



  /// Verifica se é PlatformAdmin (administrador da plataforma TagBean)

  bool get isPlatformAdmin => roles.contains('PlatformAdmin');



  /// Verifica se é ClientAdmin (administrador do cliente/empresa)

  bool get isClientAdmin => roles.contains('ClientAdmin');



  /// Verifica se é StoreManager (gerente de loja)

  bool get isStoreManager => roles.contains('StoreManager');



  /// Verifica se é Operator (operador de loja)

  bool get isOperator => roles.contains('Operator');



  /// Verifica se é Viewer (apenas visualização)

  bool get isViewer => roles.contains('Viewer');



  // ============================================

  // Roles legados (mantidos para compatibilidade)

  // ============================================



  /// Verifica se é SuperAdmin (legado - mapeia para PlatformAdmin)

  @Deprecated('Use isPlatformAdmin')

  bool get isSuperAdmin => roles.contains('SuperAdmin') || isPlatformAdmin;



  /// Verifica se é StoreAdmin (legado - mapeia para ClientAdmin ou StoreManager)

  @Deprecated('Use isClientAdmin ou isStoreManager')

  bool get isStoreAdmin =>

      roles.contains('StoreAdmin') || isClientAdmin || isStoreManager;



  /// Verifica se é StoreUser (legado - mapeia para Operator)

  @Deprecated('Use isOperator')

  bool get isStoreUser => roles.contains('StoreUser') || isOperator;



  // ============================================

  // Permissões

  // ============================================



  /// Verifica se pode editar produtos

  bool get canEditProducts =>

      isPlatformAdmin || isClientAdmin || isStoreManager;



  /// Verifica se pode atualizar preços

  bool get canUpdatePrices =>

      isPlatformAdmin || isClientAdmin || isStoreManager || isOperator;



  /// Verifica se pode gerenciar usuários

  bool get canManageUsers => isPlatformAdmin || isClientAdmin;



  /// Verifica se pode deletar loja

  bool get canDeleteStore => isPlatformAdmin;



  /// Verifica se pode ver todas as lojas do cliente

  bool get canViewAllStores => isPlatformAdmin || isClientAdmin;



  /// Verifica se pode gerenciar lojas

  bool get canManageStores => isPlatformAdmin || isClientAdmin;



  /// Verifica se pode acessar configurações de plataforma

  bool get canAccessPlatformSettings => isPlatformAdmin;



  /// Verifica se o usuário é premium (pode ser determinado pela presença de um role específico ou por um atributo)

  /// Por padrão, retorna true se o usuário é ativo e tem um dos roles principais

  bool get isPremium => isActive && roles.isNotEmpty && roles.where((r) => r != 'Viewer').isNotEmpty;



  /// Verifica se o usuário completou o onboarding

  /// Por padrão, retorna true se o usuário foi criado há mais de 1 dia ou se tem permissões elevadas

  bool get hasCompletedOnboarding => 

      isPlatformAdmin || isClientAdmin || isStoreManager || 

      DateTime.now().difference(createdAt).inDays > 0;



  /// Copia com modificações

  UserModel copyWith({

    String? id,

    String? username,

    String? clientId,

    String? clientName,

    String? storeId,

    bool? isActive,

    List<String>? roles,

    DateTime? createdAt,

    DateTime? updatedAt,

  }) {

    return UserModel(

      id: id ?? this.id,

      username: username ?? this.username,

      clientId: clientId ?? this.clientId,

      clientName: clientName ?? this.clientName,

      storeId: storeId ?? this.storeId,

      isActive: isActive ?? this.isActive,

      roles: roles ?? this.roles,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,

    );

  }



  @override

  String toString() {

    return 'UserModel(id: $id, username: $username, roles: $roles, client: $clientName)';

  }

}







