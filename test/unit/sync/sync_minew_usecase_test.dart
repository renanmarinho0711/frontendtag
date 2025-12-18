mport 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tagbean/features/sync/domain/usecases/sync_minew_usecase.dart';
import 'package:tagbean/features/sync/data/repositories/minew_sync_repository.dart';
import 'package:tagbean/features/sync/data/repositories/sync_history_repository.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';
import 'package:tagbean/features/sync/data/exceptions/sync_exceptions.dart';

// Mocks
class MockMinewSyncRepository extends Mock implements MinewSyncRepository {}
class MockSyncHistoryRepository extends Mock implements SyncHistoryRepository {}

void main() {
  late MockMinewSyncRepository mockMinewRepo;
  late MockSyncHistoryRepository mockHistoryRepo;
  late SyncMinewStoreUseCase syncMinewStoreUseCase;
  late SyncMinewTagsUseCase syncMinewTagsUseCase;
  late ImportMinewTagsUseCase importMinewTagsUseCase;
  late GetMinewStatsUseCase getMinewStatsUseCase;

  const testStoreId = '33098c05-d3aa-4958-8c19-b665e80e9082';

  setUp(() {
    mockMinewRepo = MockMinewSyncRepository();
    mockHistoryRepo = MockSyncHistoryRepository();
    
    syncMinewStoreUseCase = SyncMinewStoreUseCase(
      minewRepository: mockMinewRepo,
      historyRepository: mockHistoryRepo,
    );
    
    syncMinewTagsUseCase = SyncMinewTagsUseCase(
      minewRepository: mockMinewRepo,
      historyRepository: mockHistoryRepo,
    );
    
    importMinewTagsUseCase = ImportMinewTagsUseCase(
      minewRepository: mockMinewRepo,
      historyRepository: mockHistoryRepo,
    );
    
    getMinewStatsUseCase = GetMinewStatsUseCase(
      minewRepository: mockMinewRepo,
    );
  });

  group('GetMinewStatsUseCase', () {
    test('deve retornar stats quando API responde com sucesso', () async {
      // Arrange
      final expectedStats = MinewStoreStats(
        totalTags: 100,
        onlineTags: 85,
        offlineTags: 15,
        boundTags: 90,
        unboundTags: 10,
        lowBatteryTags: 5,
        totalGateways: 10,
        onlineGateways: 8,
        lastSync: DateTime.now(),
      );
      
      when(() => mockMinewRepo.getStoreStats(testStoreId))
          .thenAnswer((_) async => expectedStats);

      // Act
      final result = await getMinewStatsUseCase.call(testStoreId);

      // Assert
      expect(result, equals(expectedStats));
      verify(() => mockMinewRepo.getStoreStats(testStoreId)).called(1);
    });

    test('deve lançar MinewApiException quando API falha', () async {
      // Arrange
      when(() => mockMinewRepo.getStoreStats(testStoreId))
          .thenThrow(const MinewApiException('Erro na API Minew', statusCode: 500));

      // Act & Assert
      expect(
        () => getMinewStatsUseCase.call(testStoreId),
        throwsA(isA<MinewApiException>()),
      );
    });

    test('deve lançar SyncNetworkException quando há erro de rede', () async {
      // Arrange
      when(() => mockMinewRepo.getStoreStats(testStoreId))
          .thenThrow(const SyncNetworkException('Sem conexão'));

      // Act & Assert
      expect(
        () => getMinewStatsUseCase.call(testStoreId),
        throwsA(isA<SyncNetworkException>()),
      );
    });
  });

  group('SyncMinewStoreUseCase', () {
    test('deve executar sync completo e registrar no histórico', () async {
      // Arrange
      final expectedResult = MinewSyncResult(
        success: true,
        tagsSync: SyncResult(
          success: true,
          syncType: SyncType.minewTags,
          created: 5,
          updated: 10,
          deleted: 0,
          // ignore: argument_type_not_assignable
          errors: 0,
          duration: const Duration(seconds: 3),
        ),
        gatewaysSync: SyncResult(
          success: true,
          syncType: SyncType.minewGateways,
          created: 1,
          updated: 2,
          deleted: 0,
          // ignore: argument_type_not_assignable
          errors: 0,
          duration: const Duration(seconds: 1),
        ),
      );

      when(() => mockMinewRepo.syncStoreComplete(testStoreId))
          .thenAnswer((_) async => expectedResult);
      when(() => mockHistoryRepo.addEntry(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await syncMinewStoreUseCase.call(testStoreId);

      // Assert
      expect(result.success, isTrue);
      expect(result.tagsSync?.created, equals(5));
      expect(result.tagsSync?.updated, equals(10));
      expect(result.gatewaysSync?.created, equals(1));
      
      verify(() => mockMinewRepo.syncStoreComplete(testStoreId)).called(1);
      verify(() => mockHistoryRepo.addEntry(any())).called(1);
    });

    test('deve registrar erro no histórico quando sync falha', () async {
      // Arrange
      when(() => mockMinewRepo.syncStoreComplete(testStoreId))
          .thenThrow(const MinewApiException('Timeout', statusCode: 408));
      when(() => mockHistoryRepo.addEntry(any()))
          .thenAnswer((_) async {});

      // Act & Assert
      expect(
        () => syncMinewStoreUseCase.call(testStoreId),
        throwsA(isA<MinewApiException>()),
      );
    });

    test('callback de progresso deve ser chamado', () async {
      // Arrange
      final progressValues = <double>[];
      const expectedResult = MinewSyncResult(success: true);

      when(() => mockMinewRepo.syncStoreComplete(
        testStoreId,
        onProgress: any(named: 'onProgress'),
      )).thenAnswer((invocation) async {
        final callback = invocation.namedArguments[#onProgress] as Function(double)?;
        callback?.call(0.25);
        callback?.call(0.50);
        callback?.call(0.75);
        callback?.call(1.0);
        return expectedResult;
      });
      when(() => mockHistoryRepo.addEntry(any()))
          .thenAnswer((_) async {});

      // Act
      await syncMinewStoreUseCase.call(
        testStoreId,
        onProgress: (p.toDouble Function() Function  ?? 0.0) => progressValues.add(p),
      );

      // Assert
      expect(progressValues, equals([0.25, 0.50, 0.75, 1.0]));
    });
  });

  group('SyncMinewTagsUseCase', () {
    test('deve sincronizar apenas tags', () async {
      // Arrange
      final expectedResult = SyncResult(
        success: true,
        syncType: SyncType.minewTags,
        created: 10,
        updated: 20,
        deleted: 2,
        // ignore: argument_type_not_assignable
        errors: 0,
        duration: const Duration(seconds: 5),
      );

      when(() => mockMinewRepo.syncTags(testStoreId))
          .thenAnswer((_) async => expectedResult);
      when(() => mockHistoryRepo.addEntry(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await syncMinewTagsUseCase.call(testStoreId);

      // Assert
      expect(result.success, isTrue);
      expect(result.created, equals(10));
      expect(result.updated, equals(20));
      expect(result.syncType, equals(SyncType.minewTags));
      
      verify(() => mockMinewRepo.syncTags(testStoreId)).called(1);
    });
  });

  group('ImportMinewTagsUseCase', () {
    test('deve importar novas tags do Minew Cloud', () async {
      // Arrange
      final expectedResult = SyncResult(
        success: true,
        syncType: SyncType.minewImport,
        created: 50,
        updated: 0,
        deleted: 0,
        // ignore: argument_type_not_assignable
        errors: 2,
        duration: const Duration(seconds: 10),
      );

      when(() => mockMinewRepo.importTags(testStoreId))
          .thenAnswer((_) async => expectedResult);
      when(() => mockHistoryRepo.addEntry(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await importMinewTagsUseCase.call(testStoreId);

      // Assert
      expect(result.success, isTrue);
      expect(result.created, equals(50));
      expect(result.errors, equals(2));
      expect(result.syncType, equals(SyncType.minewImport));
    });

    test('deve lançar SyncAuthException quando credenciais inválidas', () async {
      // Arrange
      when(() => mockMinewRepo.importTags(testStoreId))
          .thenThrow(const SyncAuthException('Credenciais Minew inválidas'));

      // Act & Assert
      expect(
        () => importMinewTagsUseCase.call(testStoreId),
        throwsA(isA<SyncAuthException>()),
      );
    });

    test('deve lançar SyncStoreException quando loja não configurada', () async {
      // Arrange
      when(() => mockMinewRepo.importTags(testStoreId))
          .thenThrow(const SyncStoreException('Loja não tem credenciais Minew'));

      // Act & Assert
      expect(
        () => importMinewTagsUseCase.call(testStoreId),
        throwsA(isA<SyncStoreException>()),
      );
    });
  });

  group('wrapException', () {
    test('deve converter SocketException em SyncNetworkException', () {
      // Arrange
      final socketError = Exception('SocketException');

      // Act
      final result = wrapException(socketError.toString());

      // Assert
      expect(result, isA<SyncNetworkException>());
    });

    test('deve converter TimeoutException em SyncNetworkException', () {
      // Arrange
      final timeoutError = Exception('TimeoutException');

      // Act
      final result = wrapException(timeoutError.toString());

      // Assert
      expect(result, isA<SyncNetworkException>());
    });

    test('deve converter erro 401 em SyncAuthException', () {
      // Arrange
      final authError = Exception('401 Unauthorized');

      // Act
      final result = wrapException(authError.toString());

      // Assert
      expect(result, isA<SyncAuthException>());
    });

    test('deve converter erro 403 em SyncAuthException', () {
      // Act
      final result = wrapException('Error 403: Forbidden');

      // Assert
      expect(result, isA<SyncAuthException>());
    });

    test('deve retornar SyncDataException para erros genéricos', () {
      // Act
      final result = wrapException('Unknown error occurred');

      // Assert
      expect(result, isA<SyncDataException>());
    });
  });
}
