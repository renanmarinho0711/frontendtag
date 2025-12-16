import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tagbean/core/constants/api_constants.dart';
import 'package:tagbean/core/network/api_response.dart';
import 'package:tagbean/core/storage/storage_service.dart';

/// Serviço centralizado para comunicação com API
/// 
/// Funcionalidades:
/// - Auto-refresh de token em caso de 401
/// - Retry automático com backoff exponencial para erros de rede
/// - Headers de autenticação automáticos
/// - Timeout configurável
class ApiService {
  final http.Client _client;
  final StorageService _storage;
  
  /// Número máximo de tentativas de retry
  static const int _maxRetries = 3;
  
  /// Flag para evitar múltiplos refreshes simultâneos
  bool _isRefreshing = false;
  
  /// Completer para aguardar refresh em andamento
  Completer<bool>? _refreshCompleter;

  ApiService({
    http.Client? client,
    StorageService? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? StorageService();

  /// Headers com autenticação
  Future<Map<String, String>> get _authHeaders async {
    final token = await _storage.getAuthToken();
    return {
      ...ApiConstants.defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET request com retry automático
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    T Function(dynamic)? parser,
    bool autoRefreshToken = true,
  }) async {
    return _executeWithRetry(
      () async {
        final uri = _buildUri(endpoint, queryParams);
        final headers = await _authHeaders;

        final response = await _client
            .get(uri, headers: headers)
            .timeout(ApiConstants.defaultTimeout);

        return _handleResponse<T>(response, parser);
      },
      endpoint: endpoint,
      autoRefreshToken: autoRefreshToken,
    );
  }

  /// POST request com retry automático
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? parser,
    Duration? timeout,
    bool autoRefreshToken = true,
  }) async {
    return _executeWithRetry(
      () async {
        final uri = _buildUri(endpoint);
        final headers = await _authHeaders;

        final response = await _client
            .post(
              uri,
              headers: headers,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(timeout ?? ApiConstants.defaultTimeout);

        return _handleResponse<T>(response, parser);
      },
      endpoint: endpoint,
      autoRefreshToken: autoRefreshToken,
    );
  }

  /// PUT request com retry automático
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? parser,
    bool autoRefreshToken = true,
  }) async {
    return _executeWithRetry(
      () async {
        final uri = _buildUri(endpoint);
        final headers = await _authHeaders;

        final response = await _client
            .put(
              uri,
              headers: headers,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(ApiConstants.defaultTimeout);

        return _handleResponse<T>(response, parser);
      },
      endpoint: endpoint,
      autoRefreshToken: autoRefreshToken,
    );
  }

  /// DELETE request com retry automático
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? parser,
    bool autoRefreshToken = true,
  }) async {
    return _executeWithRetry(
      () async {
        final uri = _buildUri(endpoint);
        final headers = await _authHeaders;

        // Se tem body, usa request customizado; senão usa delete simples
        http.Response response;
        if (body != null) {
          final request = http.Request('DELETE', uri);
          request.headers.addAll(headers);
          request.body = json.encode(body);
          final streamedResponse = await _client.send(request).timeout(ApiConstants.defaultTimeout);
          response = await http.Response.fromStream(streamedResponse);
        } else {
          response = await _client
              .delete(uri, headers: headers)
              .timeout(ApiConstants.defaultTimeout);
        }

        return _handleResponse<T>(response, parser);
      },
      endpoint: endpoint,
      autoRefreshToken: autoRefreshToken,
    );
  }

  /// PATCH request com retry automático
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? parser,
    bool autoRefreshToken = true,
  }) async {
    return _executeWithRetry(
      () async {
        final uri = _buildUri(endpoint);
        final headers = await _authHeaders;

        final response = await _client
            .patch(
              uri,
              headers: headers,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(ApiConstants.defaultTimeout);

        return _handleResponse<T>(response, parser);
      },
      endpoint: endpoint,
      autoRefreshToken: autoRefreshToken,
    );
  }

  /// Upload multipart (para arquivos) com retry automático
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint, {
    required String filePath,
    required String fieldName,
    Map<String, String>? additionalFields,
    T Function(dynamic)? parser,
    bool autoRefreshToken = true,
  }) async {
    return _executeWithRetry(
      () async {
        final uri = _buildUri(endpoint);
        final token = await _storage.getAuthToken();

        final request = http.MultipartRequest('POST', uri);
        
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

        if (additionalFields != null) {
          request.fields.addAll(additionalFields);
        }

        final streamedResponse = await request.send().timeout(ApiConstants.uploadTimeout);
        final response = await http.Response.fromStream(streamedResponse);

        return _handleResponse<T>(response, parser);
      },
      endpoint: endpoint,
      autoRefreshToken: autoRefreshToken,
    );
  }

  // ============================================================
  // MÉTODOS AUXILIARES DE RETRY E REFRESH
  // ============================================================

  /// Executa request com retry automático e refresh de token
  Future<ApiResponse<T>> _executeWithRetry<T>(
    Future<ApiResponse<T>> Function() request, {
    required String endpoint,
    bool autoRefreshToken = true,
    int attempt = 0,
  }) async {
    try {
      final response = await request();

      // Se 401 e auto-refresh habilitado, tenta refresh
      if (response.statusCode == 401 && autoRefreshToken && !_isAuthEndpoint(endpoint)) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry após refresh bem-sucedido
          return request();
        }
      }

      return response;
    } on TimeoutException {
      // Retry com backoff exponencial para timeout
      if (attempt < _maxRetries) {
        await _exponentialBackoff(attempt);
        return _executeWithRetry(
          request,
          endpoint: endpoint,
          autoRefreshToken: autoRefreshToken,
          attempt: attempt + 1,
        );
      }
      return ApiResponse.error('Tempo esgotado após $_maxRetries tentativas.');
    } catch (e) {
      // Retry com backoff exponencial para erros de rede
      if (attempt < _maxRetries && _isNetworkError(e)) {
        await _exponentialBackoff(attempt);
        return _executeWithRetry(
          request,
          endpoint: endpoint,
          autoRefreshToken: autoRefreshToken,
          attempt: attempt + 1,
        );
      }
      return ApiResponse.error('Erro de conexão: $e');
    }
  }

  /// Refresh do token de autenticação
  Future<bool> _refreshToken() async {
    // Evita múltiplos refreshes simultâneos
    if (_isRefreshing) {
      return _refreshCompleter?.future ?? Future.value(false);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        _completeRefresh(false);
        return false;
      }

      final uri = _buildUri(ApiConstants.refreshToken);
      final response = await _client.post(
        uri,
        headers: ApiConstants.defaultHeaders,
        body: json.encode({'refreshToken': refreshToken}),
      ).timeout(ApiConstants.defaultTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newToken = jsonData['accessToken'] ?? jsonData['token'];
        final newRefreshToken = jsonData['refreshToken'];

        if (newToken != null) {
          await _storage.saveAuthToken(newToken);
          if (newRefreshToken != null) {
            await _storage.saveRefreshToken(newRefreshToken);
          }
          _completeRefresh(true);
          return true;
        }
      }

      // Refresh falhou - limpa sessÃ£o
      await _storage.clearAuth();
      _completeRefresh(false);
      return false;
    } catch (e) {
      await _storage.clearAuth();
      _completeRefresh(false);
      return false;
    }
  }

  /// Completa o refresh e reseta flags
  void _completeRefresh(bool success) {
    _isRefreshing = false;
    _refreshCompleter?.complete(success);
    _refreshCompleter = null;
  }

  /// Backoff exponencial: 1s, 2s, 4s...
  Future<void> _exponentialBackoff(int attempt) async {
    final delay = Duration(seconds: 1 << attempt); // 2^attempt segundos
    await Future.delayed(delay);
  }

  /// Verifica se é endpoint de autenticação (não deve fazer refresh)
  bool _isAuthEndpoint(String endpoint) {
    return endpoint.contains('/auth/');
  }

  /// Verifica se é erro de rede recuperável
  bool _isNetworkError(Object error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('socketexception') ||
           errorString.contains('connection refused') ||
           errorString.contains('network is unreachable') ||
           errorString.contains('connection reset') ||
           errorString.contains('no route to host');
  }

  /// Constrói URI com query params
  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    final baseUri = Uri.parse(ApiConstants.baseUrl);
    final path = '${baseUri.path}$endpoint';

    if (queryParams != null && queryParams.isNotEmpty) {
      final params = queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: path,
        queryParameters: params,
      );
    }

    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      path: path,
    );
  }

  /// Processa resposta HTTP
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? parser,
  ) {
    final statusCode = response.statusCode;

    // Sucesso (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return ApiResponse.success(null);
      }

      final jsonData = json.decode(response.body);

      if (parser != null) {
        return ApiResponse.success(parser(jsonData));
      }

      return ApiResponse.success(jsonData as T);
    }

    // Erro do cliente (400-499)
    if (statusCode >= 400 && statusCode < 500) {
      String errorMessage = 'Erro na requisição';

      try {
        final jsonData = json.decode(response.body);
        errorMessage = jsonData['message'] ?? jsonData['error'] ?? errorMessage;
      } catch (_) {
        // Se não conseguir parsear, usa mensagem padrão
      }

      // 401 Unauthorized - pode ser sessÃ£o expirada OU credenciais inválidas
      if (statusCode == 401) {
        // Verifica se é login (credenciais) ou sessÃ£o expirada
        // Se o endpoint é de login, a mensagem é sobre credenciais
        // Se não conseguiu extrair mensagem do backend, usa mensagem genérica
        if (errorMessage == 'Erro na requisição') {
          errorMessage = 'Usuário ou senha incorretos.';
        }
        // Limpa autenticação apenas se não for tentativa de login
        // (login falho não deve limpar nada, pois não tinha sessÃ£o)
      }

      // 403 Forbidden
      if (statusCode == 403) {
        if (errorMessage == 'Erro na requisição') {
          errorMessage = 'Acesso negado. Você não tem permissÃ£o.';
        }
      }

      // 404 Not Found
      if (statusCode == 404) {
        if (errorMessage == 'Erro na requisição') {
          errorMessage = 'Recurso não encontrado.';
        }
      }

      return ApiResponse.error(errorMessage, statusCode: statusCode);
    }

    // Erro do servidor (500+)
    return ApiResponse.error(
      'Erro no servidor. Tente novamente mais tarde.',
      statusCode: statusCode,
    );
  }

  /// Fecha o cliente HTTP
  void dispose() {
    _client.close();
  }
}



