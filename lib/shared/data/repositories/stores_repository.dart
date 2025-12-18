import 'package:tagbean/core/constants/api_constants.dart';

import 'package:tagbean/core/network/api_client.dart';

import 'package:tagbean/core/network/api_response.dart';



/// Repository para gerenciamento de lojas

/// Comunicação com StoresController do backend

class StoresRepository {

  final ApiService _apiService;



  StoresRepository({ApiService? apiService})

      : _apiService = apiService ?? ApiService();



  /// Lista todas as lojas

  /// GET /api/stores

  Future<ApiResponse<List<Map<String, dynamic>>>> getStores() async {

    return await _apiService.get<List<Map<String, dynamic>>>(

      // ignore: argument_type_not_assignable
      ApiConstants.stores,

      parser: (data) {

        if (data is List) {

          return data.map((item) => item as Map<String, dynamic>).toList();

        }

        return [];

      },

    );

  }



  /// Obtém uma loja por ID

  /// GET /api/stores/:id

  Future<ApiResponse<Map<String, dynamic>>> getStoreById(String id) async {

    return await _apiService.get<Map<String, dynamic>>(

      ApiConstants.storeById(id),

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Cria uma nova loja

  /// POST /api/stores

  Future<ApiResponse<Map<String, dynamic>>> createStore({

    required String name,

    String? address,

    String? phone,

    String? cnpj,

  }) async {

    final body = {

      'name': name,

      if (address != null) 'address': address,

      if (phone != null) 'phone': phone,

      if (cnpj != null) 'cnpj': cnpj,

    };



    return await _apiService.post<Map<String, dynamic>>(

      // ignore: argument_type_not_assignable
      ApiConstants.stores,

      body: body,

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Atualiza uma loja

  /// PUT /api/stores/:id

  Future<ApiResponse<Map<String, dynamic>>> updateStore({

    required String id,

    String? name,

    String? address,

    String? phone,

    bool? isActive,

  }) async {

    final body = <String, dynamic>{};

    if (name != null) body['name'] = name;

    if (address != null) body['address'] = address;

    if (phone != null) body['phone'] = phone;

    if (isActive != null) body['isActive'] = isActive;



    return await _apiService.put<Map<String, dynamic>>(

      ApiConstants.storeById(id),

      body: body,

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Obtém estatísticas da loja

  /// GET /api/stores/:id/stats

  Future<ApiResponse<Map<String, dynamic>>> getStoreStats(String storeId) async {

    return await _apiService.get<Map<String, dynamic>>(

      ApiConstants.stores.stats(storeId),

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Obtém estatísticas detalhadas da loja

  /// GET /api/stores/:id/statistics

  Future<ApiResponse<Map<String, dynamic>>> getStoreStatistics(String storeId) async {

    return await _apiService.get<Map<String, dynamic>>(

      ApiConstants.stores.statistics(storeId),

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Sincroniza loja inteira com a API Minew

  /// POST /api/stores/:id/sync

  Future<ApiResponse<Map<String, dynamic>>> syncStore(String storeId) async {

    return await _apiService.post<Map<String, dynamic>>(

      '/stores/$storeId/sync',

      parser: (data) => data as Map<String, dynamic>,

    );

  }



  /// Exclui uma loja

  /// DELETE /api/stores/:id

  Future<ApiResponse<void>> deleteStore(String id) async {

    return await _apiService.delete(ApiConstants.storeById(id));

  }



  /// Libera recursos

  void dispose() {

    _apiService.dispose();

  }

}







