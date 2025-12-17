import 'package:tagbean/features/auth/data/models/user_model.dart';
import 'package:tagbean/features/auth/data/models/work_context_model.dart';

/// Modelo de resposta do login
/// Mapeado para: LoginResponseDto do backend
class LoginResponse {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;
  final UserModel user;
  final WorkContext? workContext;

  const LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
    this.workContext,
  });

  /// Cria a partir do JSON da API (LoginResponseDto)
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      // Backend usa 'accessToken', não 'token'
      token: json['accessToken'] as String? ?? json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String)
          : DateTime.now().add(const Duration(hours: 1)),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      workContext: json['workContext'] != null
          ? WorkContext.fromJson(json['workContext'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'user': user.toJson(),
      if (workContext != null) 'workContext': workContext!.toJson(),
    };
  }

  @override
  String toString() {
    return 'LoginResponse(user: ${user.username}, expiresAt: $expiresAt)';
  }
}

/// Modelo de request do login
/// Mapeado para: LoginRequestDto do backend
class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

/// Modelo de request de registro
/// Mapeado para: RegisterRequestDto do backend
class RegisterRequest {
  final String username;
  final String password;
  final String? email;
  final String? fullName;
  final String? role;
  final String? clientId;
  final String? storeId;

  const RegisterRequest({
    required this.username,
    required this.password,
    this.email,
    this.fullName,
    this.role,
    this.clientId,
    this.storeId,
  });

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (role != null) 'role': role,
      if (clientId != null) 'clientId': clientId,
      if (storeId != null) 'storeId': storeId,
    };
  }
}

/// Modelo de request de troca de senha
/// Mapeado para: ChangePasswordRequestDto do backend
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}



