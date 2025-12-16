import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbean/features/settings/data/models/user_model.dart';
import 'package:tagbean/features/settings/data/repositories/users_repository.dart';

// ============================================================================
// ESTADO
// ============================================================================

/// Estado do módulo de usuários
class UsersState {
  final List<SettingsUserModel> users;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  /// Estado inicial
  factory UsersState.initial() => const UsersState(isLoading: true);

  /// Estado com dados carregados
  factory UsersState.loaded(List<SettingsUserModel> users) => UsersState(users: users);

  /// Estado de erro
  factory UsersState.error(String message) => UsersState(errorMessage: message);

  /// Usuários filtrados pela busca
  List<SettingsUserModel> get filteredUsers {
    if (searchQuery.isEmpty) return users;
    final query = searchQuery.toLowerCase();
    return users.where((user) {
      final name = user.fullName ?? user.username;
      final email = user.email ?? '';
      return name.toLowerCase().contains(query) ||
             email.toLowerCase().contains(query);
    }).toList();
  }

  /// Contagem por status
  int get activeCount => users.where((u) => u.status == UserStatus.active).length;
  int get inactiveCount => users.where((u) => u.status != UserStatus.active).length;

  UsersState copyWith({
    List<SettingsUserModel>? users,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ============================================================================
// NOTIFIER
// ============================================================================

/// Gerenciador de estado do módulo de Usuários
class UsersNotifier extends StateNotifier<UsersState> {
  final UsersRepository? _repository;
  
  UsersNotifier([this._repository]) : super(UsersState.initial()) {
    _loadUsers();
  }

  /// Carrega usuários da API
  Future<void> _loadUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      if (_repository != null) {
        // GET /api/users - Conforme api_test.html
        final response = await _repository!.getUsers();
        if (response.isSuccess && response.data != null) {
          final users = response.data!.map((json) => SettingsUserModel.fromJson(json)).toList();
          state = UsersState.loaded(users);
          return;
        } else {
          // ERRO: API retornou falha
          state = state.copyWith(
            isLoading: false,
            errorMessage: response.message ?? 'Erro ao carregar usuários da API',
          );
          return;
        }
      }
      
      // SEM REPOSITORY: Mostrar erro ao invés de mock
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Repository não configurado',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Falha ao conectar com o servidor: $e',
      );
    }
  }

  /// Atualiza query de busca
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Adiciona novo usuário (ALINHADO COM CreateUserDto do backend)
  /// Envia: username, password, role, email, fullName, clientId, storeIds
  Future<bool> addUser(SettingsUserModel user, {String? password}) async {
    try {
      if (_repository != null) {
        // POST /api/users - Conforme CreateUserDto do backend
        final response = await _repository!.createUser(
          username: user.username,
          password: password ?? 'temp123', // Senha temporária se não informada
          email: user.email,
          fullName: user.fullName,
          role: user.role.name, // 'platformAdmin', 'clientAdmin', 'storeManager', 'operator'
          clientId: user.clientId,
          storeIds: user.storeIds,
        );
        
        if (response.isSuccess && response.data != null) {
          final newUser = SettingsUserModel.fromJson(response.data!);
          state = state.copyWith(users: [...state.users, newUser]);
          return true;
        } else {
          state = state.copyWith(errorMessage: response.errorMessage ?? 'Erro ao criar usuário');
          return false;
        }
      } else {
        // SEM REPOSITORY: Propaga erro
        state = state.copyWith(errorMessage: 'Repository não configurado');
        return false;
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Falha ao criar usuário: ${e.toString()}');
      return false;
    }
  }

  /// Atualiza usuário existente
  Future<bool> updateUser(SettingsUserModel user) async {
    try {
      if (_repository != null) {
        // PUT /api/users/:id - Conforme backend
        final response = await _repository!.updateUser(
          id: user.id,
          username: user.username,
          email: user.email,
          fullName: user.fullName,
          role: user.role.name,
          storeIds: user.storeIds,
          isActive: user.isActive,
        );
        
        if (response.isSuccess) {
          final updatedUsers = state.users.map((u) {
            return u.id == user.id ? user.copyWith(updatedAt: DateTime.now()) : u;
          }).toList();
          state = state.copyWith(users: updatedUsers);
          return true;
        } else {
          state = state.copyWith(errorMessage: response.errorMessage ?? 'Erro ao atualizar usuário');
          return false;
        }
      } else {
        // SEM REPOSITORY: Propaga erro
        state = state.copyWith(errorMessage: 'Repository não configurado');
        return false;
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Falha ao atualizar usuário: ${e.toString()}');
      return false;
    }
  }

  /// Alterna status do usuário (ativo/inativo)
  /// Alias para toggleUserStatus para compatibilidade com telas
  Future<bool> toggleStatus(String userId) => toggleUserStatus(userId);
  
  Future<bool> toggleUserStatus(String userId) async {
    try {
      final user = state.users.firstWhere((u) => u.id == userId);
      final newStatus = !user.isActive;
      
      if (_repository != null) {
        // PATCH /api/users/:id/status - Conforme api_test.html
        final response = await _repository!.toggleUserStatus(userId, newStatus);
        
        if (!response.isSuccess) {
          state = state.copyWith(errorMessage: response.errorMessage);
          return false;
        }
      }
      
      final updatedUsers = state.users.map((u) {
        if (u.id == userId) {
          return u.copyWith(
            status: newStatus ? UserStatus.active : UserStatus.inactive,
            updatedAt: DateTime.now(),
          );
        }
        return u;
      }).toList();
      
      state = state.copyWith(users: updatedUsers);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Remove usuário
  Future<bool> deleteUser(String userId) async {
    try {
      if (_repository != null) {
        // DELETE /api/users/:id - Conforme api_test.html
        final response = await _repository!.deleteUser(userId);
        
        if (!response.isSuccess) {
          state = state.copyWith(errorMessage: response.errorMessage);
          return false;
        }
      }
      
      final updatedUsers = state.users.where((u) => u.id != userId).toList();
      state = state.copyWith(users: updatedUsers);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Solicita reset de senha para um usuário
  Future<bool> requestPasswordReset(String userId) async {
    try {
      if (_repository != null) {
        // POST /api/users/:id/reset-password
        final response = await _repository!.requestPasswordReset(userId);
        
        if (!response.isSuccess) {
          state = state.copyWith(errorMessage: response.errorMessage);
          return false;
        }
      } else {
        state = state.copyWith(errorMessage: 'Repository não configurado');
        return false;
      }
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Recarrega usuários
  Future<void> refresh() async {
    await _loadUsers();
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider do Repository de Usuários (conectado à API)
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository();
});

/// Provider principal de Usuários - CONECTADO À API
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final repository = ref.watch(usersRepositoryProvider);
  return UsersNotifier(repository);
});

/// Provider da lista de usuários
final usersListProvider = Provider<List<SettingsUserModel>>((ref) {
  return ref.watch(usersProvider).users;
});

/// Provider de usuários filtrados
final filteredUsersProvider = Provider<List<SettingsUserModel>>((ref) {
  return ref.watch(usersProvider).filteredUsers;
});

/// Provider de loading
final usersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(usersProvider).isLoading;
});

/// Provider de contagem de ativos
final activeUsersCountProvider = Provider<int>((ref) {
  return ref.watch(usersProvider).activeCount;
});

/// Provider de contagem de inativos
final inactiveUsersCountProvider = Provider<int>((ref) {
  return ref.watch(usersProvider).inactiveCount;
});

// ============================================================================
// PROVIDERS AUXILIARES PARA HIERARQUIA
// ============================================================================

/// Estado das roles permitidas para criação
class AllowedRolesState {
  final List<String> allowedRoles;
  final bool isLoading;
  final String? errorMessage;

  const AllowedRolesState({
    this.allowedRoles = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AllowedRolesState copyWith({
    List<String>? allowedRoles,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AllowedRolesState(
      allowedRoles: allowedRoles ?? this.allowedRoles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Provider das roles que o usuário atual pode criar
/// Chama GET /api/users/allowed-roles
final allowedRolesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(usersRepositoryProvider);
  final response = await repository.getAllowedRoles();
  
  if (response.isSuccess && response.data != null) {
    final data = response.data!;
    if (data['allowedRoles'] is List) {
      return (data['allowedRoles'] as List).cast<String>();
    }
  }
  
  return [];
});

/// Converte role string para UserRole enum
UserRole roleFromString(String role) {
  switch (role.toLowerCase()) {
    case 'platformadmin':
      return UserRole.platformAdmin;
    case 'clientadmin':
      return UserRole.clientAdmin;
    case 'storemanager':
      return UserRole.storeManager;
    case 'operator':
      return UserRole.operator;
    default:
      return UserRole.operator;
  }
}

/// Converte UserRole enum para string do backend
String roleToString(UserRole role) {
  switch (role) {
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

/// Retorna o nome amigável da role
String roleDisplayName(UserRole role) {
  switch (role) {
    case UserRole.platformAdmin:
      return 'Administrador da Plataforma';
    case UserRole.clientAdmin:
      return 'Administrador do Cliente';
    case UserRole.storeManager:
      return 'Gerente de Loja';
    case UserRole.operator:
      return 'Operador';
    case UserRole.viewer:
      return 'Visualizador';
  }
}




