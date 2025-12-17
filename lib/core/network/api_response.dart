/// Classe genérica para respostas da API
class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;
  final bool isSuccess;

  const ApiResponse._({
    this.data,
    this.error,
    this.statusCode,
    required this.isSuccess,
  });

  /// Alias para error (compatibilidade)
  String? get errorMessage => error;

  /// Alias adicional para error (compatibilidade)
  String? get message => error;
  
  /// Verifica se tem erro
  bool get hasError => !isSuccess;

  /// Resposta de sucesso
  factory ApiResponse.success(T? data) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
    );
  }

  /// Resposta de erro
  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse._(
      error: message,
      statusCode: statusCode,
      isSuccess: false,
    );
  }

  /// Alias para error (compatibilidade com código legado)
  factory ApiResponse.failure(String message, {int? statusCode}) {
    return ApiResponse._(
      error: message,
      statusCode: statusCode,
      isSuccess: false,
    );
  }

  /// Helper para executar ações baseadas no resultado
  R when<R>({
    required R Function(T? data) success,
    required R Function(String error, int? statusCode) error,
  }) {
    if (isSuccess) {
      return success(data);
    } else {
      return error(this.error!, statusCode);
    }
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ApiResponse.success(data: $data)';
    } else {
      return 'ApiResponse.error(error: $error, statusCode: $statusCode)';
    }
  }
}

/// Classe para respostas paginadas
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  }) : hasMore = (page * pageSize) < total;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List)
          .map((item) => itemParser(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) itemSerializer) {
    return {
      'items': items.map(itemSerializer).toList(),
      'total': total,
      'page': page,
      'pageSize': pageSize,
      'hasMore': hasMore,
    };
  }
}



