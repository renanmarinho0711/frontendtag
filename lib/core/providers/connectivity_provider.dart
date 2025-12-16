import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Estado de conectividade
enum ConnectivityStatus {
  online,
  offline,
  checking,
}

/// Provider para monitorar estado de conectividade
/// 
/// Uso:
/// ```dart
/// final isOnline = ref.watch(connectivityProvider);
/// 
/// if (!isOnline)
///   OfflineBanner(...)
/// ```
final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});

/// Provider com status detalhado de conectividade
final connectivityStatusProvider = StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>((ref) {
  return ConnectivityStatusNotifier();
});

/// Notifier para estado de conectividade (simples: true/false)
class ConnectivityNotifier extends StateNotifier<bool> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityNotifier() : super(true) {
    _checkConnectivity();
    _startListening();
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      state = _isConnected(result);
    } catch (e) {
      // Em caso de erro, assume online para não bloquear UX
      state = true;
      debugPrint('Erro ao verificar conectividade: $e');
    }
  }

  void _startListening() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      state = _isConnected(result);
    });
  }

  bool _isConnected(List<ConnectivityResult> result) {
    return result.isNotEmpty && 
           !result.contains(ConnectivityResult.none);
  }

  /// Força uma nova verificação de conectividade
  Future<void> refresh() async {
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Notifier para estado de conectividade (detalhado)
class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.checking) {
    _checkConnectivity();
    _startListening();
  }

  Future<void> _checkConnectivity() async {
    state = ConnectivityStatus.checking;
    try {
      final result = await Connectivity().checkConnectivity();
      state = _getStatus(result);
    } catch (e) {
      state = ConnectivityStatus.online;
      debugPrint('Erro ao verificar conectividade: $e');
    }
  }

  void _startListening() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      state = _getStatus(result);
    });
  }

  ConnectivityStatus _getStatus(List<ConnectivityResult> result) {
    if (result.isEmpty || result.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }
    return ConnectivityStatus.online;
  }

  /// Força uma nova verificação de conectividade
  Future<void> refresh() async {
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Extension para facilitar uso do estado de conectividade
extension ConnectivityStatusX on ConnectivityStatus {
  bool get isOnline => this == ConnectivityStatus.online;
  bool get isOffline => this == ConnectivityStatus.offline;
  bool get isChecking => this == ConnectivityStatus.checking;
}



