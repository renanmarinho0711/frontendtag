import 'package:flutter_test/flutter_test.dart';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';

void main() {
  group('SyncExceptions', () {
    group('SyncNetworkException', () {
      test('deve criar exceção com mensagem', () {
        final exception = SyncNetworkException('Sem conexão com a internet');
        
        expect(exception.message, equals('Sem conexão com a internet'));
        expect(exception.toString(), contains('Sem conexão'));
      });

      test('deve incluir causa original quando fornecida', () {
        final originalError = Exception('Socket closed');
        final exception = SyncNetworkException(
          'Erro de conexão',
          cause: originalError,
        );
        
        expect(exception.cause, equals(originalError));
      });
    });

    group('SyncAuthException', () {
      test('deve criar exceção de autenticação', () {
        final exception = SyncAuthException('Token expirado');
        
        expect(exception.message, equals('Token expirado'));
        expect(exception, isA<SyncException>());
      });

      test('deve indicar necessidade de re-login', () {
        final exception = SyncAuthException(
          'SessÃ£o inválida',
          requiresReLogin: true,
        );
        
        expect(exception.requiresReLogin, isTrue);
      });
    });

    group('SyncDataException', () {
      test('deve criar exceção de dados', () {
        final exception = SyncDataException('Dados corrompidos');
        
        expect(exception.message, equals('Dados corrompidos'));
      });

      test('deve incluir campo problemático', () {
        final exception = SyncDataException(
          'Campo inválido',
          field: 'price',
          value: -100,
        );
        
        expect(exception.field, equals('price'));
        expect(exception.value, equals(-100));
      });
    });

    group('SyncStoreException', () {
      test('deve criar exceção de loja', () {
        final exception = SyncStoreException('Loja não encontrada');
        
        expect(exception.message, equals('Loja não encontrada'));
      });

      test('deve incluir ID da loja quando fornecido', () {
        const storeId = '33098c05-d3aa-4958-8c19-b665e80e9082';
        final exception = SyncStoreException(
          'Loja inativa',
          storeId: storeId,
        );
        
        expect(exception.storeId, equals(storeId));
      });
    });

    group('MinewApiException', () {
      test('deve criar exceção Minew com status code', () {
        final exception = MinewApiException(
          'Rate limit exceeded',
          statusCode: 429,
        );
        
        expect(exception.message, equals('Rate limit exceeded'));
        expect(exception.statusCode, equals(429));
      });

      test('deve incluir response body quando fornecido', () {
        final exception = MinewApiException(
          'Bad Request',
          statusCode: 400,
          responseBody: '{"error": "Invalid MAC address format"}',
        );
        
        expect(exception.responseBody, contains('Invalid MAC'));
      });

      test('isServerError deve ser true para 5xx', () {
        final exception = MinewApiException('Server Error', statusCode: 503);
        
        expect(exception.isServerError, isTrue);
        expect(exception.isClientError, isFalse);
      });

      test('isClientError deve ser true para 4xx', () {
        final exception = MinewApiException('Not Found', statusCode: 404);
        
        expect(exception.isClientError, isTrue);
        expect(exception.isServerError, isFalse);
      });

      test('isRetryable deve ser true para erros temporários', () {
        expect(
          MinewApiException('Timeout', statusCode: 408).isRetryable,
          isTrue,
        );
        expect(
          MinewApiException('Rate Limit', statusCode: 429).isRetryable,
          isTrue,
        );
        expect(
          MinewApiException('Server Error', statusCode: 503).isRetryable,
          isTrue,
        );
        expect(
          MinewApiException('Gateway Timeout', statusCode: 504).isRetryable,
          isTrue,
        );
      });

      test('isRetryable deve ser false para erros permanentes', () {
        expect(
          MinewApiException('Bad Request', statusCode: 400).isRetryable,
          isFalse,
        );
        expect(
          MinewApiException('Unauthorized', statusCode: 401).isRetryable,
          isFalse,
        );
        expect(
          MinewApiException('Forbidden', statusCode: 403).isRetryable,
          isFalse,
        );
        expect(
          MinewApiException('Not Found', statusCode: 404).isRetryable,
          isFalse,
        );
      });
    });

    group('SyncCancelledException', () {
      test('deve criar exceção de cancelamento', () {
        final exception = SyncCancelledException('Sync cancelado pelo usuário');
        
        expect(exception.message, equals('Sync cancelado pelo usuário'));
      });

      test('deve indicar se foi cancelamento voluntário', () {
        final exception = SyncCancelledException(
          'Operação abortada',
          voluntary: true,
        );
        
        expect(exception.voluntary, isTrue);
      });
    });

    group('SyncConflictException', () {
      test('deve criar exceção de conflito', () {
        final exception = SyncConflictException(
          'Conflito de versÃ£o detectado',
        );
        
        expect(exception.message, equals('Conflito de versÃ£o detectado'));
      });

      test('deve incluir dados conflitantes', () {
        final exception = SyncConflictException(
          'Conflito',
          localData: {'price': 10.0},
          remoteData: {'price': 15.0},
        );
        
        expect(exception.localData, equals({'price': 10.0}));
        expect(exception.remoteData, equals({'price': 15.0}));
      });
    });
  });

  group('wrapException', () {
    test('deve identificar SocketException', () {
      final result = wrapException('SocketException: Connection refused');
      expect(result, isA<SyncNetworkException>());
    });

    test('deve identificar TimeoutException', () {
      final result = wrapException('TimeoutException after 30 seconds');
      expect(result, isA<SyncNetworkException>());
    });

    test('deve identificar ClientException', () {
      final result = wrapException('ClientException: Connection closed');
      expect(result, isA<SyncNetworkException>());
    });

    test('deve identificar erro 401', () {
      final result = wrapException('HTTP 401 Unauthorized');
      expect(result, isA<SyncAuthException>());
    });

    test('deve identificar erro 403', () {
      final result = wrapException('Status code: 403 Forbidden');
      expect(result, isA<SyncAuthException>());
    });

    test('deve retornar SyncDataException para erros desconhecidos', () {
      final result = wrapException('Some random error');
      expect(result, isA<SyncDataException>());
    });

    test('deve preservar mensagem original', () {
      final result = wrapException('Custom error message');
      expect(result.message, contains('Custom error'));
    });
  });

  group('Pattern Matching', () {
    test('deve permitir switch expression com sealed class', () {
      SyncException exception = MinewApiException('Test', statusCode: 500);
      
      final message = switch (exception) {
        SyncNetworkException() => 'Erro de rede',
        SyncAuthException() => 'Erro de autenticação',
        SyncDataException() => 'Erro de dados',
        SyncStoreException() => 'Erro de loja',
        MinewApiException(:final statusCode) => 'Erro Minew: $statusCode',
        SyncCancelledException() => 'Cancelado',
        SyncConflictException() => 'Conflito',
      };
      
      expect(message, equals('Erro Minew: 500'));
    });

    test('deve extrair propriedades com pattern matching', () {
      final exception = MinewApiException(
        'Test error',
        statusCode: 404,
        responseBody: '{"error": "not found"}',
      );
      
      if (exception case MinewApiException(
        statusCode: final code,
        responseBody: final body?,
      )) {
        expect(code, equals(404));
        expect(body, contains('not found'));
      } else {
        fail('Pattern should match');
      }
    });
  });
}
