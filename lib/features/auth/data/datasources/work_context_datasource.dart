import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/core/storage/storage_service.dart';
import 'package:tagbean/features/auth/data/models/work_context_model.dart';

/// Serviço para gerenciar o contexto de trabalho do usuário
class WorkContextService {
  final StorageService _storage;
  final http.Client _client;

  WorkContextService({
    StorageService? storage,
    http.Client? client,
  })  : _storage = storage ?? StorageService(),
        _client = client ?? http.Client();

  /// URL base da API
  String get _baseUrl => ApiConstants.baseUrl;

  /// Obtém o token de autenticação
  Future<String?> _getToken() async {
    return await _storage.getAccessToken();
  }

  /// Headers padrão com autenticação
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Obtém o contexto de trabalho atual do backend
  Future<WorkContextResponse> getWorkContext() async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$_baseUrl/auth/work-context'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WorkContextResponse(
          success: true,
          message: 'Contexto obtido com sucesso',
          workContext: WorkContext.fromJson(json),
        );
      } else if (response.statusCode == 401) {
        return const WorkContextResponse(
          success: false,
          message: 'SessÃ£o expirada. Faça login novamente.',
        );
      } else {
        final error = _parseError(response.body);
        return WorkContextResponse(
          success: false,
          message: error,
        );
      }
    } catch (e) {
      return WorkContextResponse(
        success: false,
        message: 'Erro ao obter contexto: ${e.toString()}',
      );
    }
  }

  /// Define o contexto de trabalho
  Future<WorkContextResponse> setWorkContext(SetWorkContextRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/set-work-context'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final workContextResponse = WorkContextResponse.fromJson(json);
        
        // Se retornou um novo token, atualizar no storage
        if (workContextResponse.newToken != null) {
          await _storage.updateAccessToken(workContextResponse.newToken!);
        }
        
        return workContextResponse;
      } else if (response.statusCode == 400) {
        final error = _parseError(response.body);
        return WorkContextResponse(
          success: false,
          message: error,
        );
      } else if (response.statusCode == 401) {
        return const WorkContextResponse(
          success: false,
          message: 'SessÃ£o expirada. Faça login novamente.',
        );
      } else if (response.statusCode == 403) {
        return const WorkContextResponse(
          success: false,
          message: 'Você não tem permissÃ£o para acessar esta loja.',
        );
      } else {
        final error = _parseError(response.body);
        return WorkContextResponse(
          success: false,
          message: error,
        );
      }
    } catch (e) {
      return WorkContextResponse(
        success: false,
        message: 'Erro ao definir contexto: ${e.toString()}',
      );
    }
  }

  /// Seleciona uma loja específica (atalho para setWorkContext)
  Future<WorkContextResponse> selectStore(String storeId) async {
    return setWorkContext(SetWorkContextRequest(
      scope: WorkScope.singleStore,
      storeId: storeId,
    ));
  }

  /// Seleciona todas as lojas (atalho para setWorkContext)
  Future<WorkContextResponse> selectAllStores() async {
    return setWorkContext(const SetWorkContextRequest(
      scope: WorkScope.allStores,
    ));
  }

  /// Salva o contexto localmente para persistência
  Future<void> saveLocalContext(WorkContext context) async {
    await _storage.saveWorkContext(context.toJson());
  }

  /// Carrega o contexto salvo localmente
  Future<WorkContext?> loadLocalContext() async {
    final json = await _storage.getWorkContext();
    if (json != null) {
      try {
        return WorkContext.fromJson(json);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Limpa o contexto local
  Future<void> clearLocalContext() async {
    await _storage.clearWorkContext();
  }

  /// Parse de erro da resposta
  String _parseError(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map<String, dynamic>) {
        return json['message'] as String? ??
            json['error'] as String? ??
            'Erro desconhecido';
      }
    } catch (_) {}
    return 'Erro ao processar resposta do servidor';
  }

  /// Fecha o cliente HTTP
  void dispose() {
    _client.close();
  }
}



