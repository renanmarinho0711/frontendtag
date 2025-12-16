import 'package:flutter/material.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// Role hierárquico do usuário - Alinhado com backend
enum UserRole {
  platformAdmin,  // PlatformAdmin - Administrador da plataforma TagBean
  clientAdmin,    // ClientAdmin - Administrador do cliente/empresa
  storeManager,   // StoreManager - Gerente de loja
  operator,       // Operator - Operador de loja
  viewer,         // Viewer - Apenas visualização
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.platformAdmin:
        return 'Admin Plataforma';
      case UserRole.clientAdmin:
        return 'Admin Cliente';
      case UserRole.storeManager:
        return 'Gerente de Loja';
      case UserRole.operator:
        return 'Operador';
      case UserRole.viewer:
        return 'Visualizador';
    }
  }
  
  /// Nome para enviar ao backend
  String get backendName {
    switch (this) {
      case UserRole.platformAdmin:
        return 'PlatformAdmin';
      case UserRole.clientAdmin:
        return 'ClientAdmin';
      case UserRole.storeManager:
        return 'StoreManager';
      case UserRole.operator:
        return 'Operator';
      case UserRole.viewer:
        return 'Viewer';
    }
  }
  
  /// Color Key for semantic resolution at UI layer
  String get colorKey {
    switch (this) {
      case UserRole.platformAdmin:
        return 'roleSuperAdmin'; // Pink
      case UserRole.clientAdmin:
        return 'roleAdmin'; // Purple
      case UserRole.storeManager:
        return 'roleManager'; // Blue
      case UserRole.operator:
        return 'roleOperator'; // Green
      case UserRole.viewer:
        return 'roleViewer'; // Grey
    }
  }
  
  IconData get iconData {
    switch (this) {
      case UserRole.platformAdmin:
        return Icons.security_rounded;
      case UserRole.clientAdmin:
        return Icons.admin_panel_settings_rounded;
      case UserRole.storeManager:
        return Icons.manage_accounts_rounded;
      case UserRole.operator:
        return Icons.person_rounded;
      case UserRole.viewer:
        return Icons.visibility_rounded;
    }
  }
  
  /// Descrição detalhada da role
  String get description {
    switch (this) {
      case UserRole.platformAdmin:
        return 'Acesso total à plataforma TagBean. Gerencia clientes, lojas e todos os usuários.';
      case UserRole.clientAdmin:
        return 'Administrador do cliente. Gerencia todas as lojas e usuários do seu cliente.';
      case UserRole.storeManager:
        return 'Gerente de loja. Gerencia produtos, etiquetas e operadores da sua loja.';
      case UserRole.operator:
        return 'Operador de loja. Atualiza preços e gerencia etiquetas.';
      case UserRole.viewer:
        return 'Apenas visualização. Sem permissÃ£o para editar.';
    }
  }
  
  /// Parse da string do backend
  static UserRole fromBackendString(String? value) {
    if (value == null) return UserRole.operator;
    switch (value.toLowerCase()) {
      case 'platformadmin':
        return UserRole.platformAdmin;
      case 'clientadmin':
        return UserRole.clientAdmin;
      case 'storemanager':
        return UserRole.storeManager;
      case 'operator':
        return UserRole.operator;
      case 'viewer':
        return UserRole.viewer;
      // Legado
      case 'admin':
      case 'administrador':
        return UserRole.clientAdmin;
      case 'manager':
      case 'gerente':
        return UserRole.storeManager;
      case 'operador':
        return UserRole.operator;
      default:
        return UserRole.operator;
    }
  }
}

/// Status do usuário
enum UserStatus {
  active,
  inactive,
  pending,
  blocked,
}

extension UserStatusExtension on UserStatus {
  String get label {
    switch (this) {
      case UserStatus.active:
        return 'Ativo';
      case UserStatus.inactive:
        return 'Inativo';
      case UserStatus.pending:
        return 'Pendente';
      case UserStatus.blocked:
        return 'Bloqueado';
    }
  }
  
  /// Color Key for semantic resolution at UI layer
  String get colorKey {
    switch (this) {
      case UserStatus.active:
        return 'statusActive';
      case UserStatus.inactive:
        return 'statusInactive';
      case UserStatus.pending:
        return 'statusPending';
      case UserStatus.blocked:
        return 'statusBlocked';
    }
  }
}

/// Modelo de Usuário do sistema para settings
/// Alinhado com UserDto do backend
class SettingsUserModel {
  final String id;
  final String username;
  final String? email;
  final String? fullName;
  final String? clientId;
  final String? clientName;
  final UserRole role;
  final UserStatus status;
  final List<String> roles;
  final List<UserStoreInfo> stores;
  final List<String> _storeIdsList; // Lista de IDs para criação (quando stores está vazio)
  final String? defaultStoreId;
  final String? createdById;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastAccess;

  const SettingsUserModel({
    required this.id,
    required this.username,
    this.email,
    this.fullName,
    this.clientId,
    this.clientName,
    required this.role,
    required this.status,
    this.roles = const [],
    this.stores = const [],
    List<String> storeIdsList = const [], // Para criação de usuário
    this.defaultStoreId,
    this.createdById,
    required this.createdAt,
    this.updatedAt,
    this.lastAccess,
  }) : _storeIdsList = storeIdsList;

  // ========== GETTERS LEGADO (compatibilidade) ==========
  
  /// Nome para exibição (usa fullName se disponível)
  String get name => fullName ?? username;
  
  /// Nome para exibição (alias para name)
  String get displayName => name;
  
  /// Lista de IDs das lojas
  /// - Se stores está populado (do backend): extrai os IDs
  /// - Se _storeIdsList está populado (para criação): usa diretamente
  List<String> get storeIds {
    if (stores.isNotEmpty) {
      return stores.map((s) => s.id).toList();
    }
    return _storeIdsList;
  }
  
  /// Avatar inicial (primeira letra do nome)
  String get avatarInitial => name.isNotEmpty ? name[0].toUpperCase() : '?';
  
  /// Cor do avatar baseada na role (color key para resolucao no UI layer)
  String get avatarColorKey => role.colorKey;
  
  /// Converte role para UserLevel legado
  @Deprecated('Use role instead')
  UserLevel get level {
    switch (role) {
      case UserRole.platformAdmin:
      case UserRole.clientAdmin:
        return UserLevel.admin;
      case UserRole.storeManager:
        return UserLevel.manager;
      case UserRole.operator:
        return UserLevel.operator;
      case UserRole.viewer:
        return UserLevel.viewer;
    }
  }
  
  /// Avatar (vazio por padrão, usa avatarInitial)
  String get avatar => '';
  
  /// Permissões legado (use roles)
  @Deprecated('Use roles instead')
  List<String> get permissions => roles;
  
  /// StoreId legado (use stores)
  @Deprecated('Use stores instead')
  String? get storeId => stores.isNotEmpty ? stores.first.id : null;
  
  /// Último acesso formatado
  String get lastAccessFormatted {
    if (lastAccess == null) return 'Nunca';
    final day = lastAccess!.day.toString().padLeft(2, '0');
    final month = lastAccess!.month.toString().padLeft(2, '0');
    final year = lastAccess!.year;
    final hour = lastAccess!.hour.toString().padLeft(2, '0');
    final minute = lastAccess!.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
  
  /// Verifica se usuário está ativo
  bool get isActive => status == UserStatus.active;
  
  /// Verifica se é PlatformAdmin
  bool get isPlatformAdmin => role == UserRole.platformAdmin;
  
  /// Verifica se é ClientAdmin
  bool get isClientAdmin => role == UserRole.clientAdmin;
  
  /// Verifica se é administrador (PlatformAdmin ou ClientAdmin)
  bool get isAdmin => isPlatformAdmin || isClientAdmin;

  /// Cria a partir do JSON da API (alinhado com UserDto do backend)
  factory SettingsUserModel.fromJson(Map<String, dynamic> json) {
    // Parse role do backend
    final roleString = json['role'] as String? ?? 'Operator';
    final role = UserRoleExtension.fromBackendString(roleString);
    
    // Parse status: backend usa 'isActive', não 'status'
    final isActive = json['isActive'] as bool? ?? true;
    final status = isActive ? UserStatus.active : UserStatus.inactive;
    
    // Parse stores do backend
    final storesJson = json['stores'] as List<dynamic>? ?? [];
    final stores = storesJson
        .map((s) => UserStoreInfo.fromJson(s as Map<String, dynamic>))
        .toList();
    
    return SettingsUserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      clientId: json['clientId']?.toString(),
      clientName: json['clientName'] as String?,
      role: role,
      status: status,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      stores: stores,
      createdById: json['createdBy']?.toString(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastAccess: json['lastLoginAt'] != null 
          ? DateTime.tryParse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Converte para JSON para enviar ao backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (clientId != null) 'clientId': clientId,
      'role': role.backendName,
      'isActive': isActive,
      'roles': roles,
      'storeIds': storeIds, // Usa getter que retorna stores ou _storeIdsList
      if (defaultStoreId != null) 'defaultStoreId': defaultStoreId,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  SettingsUserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? clientId,
    String? clientName,
    UserRole? role,
    UserStatus? status,
    List<String>? roles,
    List<UserStoreInfo>? stores,
    List<String>? storeIdsList,
    String? defaultStoreId,
    String? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastAccess,
  }) {
    return SettingsUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      role: role ?? this.role,
      status: status ?? this.status,
      roles: roles ?? this.roles,
      stores: stores ?? this.stores,
      storeIdsList: storeIdsList ?? _storeIdsList,
      defaultStoreId: defaultStoreId ?? this.defaultStoreId,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccess: lastAccess ?? this.lastAccess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsUserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Informações da loja vinculada ao usuário
class UserStoreInfo {
  final String id;
  final String name;
  final String? number;
  final bool isDefault;
  final bool isActive;

  const UserStoreInfo({
    required this.id,
    required this.name,
    this.number,
    this.isDefault = false,
    this.isActive = true,
  });

  factory UserStoreInfo.fromJson(Map<String, dynamic> json) {
    return UserStoreInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      number: json['number'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (number != null) 'number': number,
    'isDefault': isDefault,
    'isActive': isActive,
  };
}



