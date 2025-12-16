import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/network/api_response.dart';

/// Repository para gerenciamento de usuários
/// Comunicação com UsersController do backend
class UsersRepository {
  final ApiService _apiService;

  UsersRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Lista todos os usuários
  /// GET /api/users
  Future<ApiResponse<List<Map<String, dynamic>>>> getUsers() async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      ApiConstants.users,
      parser: (data) {
        if (data is List) {
          return data.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  /// Obtém um usuário por ID
  /// GET /api/users/:id
  Future<ApiResponse<Map<String, dynamic>>> getUserById(String id) async {
    return await _apiService.get<Map<String, dynamic>>(
      ApiConstants.userById(id),
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Cria um novo usuário (ALINHADO COM CreateUserDto do backend)
  /// POST /api/users
  Future<ApiResponse<Map<String, dynamic>>> createUser({
    required String username,
    required String password,
    String? email,
    String? fullName,
    String? clientId,
    required String role,
    List<String>? storeIds,
    String? defaultStoreId,
    List<String>? roles,
  }) async {
    final body = {
      'username': username,
      'password': password,
      'role': role,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (clientId != null) 'clientId': clientId,
      if (storeIds != null && storeIds.isNotEmpty) 'storeIds': storeIds,
      if (defaultStoreId != null) 'defaultStoreId': defaultStoreId,
      if (roles != null && roles.isNotEmpty) 'roles': roles,
    };

    return await _apiService.post<Map<String, dynamic>>(
      ApiConstants.users,
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Atualiza um usuário
  /// PUT /api/users/:id
  Future<ApiResponse<Map<String, dynamic>>> updateUser({
    required String id,
    String? username,
    String? email,
    String? fullName,
    String? role,
    List<String>? storeIds,
    bool? isActive,
  }) async {
    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (email != null) body['email'] = email;
    if (fullName != null) body['fullName'] = fullName;
    if (role != null) body['role'] = role;
    if (storeIds != null) body['storeIds'] = storeIds;
    if (isActive != null) body['isActive'] = isActive;

    return await _apiService.put<Map<String, dynamic>>(
      ApiConstants.userById(id),
      body: body,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Alterna status do usuário (ativo/inativo)
  /// PATCH /api/users/:id/status
  Future<ApiResponse<void>> toggleUserStatus(String id, bool isActive) async {
    return await _apiService.patch<void>(
      '${ApiConstants.userById(id)}/status',
      body: {'isActive': isActive},
    );
  }

  /// Exclui um usuário
  /// DELETE /api/users/:id
  Future<ApiResponse<void>> deleteUser(String id) async {
    return await _apiService.delete(ApiConstants.userById(id));
  }

  /// Adiciona role a um usuário
  /// POST /api/users/:id/roles/:roleName
  Future<ApiResponse<void>> addUserRole(String userId, String roleName) async {
    return await _apiService.post(ApiConstants.userRoles(userId, roleName));
  }

  /// Remove role de um usuário
  /// DELETE /api/users/:id/roles/:roleName
  Future<ApiResponse<void>> removeUserRole(String userId, String roleName) async {
    return await _apiService.delete(ApiConstants.userRoles(userId, roleName));
  }

  /// Solicita reset de senha para um usuário
  /// POST /api/users/:id/reset-password
  Future<ApiResponse<Map<String, dynamic>>> requestPasswordReset(String userId) async {
    return await _apiService.post<Map<String, dynamic>>(
      '${ApiConstants.userById(userId)}/reset-password',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Obtém as roles permitidas para o usuário atual criar
  /// GET /api/users/allowed-roles
  Future<ApiResponse<Map<String, dynamic>>> getAllowedRoles() async {
    return await _apiService.get<Map<String, dynamic>>(
      '${ApiConstants.users}/allowed-roles',
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Libera recursos
  void dispose() {
    _apiService.dispose();
  }
}




