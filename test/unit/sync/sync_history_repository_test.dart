import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/features/sync/data/repositories/sync_history_repository.dart';
import 'package:tagbean/features/sync/data/models/sync_models.dart';

void main() {
  late SyncHistoryRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = SyncHistoryRepository();
  });

  group('SyncHistoryRepository', () {
    test('deve iniciar com histórico vazio', () async {
      // Act
      final history = await repository.getHistory();

      // Assert
      expect(history, isEmpty);
    });

    test('deve adicionar entrada ao histórico', () async {
      // Arrange
      final entry = SyncHistoryEntry(
        id: '1',
        type: SyncType.tags,
        startedAt: DateTime.now(),
        completedAt: DateTime.now().add(const Duration(seconds: 5)),
        status: SyncStatus.success,
        tagsCount: 100,
        successCount: 95,
        errorCount: 5,
      );

      // Act
      await repository.addEntry(entry);
      final history = await repository.getHistory();

      // Assert
      expect(history.length, equals(1));
      expect(history.first.id, equals('1'));
      expect(history.first.type, equals(SyncType.tags));
      expect(history.first.status, equals(SyncStatus.success));
    });

    test('deve limitar histórico a 100 entradas', () async {
      // Arrange - Adiciona 105 entradas
      for (int i = 0; i < 105; i++) {
        final entry = SyncHistoryEntry(
          id: 'entry_$i',
          type: SyncType.tags,
          startedAt: DateTime.now(),
          status: SyncStatus.success,
          tagsCount: i,
        );
        await repository.addEntry(entry);
      }

      // Act
      final history = await repository.getHistory();

      // Assert
      expect(history.length, lessThanOrEqualTo(100));
    });

    test('deve atualizar entrada existente', () async {
      // Arrange
      final startTime = DateTime.now();
      final entry = SyncHistoryEntry(
        id: 'update_test',
        type: SyncType.tags,
        startedAt: startTime,
        status: SyncStatus.running,
        tagsCount: 0,
      );
      await repository.addEntry(entry);

      // Act - Atualiza a entrada
      final completedTime = startTime.add(const Duration(seconds: 10));
      final updatedEntry = entry.copyWith(
        status: SyncStatus.success,
        completedAt: completedTime,
        tagsCount: 50,
        successCount: 48,
        errorCount: 2,
      );
      await repository.updateEntry(updatedEntry);
      final history = await repository.getHistory();

      // Assert
      final found = history.firstWhere((e) => e.id == 'update_test');
      expect(found.status, equals(SyncStatus.success));
      expect(found.tagsCount, equals(50));
      expect(found.successCount, equals(48));
    });

    test('deve limpar todo o histórico', () async {
      // Arrange
      for (int i = 0; i < 5; i++) {
        await repository.addEntry(SyncHistoryEntry(
          id: 'clear_$i',
          type: SyncType.tags,
          startedAt: DateTime.now(),
          status: SyncStatus.success,
        ));
      }

      // Act
      await repository.clearHistory();
      final history = await repository.getHistory();

      // Assert
      expect(history, isEmpty);
    });

    test('deve retornar estatísticas corretas', () async {
      // Arrange
      final now = DateTime.now();
      
      // Adiciona entradas de sucesso
      for (int i = 0; i < 3; i++) {
        await repository.addEntry(SyncHistoryEntry(
          id: 'success_$i',
          type: SyncType.tags,
          startedAt: now.subtract(Duration(hours: i)),
          completedAt: now.subtract(Duration(hours: i)).add(const Duration(seconds: 30)),
          status: SyncStatus.success,
          tagsCount: 100,
          successCount: 100,
        ));
      }

      // Adiciona entrada com erro
      await repository.addEntry(SyncHistoryEntry(
        id: 'error_1',
        type: SyncType.tags,
        startedAt: now.subtract(const Duration(hours: 4)),
        completedAt: now.subtract(const Duration(hours: 4)).add(const Duration(seconds: 10)),
        status: SyncStatus.failed,
        tagsCount: 50,
        errorCount: 50,
        errorMessage: 'Timeout',
      ));

      // Act
      final stats = await repository.getStats();

      // Assert
      expect(stats['totalSyncs'], equals(4));
      expect(stats['successfulSyncs'], equals(3));
      expect(stats['failedSyncs'], equals(1));
    });

    test('deve ordenar histórico por data decrescente', () async {
      // Arrange
      final now = DateTime.now();
      
      await repository.addEntry(SyncHistoryEntry(
        id: 'old',
        type: SyncType.tags,
        startedAt: now.subtract(const Duration(days: 2)),
        status: SyncStatus.success,
      ));
      
      await repository.addEntry(SyncHistoryEntry(
        id: 'new',
        type: SyncType.tags,
        startedAt: now,
        status: SyncStatus.success,
      ));
      
      await repository.addEntry(SyncHistoryEntry(
        id: 'middle',
        type: SyncType.tags,
        startedAt: now.subtract(const Duration(days: 1)),
        status: SyncStatus.success,
      ));

      // Act
      final history = await repository.getHistory();

      // Assert
      expect(history[0].id, equals('new'));
      expect(history[1].id, equals('middle'));
      expect(history[2].id, equals('old'));
    });

    test('deve retornar última sincronização', () async {
      // Arrange
      final now = DateTime.now();
      
      await repository.addEntry(SyncHistoryEntry(
        id: 'last_success',
        type: SyncType.tags,
        startedAt: now,
        status: SyncStatus.success,
      ));

      // Act
      final lastSync = await repository.getLastSync();

      // Assert
      expect(lastSync, isNotNull);
      expect(lastSync!.id, equals('last_success'));
    });
  });

  group('Race Condition Prevention', () {
    test('múltiplas chamadas simultâneas devem ser seguras', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final repo = SyncHistoryRepository();

      // Act - Múltiplas chamadas simultâneas
      final futures = List.generate(10, (_) => repo.getHistory());
      final results = await Future.wait(futures);

      // Assert - Todas devem retornar sem erro
      expect(results.length, equals(10));
      for (final result in results) {
        expect(result, isA<List<SyncHistoryEntry>>());
      }
    });

    test('inicialização concorrente não deve causar duplicação', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final repo = SyncHistoryRepository();

      // Act - Adiciona enquanto inicializa
      final addFutures = <Future<void>>[];
      for (int i = 0; i < 5; i++) {
        addFutures.add(repo.addEntry(SyncHistoryEntry(
          id: 'concurrent_$i',
          type: SyncType.tags,
          startedAt: DateTime.now(),
          status: SyncStatus.success,
        )));
      }
      await Future.wait(addFutures);
      
      final history = await repo.getHistory();

      // Assert
      expect(history.length, equals(5));
    });
  });

  group('SyncHistoryEntry copyWith validation', () {
    test('deve lançar erro se completedAt for antes de startedAt', () {
      // Arrange
      final startTime = DateTime.now();
      final entry = SyncHistoryEntry(
        id: 'test',
        type: SyncType.tags,
        startedAt: startTime,
        status: SyncStatus.running,
      );

      // Act & Assert
      expect(
        () => entry.copyWith(
          completedAt: startTime.subtract(const Duration(hours: 1)),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('deve permitir copyWith quando completedAt é depois de startedAt', () {
      // Arrange
      final startTime = DateTime.now();
      final entry = SyncHistoryEntry(
        id: 'test',
        type: SyncType.tags,
        startedAt: startTime,
        status: SyncStatus.running,
      );

      // Act
      final updated = entry.copyWith(
        completedAt: startTime.add(const Duration(hours: 1)),
        status: SyncStatus.success,
      );

      // Assert
      expect(updated.completedAt, isNotNull);
      expect(updated.status, equals(SyncStatus.success));
    });

    test('deve permitir copyWith sem completedAt', () {
      // Arrange
      final entry = SyncHistoryEntry(
        id: 'test',
        type: SyncType.tags,
        startedAt: DateTime.now(),
        status: SyncStatus.running,
      );

      // Act
      final updated = entry.copyWith(
        status: SyncStatus.cancelled,
      );

      // Assert
      expect(updated.status, equals(SyncStatus.cancelled));
      expect(updated.completedAt, isNull);
    });

    test('deve permitir alterar startedAt se completedAt ainda for válido', () {
      // Arrange
      final now = DateTime.now();
      final entry = SyncHistoryEntry(
        id: 'test',
        type: SyncType.tags,
        startedAt: now,
        completedAt: now.add(const Duration(hours: 2)),
        status: SyncStatus.success,
      );

      // Act - Mover startedAt 30 minutos antes (ainda válido)
      final updated = entry.copyWith(
        startedAt: now.subtract(const Duration(minutes: 30)),
      );

      // Assert
      expect(updated.startedAt, equals(now.subtract(const Duration(minutes: 30))));
    });

    test('deve lançar erro ao mover startedAt para depois de completedAt', () {
      // Arrange
      final now = DateTime.now();
      final entry = SyncHistoryEntry(
        id: 'test',
        type: SyncType.tags,
        startedAt: now,
        completedAt: now.add(const Duration(hours: 1)),
        status: SyncStatus.success,
      );

      // Act & Assert - Mover startedAt para depois de completedAt
      expect(
        () => entry.copyWith(
          startedAt: now.add(const Duration(hours: 2)),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
