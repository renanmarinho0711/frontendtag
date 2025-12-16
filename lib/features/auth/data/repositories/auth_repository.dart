import 'package:tagbean/core/network/api_client.dart';
import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/features/auth/data/models/auth_models.dart';
import 'package:tagbean/features/auth/data/models/user_model.dart';

/// Repository para operações de autenticação
/// Usa o ApiService existente do projeto
class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  /// Realiza login
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    return _apiService.post<LoginResponse>(
      ApiConstants.login,
      body: request.toJson(),
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Realiza registro de novo usuário
  Future<ApiResponse<LoginResponse>> register(RegisterRequest request) async {
    return _apiService.post<LoginResponse>(
      '/auth/register',
      body: request.toJson(),
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Atualiza o token usando refresh token
  Future<ApiResponse<LoginResponse>> refreshToken(String refreshToken) async {
    return _apiService.post<LoginResponse>(
      ApiConstants.refreshToken,
      body: {'refreshToken': refreshToken},
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Troca a senha do usuário
  Future<ApiResponse<void>> changePassword(ChangePasswordRequest request) async {
    return _apiService.post<void>(
      '/auth/change-password',
      body: request.toJson(),
    );
  }

  /// Solicita recuperação de senha
  Future<ApiResponse<void>> forgotPassword(String email) async {
    return _apiService.post<void>(
      '/auth/forgot-password',
      body: {'email': email},
    );
  }

  /// Redefine a senha usando token de recuperação
  Future<ApiResponse<void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    return _apiService.post<void>(
      '/auth/reset-password',
      body: {
        'email': email,
        'token': token,
        'newPassword': newPassword,
      },
    );
  }

  /// Lista todos os usuários (para admins)
  Future<ApiResponse<List<UserModel>>> getUsers() async {
    return _apiService.get<List<UserModel>>(
      ApiConstants.users,
      parser: (json) => (json as List)
          .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Remove um usuário
  Future<ApiResponse<void>> deleteUser(String userId) async {
    return _apiService.delete<void>('${ApiConstants.users}/$userId');
  }
}



