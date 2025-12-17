import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/core/constants/app_constants.dart';

/// Serviço de armazenamento local
class StorageService {
  SharedPreferences? _prefs;

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // === Autenticação ===

  Future<void> saveAuthToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyAuthToken, token);
  }

  Future<String?> getAuthToken() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyAuthToken);
  }

  /// Alias para getAuthToken (compatibilidade)
  Future<String?> getAccessToken() => getAuthToken();

  /// Atualiza apenas o token de acesso (para refresh ou WorkContext)
  Future<void> updateAccessToken(String token) async {
    await saveAuthToken(token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyRefreshToken, token);
  }

  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyRefreshToken);
  }

  Future<void> saveUserId(String userId) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyUserId, userId);
  }

  Future<String?> getUserId() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyUserId);
  }

  Future<void> saveUserEmail(String email) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyUserEmail, email);
  }

  Future<String?> getUserEmail() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyUserEmail);
  }

  Future<void> setRememberMe(bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(AppConstants.keyRememberMe, value);
  }

  Future<bool> getRememberMe() async {
    await _ensureInitialized();
    return _prefs!.getBool(AppConstants.keyRememberMe) ?? false;
  }

  Future<void> clearAuth() async {
    await _ensureInitialized();
    await _prefs!.remove(AppConstants.keyAuthToken);
    await _prefs!.remove(AppConstants.keyRefreshToken);
    await _prefs!.remove(AppConstants.keyTokenExpiry);
    await _prefs!.remove(AppConstants.keyUserId);
    await _prefs!.remove(AppConstants.keyUserEmail);
    await _prefs!.remove(AppConstants.keyUsername);
    await _prefs!.remove(AppConstants.keyStoreId);
    await _prefs!.remove(AppConstants.keyUserRoles);
  }

  // === Novos métodos para autenticação completa ===

  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyTokenExpiry, expiry.toIso8601String());
  }

  Future<DateTime?> getTokenExpiry() async {
    await _ensureInitialized();
    final expiryStr = _prefs!.getString(AppConstants.keyTokenExpiry);
    return expiryStr != null ? DateTime.parse(expiryStr) : null;
  }

  Future<void> saveUsername(String username) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyUsername, username);
  }

  Future<String?> getUsername() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyUsername);
  }

  Future<void> saveStoreId(String? storeId) async {
    await _ensureInitialized();
    if (storeId != null) {
      await _prefs!.setString(AppConstants.keyStoreId, storeId);
    } else {
      await _prefs!.remove(AppConstants.keyStoreId);
    }
  }

  Future<String?> getStoreId() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyStoreId);
  }

  Future<void> saveUserRoles(List<String> roles) async {
    await _ensureInitialized();
    await _prefs!.setStringList(AppConstants.keyUserRoles, roles);
  }

  Future<List<String>> getUserRoles() async {
    await _ensureInitialized();
    return _prefs!.getStringList(AppConstants.keyUserRoles) ?? [];
  }

  /// Verifica se o usuário está autenticado e o token não expirou
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    if (token == null) return false;
    
    final expiry = await getTokenExpiry();
    if (expiry == null) return true; // Sem data de expiração, assume válido
    
    return DateTime.now().isBefore(expiry);
  }

  /// Salva todos os dados de autenticação de uma vez
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required DateTime tokenExpiry,
    required String userId,
    required String username,
    String? storeId,
    List<String>? roles,
  }) async {
    await saveAuthToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveTokenExpiry(tokenExpiry);
    await saveUserId(userId);
    await saveUsername(username);
    await saveStoreId(storeId);
    if (roles != null) {
      await saveUserRoles(roles);
    }
  }

  // === Sincronização ===

  Future<void> saveLastSyncTime(DateTime time) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyLastSync, time.toIso8601String());
  }

  Future<DateTime?> getLastSyncTime() async {
    await _ensureInitialized();
    final timeStr = _prefs!.getString(AppConstants.keyLastSync);
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }

  // === Genérico ===

  Future<void> setString(String key, String value) async {
    await _ensureInitialized();
    await _prefs!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await _ensureInitialized();
    return _prefs!.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _ensureInitialized();
    await _prefs!.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await _ensureInitialized();
    return _prefs!.getInt(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    return _prefs!.getBool(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _ensureInitialized();
    await _prefs!.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    await _ensureInitialized();
    return _prefs!.getDouble(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _ensureInitialized();
    await _prefs!.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    await _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  Future<void> remove(String key) async {
    await _ensureInitialized();
    await _prefs!.remove(key);
  }

  Future<void> clear() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  // === Work Context ===

  /// Salva o contexto de trabalho como JSON
  Future<void> saveWorkContext(Map<String, dynamic> context) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyWorkContext, jsonEncode(context));
  }

  /// Obtém o contexto de trabalho salvo
  Future<Map<String, dynamic>?> getWorkContext() async {
    await _ensureInitialized();
    final json = _prefs!.getString(AppConstants.keyWorkContext);
    if (json != null) {
      try {
        return jsonDecode(json) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Limpa o contexto de trabalho
  Future<void> clearWorkContext() async {
    await _ensureInitialized();
    await _prefs!.remove(AppConstants.keyWorkContext);
  }

  /// Salva o ID do cliente
  Future<void> saveClientId(String? clientId) async {
    await _ensureInitialized();
    if (clientId != null) {
      await _prefs!.setString(AppConstants.keyClientId, clientId);
    } else {
      await _prefs!.remove(AppConstants.keyClientId);
    }
  }

  /// Obtém o ID do cliente
  Future<String?> getClientId() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyClientId);
  }

  /// Limpa todos os dados de autenticação incluindo WorkContext
  Future<void> clearAuthData() async {
    await clearAuth();
    await clearWorkContext();
  }
}



