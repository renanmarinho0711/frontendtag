import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tagbean/core/network/api_client.dart';

import 'package:tagbean/core/storage/storage_service.dart';

import 'package:tagbean/features/auth/data/models/auth_models.dart';

import 'package:tagbean/features/auth/data/models/user_model.dart';

import 'package:tagbean/features/auth/data/models/work_context_model.dart';

import 'package:tagbean/features/auth/data/repositories/auth_repository.dart';



// ============================================================================

// ESTADOS

// ============================================================================



/// Estado de autenticação

enum AuthStatus {

  initial,

  loading,

  authenticated,

  unauthenticated,

  error,

}



/// Estado completo de autenticação

class AuthState {

  final AuthStatus status;

  final UserModel? user;

  final WorkContext? workContext;

  final String? errorMessage;

  final bool isLoading;



  const AuthState({

    this.status = AuthStatus.initial,

    this.user,

    this.workContext,

    this.errorMessage,

    this.isLoading = false,

  });



  /// Estado inicial

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);



  /// Estado de loading

  factory AuthState.loading() => const AuthState(

        status: AuthStatus.loading,

        isLoading: true,

      );



  /// Estado autenticado

  factory AuthState.authenticated(UserModel user, {WorkContext? workContext}) => AuthState(

        status: AuthStatus.authenticated,

        user: user,

        workContext: workContext,

      );



  /// Estado não autenticado

  factory AuthState.unauthenticated() => const AuthState(

        status: AuthStatus.unauthenticated,

      );



  /// Estado de erro

  factory AuthState.error(String message) => AuthState(

        status: AuthStatus.error,

        errorMessage: message,

      );



  /// Verifica se está autenticado

  bool get isAuthenticated => status == AuthStatus.authenticated;



  /// Copia com modificações

  AuthState copyWith({

    AuthStatus? status,

    UserModel? user,

    WorkContext? workContext,

    String? errorMessage,

    bool? isLoading,

  }) {

    return AuthState(

      status: status ?? this.status,

      user: user ?? this.user,

      workContext: workContext ?? this.workContext,

      errorMessage: errorMessage,

      isLoading: isLoading ?? this.isLoading,

    );

  }



  @override

  String toString() {

    return 'AuthState(status: $status, user: ${user?.username}, error: $errorMessage)';

  }

}



// ============================================================================

// NOTIFIER

// ============================================================================



/// Gerenciador de estado de autenticação

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository _repository;

  final StorageService _storage;



  AuthNotifier({

    required AuthRepository repository,

    required StorageService storage,

  })  : _repository = repository,

        _storage = storage,

        super(AuthState.initial()) {

    // Verificar autenticação ao iniciar

    _checkAuthStatus();

  // ignore: dead_code
  }



  /// Verifica o status de autenticação ao iniciar

  Future<void> _checkAuthStatus() async {

    state = AuthState.loading();



    final isAuthenticated = await _storage.isAuthenticated();

    

    if (isAuthenticated) {

      // Tentar obter dados do usuário do storage

      final userId = await _storage.getUserId();

      final username = await _storage.getUsername();

      final storeId = await _storage.getStoreId();

      final roles = await _storage.getUserRoles();



      if (userId != null && username != null) {

        final user = UserModel(

          id: userId,

          username: username,

          storeId: storeId,

          isActive: true,

          roles: roles,

          createdAt: DateTime.now(),

        );

        state = AuthState.authenticated(user);

      } else {

        state = AuthState.unauthenticated();

      }

    } else {

      state = AuthState.unauthenticated();

    }

  }



  /// Realiza login

  Future<LoginResponse?> login(String username, String password) async {

    state = AuthState.loading();



    // ========================================================================

    // LOGIN FAKE PARA DESENVOLVIMENTO (sem backend)

    // ========================================================================

    const bool useFakeLogin = true; // Altere para false quando tiver backend

    

    if (useFakeLogin) {

      // Simular delay de rede

      await Future.delayed(const Duration(milliseconds: 800));

      

      // Aceitar qualquer credencial ou credenciais específicas

      if (username.isNotEmpty && password.isNotEmpty) {

        final fakeUser = UserModel(

          id: 'fake-user-001',

          username: username,

          clientId: 'client-001',

          clientName: 'TagBean Technologies',

          storeId: 'store-001',

          isActive: true,

          roles: ['PlatformAdmin', 'ClientAdmin', 'StoreManager'],

          createdAt: DateTime.now(),

        );

        

        const fakeWorkContext = WorkContext(

          scope: WorkScope.allStores,

          currentStoreId: 'store-001',

          currentStoreName: 'Loja Demo TagBean',

          clientId: 'client-001',

          clientName: 'TagBean Technologies',

          availableStores: [

            StoreInfo(id: 'store-001', name: 'Loja Demo TagBean', isActive: true),

            StoreInfo(id: 'store-002', name: 'Loja Filial 1', isActive: true),

          ],

          canSwitchScope: true,

          displayText: 'Todas as Lojas - TagBean Technologies',

        );

        

        final fakeLoginResponse = LoginResponse(

          token: 'fake-jwt-token-${DateTime.now().millisecondsSinceEpoch}',

          refreshToken: 'fake-refresh-token',

          expiresAt: DateTime.now().add(const Duration(days: 7)),

          user: fakeUser,

          workContext: fakeWorkContext,

        );

        

        // Salvar dados fake no storage

        await _storage.saveAuthData(

          accessToken: fakeLoginResponse.token,

          refreshToken: fakeLoginResponse.refreshToken,

          tokenExpiry: fakeLoginResponse.expiresAt,

          userId: fakeUser.id,

          username: fakeUser.username,

          storeId: fakeUser.storeId,

          roles: fakeUser.roles,

        );

        

        if (fakeLoginResponse.workContext != null) {

          await _storage.saveWorkContext(fakeLoginResponse.workContext!.toJson());

        }

        

        state = AuthState.authenticated(fakeUser, workContext: fakeWorkContext);

        return fakeLoginResponse;

      } else {

        state = AuthState.error('Por favor, preencha usuário e senha');

        return null;

      }

    }

    // ========================================================================

    // FIM DO LOGIN FAKE

    // ========================================================================



    final request = LoginRequest(username: username, password: password);

    final response = await _repository.login(request);



    if (response.isSuccess && response.data != null) {

      final loginData = response.data!;

      

      // Salvar dados no storage

      await _storage.saveAuthData(

        accessToken: loginData.token,

        refreshToken: loginData.refreshToken,

        tokenExpiry: loginData.expiresAt,

        userId: loginData.user.id,

        username: loginData.user.username,

        storeId: loginData.user.storeId,

        roles: loginData.user.roles,

      );



      // Salvar WorkContext se disponível

      if (loginData.workContext != null) {

        await _storage.saveWorkContext(loginData.workContext!.toJson());

      }



      state = AuthState.authenticated(

        loginData.user, 

        workContext: loginData.workContext,

      );

      return loginData;

    } else {

      state = AuthState.error(response.errorMessage ?? 'Erro ao fazer login');

      return null;

    }

  }



  /// Realiza logout

  Future<void> logout() async {

    await _storage.clearAuthData();

    state = AuthState.unauthenticated();

  }



  /// Realiza registro

  Future<bool> register(String username, String password, {String? storeId}) async {

    state = AuthState.loading();



    final request = RegisterRequest(

      username: username,

      password: password,

      storeId: storeId,

    );

    final response = await _repository.register(request);



    if (response.isSuccess && response.data != null) {

      final loginData = response.data!;

      

      // Salvar dados no storage

      await _storage.saveAuthData(

        accessToken: loginData.token,

        refreshToken: loginData.refreshToken,

        tokenExpiry: loginData.expiresAt,

        userId: loginData.user.id,

        username: loginData.user.username,

        storeId: loginData.user.storeId,

        roles: loginData.user.roles,

      );



      state = AuthState.authenticated(loginData.user);

      return true;

    } else {

      state = AuthState.error(response.errorMessage ?? 'Erro ao registrar');

      return false;

    }

  }



  /// Atualiza o token

  Future<bool> refreshToken() async {

    final currentRefreshToken = await _storage.getRefreshToken();

    

    if (currentRefreshToken == null) {

      state = AuthState.unauthenticated();

      return false;

    }



    final response = await _repository.refreshToken(currentRefreshToken);



    if (response.isSuccess && response.data != null) {

      final loginData = response.data!;

      

      await _storage.saveAuthData(

        accessToken: loginData.token,

        refreshToken: loginData.refreshToken,

        tokenExpiry: loginData.expiresAt,

        userId: loginData.user.id,

        username: loginData.user.username,

        storeId: loginData.user.storeId,

        roles: loginData.user.roles,

      );



      state = AuthState.authenticated(loginData.user);

      return true;

    } else {

      await logout();

      return false;

    }

  }



  /// Troca a senha

  Future<bool> changePassword(String currentPassword, String newPassword) async {

    if (state.user == null) return false;



    final request = ChangePasswordRequest(

      currentPassword: currentPassword,

      newPassword: newPassword,

    );



    final response = await _repository.changePassword(request);

    

    if (response.hasError) {

      state = state.copyWith(errorMessage: response.errorMessage);

      return false;

    }



    return true;

  }



  /// Solicita recuperação de senha

  Future<bool> forgotPassword(String email) async {

    state = state.copyWith(isLoading: true);



    final response = await _repository.forgotPassword(email);



    state = state.copyWith(isLoading: false);



    if (response.hasError) {

      state = state.copyWith(errorMessage: response.errorMessage);

      return false;

    }



    return true;

  }



  /// Redefine a senha usando token de recuperação

  Future<bool> resetPassword({

    required String email,

    required String token,

    required String newPassword,

  }) async {

    state = state.copyWith(isLoading: true);



    final response = await _repository.resetPassword(

      email: email,

      token: token,

      newPassword: newPassword,

    );



    state = state.copyWith(isLoading: false);



    if (response.hasError) {

      state = state.copyWith(errorMessage: response.errorMessage);

      return false;

    }



    return true;

  }



  /// Limpa mensagem de erro

  void clearError() {

    state = state.copyWith(errorMessage: null);

  }

}



// ============================================================================

// PROVIDERS

// ============================================================================



/// Provider do serviço de API

final apiServiceProvider = Provider<ApiService>((ref) {

  return ApiService();

});



/// Provider do serviço de Storage

final storageServiceProvider = Provider<StorageService>((ref) {

  return StorageService();

});



/// Provider do repositório de autenticação

final authRepositoryProvider = Provider<AuthRepository>((ref) {

  final apiService = ref.watch(apiServiceProvider);

  return AuthRepository(apiService);

});



/// Provider principal de autenticação

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final repository = ref.watch(authRepositoryProvider);

  final storage = ref.watch(storageServiceProvider);

  return AuthNotifier(repository: repository, storage: storage);

});



/// Provider do usuário atual

final currentUserProvider = Provider<UserModel?>((ref) {

  return ref.watch(authProvider).user;

});



/// Provider se está autenticado

final isLoggedInProvider = Provider<bool>((ref) {

  return ref.watch(authProvider).isAuthenticated;

});



/// Provider se está carregando

final authLoadingProvider = Provider<bool>((ref) {

  return ref.watch(authProvider).isLoading;

});



/// Provider da mensagem de erro

final authErrorProvider = Provider<String?>((ref) {

  return ref.watch(authProvider).errorMessage;

});







