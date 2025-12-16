/// Modelo de usuário retornado pela API
/// Espelha o UserDto do backend C#
class UserModel {
  final String id;
  final String username;
  
  /// Email do usuário (para recuperação de senha e notificações)
  final String? email;
  
  /// Nome completo do usuário para exibição
  final String? fullName;
  
  final String? clientId;
  final String? clientName;
  
  @Deprecated('Use availableStores para gerenciar acesso a múltiplas lojas')
  final String? storeId;
  
  /// Role principal do usuário (PlatformAdmin, ClientAdmin, StoreManager, Operator)
  final String role;
  
  /// Lista de roles (RBAC)
  final List<String> roles;
  
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  /// ID do usuário que criou este usuário (auditoria)
  final String? createdBy;

  const UserModel({
    required this.id,
    required this.username,
    this.email,
    this.fullName,
    this.clientId,
    this.clientName,
    this.storeId,
    this.role = 'Operator',
    required this.roles,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  /// Cria a partir do JSON da API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      clientId: json['clientId']?.toString(),
      clientName: json['clientName'] as String?,
      storeId: json['storeId'] as String?,
      role: json['role'] as String? ?? 'Operator',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      createdBy: json['createdBy']?.toString(),
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (clientId != null) 'clientId': clientId,
      if (clientName != null) 'clientName': clientName,
      if (storeId != null) 'storeId': storeId,
      'role': role,
      'roles': roles,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (createdBy != null) 'createdBy': createdBy,
    };
  }

  // ============================================
  // Novos roles hierárquicos
  // ============================================

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

  /// Copia com modificações
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? clientId,
    String? clientName,
    String? storeId,
    String? role,
    List<String>? roles,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      storeId: storeId ?? this.storeId,
      role: role ?? this.role,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  /// Verifica se o usuário tem plano premium (compatibilidade com guards)
  bool get isPremium => isPlatformAdmin || isClientAdmin;

  /// Verifica se completou onboarding (compatibilidade com guards)
  bool get hasCompletedOnboarding => true;

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, roles: $roles, client: $clientName)';
  }
}



