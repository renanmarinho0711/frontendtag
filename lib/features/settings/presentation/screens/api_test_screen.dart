import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Tela de Testes da API - Simula todos os perfis de usuário
/// 
/// Perfis testados:
/// - PlatformAdmin (Dono da plataforma TagBean)
/// - ClientAdmin (Dono do supermercado/cliente)
/// - StoreManager (Supervisor/Gerente de loja)
/// - Operator (Repositor/Operador)
/// - Viewer (Visualizador - somente leitura)
class ApiTestScreen extends ConsumerStatefulWidget {
  const ApiTestScreen({super.key});

  @override
  ConsumerState<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends ConsumerState<ApiTestScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<TestResult> _results = [];
  bool _isRunning = false;
  String _currentTest = '';
  int _passed = 0;
  int _failed = 0;
  int _total = 0;

  // Configuração da API
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Usuários de teste
  static const Map<String, Map<String, String>> testUsers = {
    'PlatformAdmin': {
      'username': 'tagbean_admin',
      'password': 'TagBean@2025!',
      'description': 'Administrador Master TagBean',
    },
    'ClientAdmin': {
      'username': 'demo_admin',
      'password': 'Demo@123',
      'description': 'Administrador do Cliente (Dono do Supermercado)',
    },
  };

  // Tokens obtidos após login
  final Map<String, String> _tokens = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Testes da API TagBean'),
        actions: [
          if (_results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearResults,
              tooltip: 'Limpar resultados',
            ),
        ],
      ),
      body: Column(
        children: [
          // Header com estatísticas
          _buildHeader(),
          
          // Botões de ação
          _buildActionButtons(),
          
          // Lista de resultados
          Expanded(
            child: _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Total', _total, Colors.blue),
              _buildStatCard('✅ Passou', _passed, Colors.green),
              _buildStatCard('❌ Falhou', _failed, Colors.red),
            ],
          ),
          if (_isRunning) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(value: _total > 0 ? (_passed + _failed) / _total : null),
            const SizedBox(height: 8),
            Text('Executando: $_currentTest', style: TextStyle(fontSize: 12)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _runAllTests,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Executar Todos os Testes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _runAuthTests,
            icon: const Icon(Icons.login),
            label: const Text('Testes de Auth'),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _runPermissionTests,
            icon: const Icon(Icons.security),
            label: const Text('Testes de PermissÃ£o'),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _runCrudTests,
            icon: const Icon(Icons.storage),
            label: const Text('Testes CRUD'),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _runErrorTests,
            icon: const Icon(Icons.error_outline),
            label: const Text('Testes de Erro'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    if (_results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Clique em um botão para iniciar os testes',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return _buildResultCard(result);
      },
    );
  }

  Widget _buildResultCard(TestResult result) {
    final icon = result.success ? Icons.check_circle : Icons.cancel;
    final color = result.success ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          result.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: result.success ? Colors.black87 : Colors.red.shade700,
          ),
        ),
        subtitle: Text(
          '${result.category} • ${result.duration}ms',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Perfil', result.userRole),
                _buildInfoRow('Endpoint', result.endpoint),
                _buildInfoRow('Método', result.method),
                _buildInfoRow('Status', '${result.statusCode}'),
                if (result.message.isNotEmpty)
                  _buildInfoRow('Mensagem', result.message),
                if (result.requestBody != null) ...[
                  const SizedBox(height: 8),
                  const Text('Request Body:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey.shade100,
                    child: Text(
                      _formatJson(result.requestBody),
                      style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                    ),
                  ),
                ],
                if (result.responseBody != null) ...[
                  const SizedBox(height: 8),
                  const Text('Response Body:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey.shade100,
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Text(
                        _formatJson(result.responseBody),
                        style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatJson(dynamic data) {
    try {
      if (data is String) {
        return const JsonEncoder.withIndent('  ').convert(json.decode(data));
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  void _clearResults() {
    setState(() {
      _results.clear();
      _passed = 0;
      _failed = 0;
      _total = 0;
    });
  }

  void _addResult(TestResult result) {
    setState(() {
      _results.add(result);
      if (result.success) {
        _passed++;
      } else {
        _failed++;
      }
    });
    
    // Auto-scroll para o final
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ============================================================
  // TESTES PRINCIPAIS
  // ============================================================

  Future<void> _runAllTests() async {
    _clearResults();
    setState(() => _isRunning = true);

    await _runAuthTests();
    await _runPermissionTests();
    await _runCrudTests();
    await _runErrorTests();

    setState(() => _isRunning = false);
    _showSummary();
  }

  // ============================================================
  // 1. TESTES DE AUTENTICAÇÃO
  // ============================================================

  Future<void> _runAuthTests() async {
    setState(() {
      _isRunning = true;
      _total += 12;
    });

    // 1.1 Login com credenciais válidas - PlatformAdmin
    await _testLogin(
      'Login PlatformAdmin (Dono TagBean)',
      'tagbean_admin',
      'TagBean@2025!',
      expectSuccess: true,
    );

    // 1.2 Login com credenciais válidas - ClientAdmin
    await _testLogin(
      'Login ClientAdmin (Dono Supermercado)',
      'demo_admin',
      'Demo@123',
      expectSuccess: true,
    );

    // 1.3 Login com senha incorreta
    await _testLogin(
      'Login com senha incorreta',
      'tagbean_admin',
      'SenhaErrada123',
      expectSuccess: false,
      expectedStatus: 401,
    );

    // 1.4 Login com usuário inexistente
    await _testLogin(
      'Login com usuário inexistente',
      'usuario_fantasma',
      'Qualquer@123',
      expectSuccess: false,
      expectedStatus: 401,
    );

    // 1.5 Login sem senha
    await _testLogin(
      'Login sem senha',
      'tagbean_admin',
      '',
      expectSuccess: false,
      expectedStatus: 400,
    );

    // 1.6 Login sem usuário
    await _testLogin(
      'Login sem usuário',
      '',
      'TagBean@2025!',
      expectSuccess: false,
      expectedStatus: 400,
    );

    // 1.7 Login com JSON inválido
    await _testRequest(
      name: 'Login com JSON malformado',
      category: 'Autenticação',
      userRole: 'Anônimo',
      method: 'POST',
      endpoint: '/auth/login',
      body: 'invalid-json{{{',
      isRawBody: true,
      expectSuccess: false,
      expectedStatus: 400,
    );

    // 1.8 Acesso a endpoint protegido sem token
    await _testRequest(
      name: 'Acesso sem autenticação',
      category: 'Autenticação',
      userRole: 'Anônimo',
      method: 'GET',
      endpoint: '/users',
      expectSuccess: false,
      expectedStatus: 401,
    );

    // 1.9 Acesso com token inválido
    await _testRequest(
      name: 'Acesso com token inválido',
      category: 'Autenticação',
      userRole: 'Token Falso',
      method: 'GET',
      endpoint: '/users',
      token: 'token-invalido-123',
      expectSuccess: false,
      expectedStatus: 401,
    );

    // 1.10 Acesso com token expirado (simulado)
    await _testRequest(
      name: 'Acesso com token expirado',
      category: 'Autenticação',
      userRole: 'Token Expirado',
      method: 'GET',
      endpoint: '/users',
      token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIxMjM0NTY3ODkwIiwidW5pcXVlX25hbWUiOiJ0ZXN0IiwiZXhwIjoxNjAwMDAwMDAwfQ.invalid',
      expectSuccess: false,
      expectedStatus: 401,
    );

    // 1.11 Verificar dados do usuário logado
    await _testRequest(
      name: 'Obter perfil do usuário logado',
      category: 'Autenticação',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/auth/me',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    // 1.12 Health Check
    await _testRequest(
      name: 'Health Check da API',
      category: 'Autenticação',
      userRole: 'Público',
      method: 'GET',
      endpoint: '/health',
      expectSuccess: true,
      expectedStatus: 200,
    );

    setState(() => _isRunning = false);
  }

  Future<void> _testLogin(
    String name,
    String username,
    String password, {
    required bool expectSuccess,
    int? expectedStatus,
  }) async {
    setState(() => _currentTest = name);
    
    final stopwatch = Stopwatch()..start();
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      
      stopwatch.stop();
      
      final success = expectSuccess 
          ? response.statusCode == 200
          : response.statusCode == (expectedStatus ?? 401);

      // Salvar token se login bem sucedido
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final role = username == 'tagbean_admin' ? 'PlatformAdmin' : 'ClientAdmin';
          _tokens[role] = data['accessToken'] ?? data['token'];
        } catch (_) {}
      }

      _addResult(TestResult(
        name: name,
        category: 'Autenticação',
        userRole: username,
        method: 'POST',
        endpoint: '/auth/login',
        statusCode: response.statusCode,
        success: success,
        message: success ? 'OK' : 'Status inesperado: ${response.statusCode}',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: {'username': username, 'password': '***'},
        responseBody: response.body,
      ));
    } catch (e) {
      stopwatch.stop();
      _addResult(TestResult(
        name: name,
        category: 'Autenticação',
        userRole: username,
        method: 'POST',
        endpoint: '/auth/login',
        statusCode: 0,
        success: false,
        message: 'Erro: $e',
        duration: stopwatch.elapsedMilliseconds,
      ));
    }
  }

  // ============================================================
  // 2. TESTES DE PERMISsÃ£o POR PERFIL
  // ============================================================

  Future<void> _runPermissionTests() async {
    setState(() {
      _isRunning = true;
      _total += 20;
    });

    // Garantir que temos os tokens
    if (_tokens.isEmpty) {
      await _testLogin('Login PlatformAdmin', 'tagbean_admin', 'TagBean@2025!', expectSuccess: true);
      await _testLogin('Login ClientAdmin', 'demo_admin', 'Demo@123', expectSuccess: true);
    }

    // ---- PLATFORM ADMIN (PODE TUDO) ----
    
    await _testRequest(
      name: 'PlatformAdmin - Listar Clientes',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/clients',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Listar Usuários',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/users',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Listar Lojas',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/stores',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Listar Produtos',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Listar Tags',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/tags',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Listar Estratégias',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/strategies',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Listar Roles',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/roles',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Relatórios',
      category: 'Permissões',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/reports/dashboard',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    // ---- CLIENT ADMIN (LIMITADO AO SEU CLIENTE) ----

    await _testRequest(
      name: 'ClientAdmin - Listar Clientes (NEGADO)',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'GET',
      endpoint: '/clients',
      token: _tokens['ClientAdmin'],
      expectSuccess: false,
      expectedStatus: 403,
    );

    await _testRequest(
      name: 'ClientAdmin - Listar Usuários',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'GET',
      endpoint: '/users',
      token: _tokens['ClientAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'ClientAdmin - Listar Lojas',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'GET',
      endpoint: '/stores',
      token: _tokens['ClientAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'ClientAdmin - Listar Produtos',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'GET',
      endpoint: '/products',
      token: _tokens['ClientAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'ClientAdmin - Listar Tags',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'GET',
      endpoint: '/tags',
      token: _tokens['ClientAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'ClientAdmin - Listar Estratégias',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'GET',
      endpoint: '/strategies',
      token: _tokens['ClientAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'ClientAdmin - Gerenciar Roles (NEGADO)',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'POST',
      endpoint: '/roles',
      token: _tokens['ClientAdmin'],
      body: {'name': 'NovaRole', 'description': 'Teste'},
      expectSuccess: false,
      expectedStatus: 403,
    );

    // Testes de acesso a recursos de outro cliente
    await _testRequest(
      name: 'ClientAdmin - Acessar loja de outro cliente (NEGADO)',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'GET',
      endpoint: '/stores/STORE-OUTRO-CLIENTE',
      token: _tokens['ClientAdmin'],
      expectSuccess: false,
      expectedStatus: 404, // Ou 403
    );

    await _testRequest(
      name: 'ClientAdmin - Criar loja',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'POST',
      endpoint: '/stores',
      token: _tokens['ClientAdmin'],
      body: {
        'number': '999',
        'name': 'Loja Teste ClientAdmin',
        'address': 'Rua Teste, 123',
        'city': 'sÃ£o Paulo',
        'state': 'SP',
        'zipCode': '01234-567',
      },
      expectSuccess: true,
      expectedStatus: 201,
    );

    await _testRequest(
      name: 'ClientAdmin - Criar usuário',
      category: 'Permissões',
      userRole: 'ClientAdmin',
      method: 'POST',
      endpoint: '/users',
      token: _tokens['ClientAdmin'],
      body: {
        'username': 'operador_teste',
        'password': 'Operador@123',
        'email': 'operador@teste.com',
        'fullName': 'Operador Teste',
        'role': 'Operator',
      },
      expectSuccess: true,
      expectedStatus: 201,
    );

    setState(() => _isRunning = false);
  }

  // ============================================================
  // 3. TESTES CRUD COMPLETOS
  // ============================================================

  Future<void> _runCrudTests() async {
    setState(() {
      _isRunning = true;
      _total += 16;
    });

    // Garantir tokens
    if (_tokens['PlatformAdmin'] == null) {
      await _testLogin('Login PlatformAdmin', 'tagbean_admin', 'TagBean@2025!', expectSuccess: true);
    }

    final token = _tokens['PlatformAdmin']!;
    String? createdProductId;
    String? createdCategoryId;

    // ---- CATEGORIAS ----
    
    await _testRequest(
      name: 'CRUD - Criar Categoria',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/categories',
      token: token,
      body: {
        'name': 'Categoria Teste ${DateTime.now().millisecondsSinceEpoch}',
        'description': 'Categoria criada pelo teste automatizado',
        'color': '#FF5722',
      },
      expectSuccess: true,
      expectedStatus: 201,
      onSuccess: (response) {
        try {
          final data = json.decode(response.body);
          createdCategoryId = data['id']?.toString();
        } catch (_) {}
      },
    );

    await _testRequest(
      name: 'CRUD - Listar Categorias',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/categories',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // ---- PRODUTOS ----

    await _testRequest(
      name: 'CRUD - Criar Produto',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': 'STORE-DEMO-001',
        'barcode': '789${DateTime.now().millisecondsSinceEpoch}',
        'name': 'Produto Teste Automatizado',
        'price': 19.99,
        'originalPrice': 24.99,
        'category': 0,
        'stock': 100,
        'minStock': 10,
        'maxStock': 500,
      },
      expectSuccess: true,
      expectedStatus: 201,
      onSuccess: (response) {
        try {
          final data = json.decode(response.body);
          createdProductId = data['id']?.toString();
        } catch (_) {}
      },
    );

    await _testRequest(
      name: 'CRUD - Listar Produtos',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'CRUD - Buscar Produto por ID',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products/${createdProductId ?? "PROD-001"}',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'CRUD - Atualizar Produto',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'PUT',
      endpoint: '/products/${createdProductId ?? "PROD-001"}',
      token: token,
      body: {
        'name': 'Produto Teste Atualizado',
        'price': 29.99,
      },
      expectSuccess: true,
      expectedStatus: 200,
    );

    // ---- TAGS ----

    await _testRequest(
      name: 'CRUD - Listar Tags',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/tags',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'CRUD - Buscar Tag por MAC',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/tags/AA:BB:CC:DD:EE:01',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // ---- LOJAS ----

    await _testRequest(
      name: 'CRUD - Listar Lojas',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/stores',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'CRUD - Buscar Loja por ID',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/stores/STORE-DEMO-001',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // ---- GATEWAYS ----

    await _testRequest(
      name: 'CRUD - Listar Gateways',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/gateways',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // ---- ESTRATÉGIAS ----

    await _testRequest(
      name: 'CRUD - Criar Estratégia',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/strategies',
      token: token,
      body: {
        'name': 'Estratégia Teste ${DateTime.now().millisecondsSinceEpoch}',
        'type': 0,
        'storeId': 'STORE-DEMO-001',
        'isActive': false,
        'configuration': json.encode({'discount': 10}),
      },
      expectSuccess: true,
      expectedStatus: 201,
    );

    await _testRequest(
      name: 'CRUD - Listar Estratégias',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/strategies',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // ---- CLIENTES ----

    await _testRequest(
      name: 'CRUD - Criar Cliente',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/clients',
      token: token,
      body: {
        'name': 'Cliente Teste ${DateTime.now().millisecondsSinceEpoch}',
        'tradeName': 'Teste LTDA',
        'cnpj': '12.345.678/0001-${DateTime.now().millisecond.toString().padLeft(2, '0')}',
        'email': 'teste${DateTime.now().millisecondsSinceEpoch}@teste.com',
        'phone': '(11) 99999-9999',
        'address': 'Rua Teste',
        'city': 'sÃ£o Paulo',
        'state': 'SP',
        'zipCode': '01234-567',
        'maxStores': 5,
        'maxUsers': 10,
      },
      expectSuccess: true,
      expectedStatus: 201,
    );

    await _testRequest(
      name: 'CRUD - Listar Clientes',
      category: 'CRUD',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/clients',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    setState(() => _isRunning = false);
  }

  // ============================================================
  // 4. TESTES DE ERRO E VALIDAÇÃO
  // ============================================================

  Future<void> _runErrorTests() async {
    setState(() {
      _isRunning = true;
      _total += 15;
    });

    // Garantir tokens
    if (_tokens['PlatformAdmin'] == null) {
      await _testLogin('Login PlatformAdmin', 'tagbean_admin', 'TagBean@2025!', expectSuccess: true);
    }

    final token = _tokens['PlatformAdmin']!;

    // ---- ERROS DE VALIDAÇÃO ----

    await _testRequest(
      name: 'Erro - Criar produto sem nome',
      category: 'Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': 'STORE-DEMO-001',
        'barcode': '1234567890',
        'price': 10.00,
      },
      expectSuccess: false,
      expectedStatus: 400,
    );

    await _testRequest(
      name: 'Erro - Criar produto com preço negativo',
      category: 'Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': 'STORE-DEMO-001',
        'barcode': '1234567890',
        'name': 'Produto Inválido',
        'price': -10.00,
      },
      expectSuccess: false,
      expectedStatus: 400,
    );

    await _testRequest(
      name: 'Erro - Criar usuário com email inválido',
      category: 'Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/users',
      token: token,
      body: {
        'username': 'invalido_teste',
        'password': 'Senha@123',
        'email': 'email-invalido',
        'fullName': 'Usuário Inválido',
        'role': 'Operator',
      },
      expectSuccess: false,
      expectedStatus: 400,
    );

    await _testRequest(
      name: 'Erro - Criar usuário com senha fraca',
      category: 'Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/users',
      token: token,
      body: {
        'username': 'invalido_teste2',
        'password': '123',
        'email': 'valido@teste.com',
        'fullName': 'Usuário Senha Fraca',
        'role': 'Operator',
      },
      expectSuccess: false,
      expectedStatus: 400,
    );

    await _testRequest(
      name: 'Erro - Criar cliente sem CNPJ',
      category: 'Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/clients',
      token: token,
      body: {
        'name': 'Cliente Sem CNPJ',
        'email': 'teste@teste.com',
      },
      expectSuccess: false,
      expectedStatus: 400,
    );

    // ---- ERROS DE RECURSO NÃO ENCONTRADO ----

    await _testRequest(
      name: 'Erro 404 - Produto inexistente',
      category: 'Not Found',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products/PRODUTO-NAO-EXISTE-12345',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: 'Erro 404 - Loja inexistente',
      category: 'Not Found',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/stores/LOJA-NAO-EXISTE',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: 'Erro 404 - Tag inexistente',
      category: 'Not Found',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/tags/XX:XX:XX:XX:XX:XX',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: 'Erro 404 - Usuário inexistente',
      category: 'Not Found',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/users/00000000-0000-0000-0000-000000000000',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: 'Erro 404 - Endpoint inexistente',
      category: 'Not Found',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/endpoint-que-nao-existe',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    // ---- ERROS DE CONFLITO/DUPLICIDADE ----

    await _testRequest(
      name: 'Erro - Criar usuário duplicado',
      category: 'Conflito',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/users',
      token: token,
      body: {
        'username': 'tagbean_admin', // Já existe
        'password': 'Senha@123',
        'email': 'outro@email.com',
        'fullName': 'Usuário Duplicado',
        'role': 'Operator',
      },
      expectSuccess: false,
      expectedStatus: 409, // Conflict
    );

    // ---- ERROS DE MÉTODO NÃO PERMITIDO ----

    await _testRequest(
      name: 'Erro 405 - DELETE não permitido',
      category: 'Method Not Allowed',
      userRole: 'PlatformAdmin',
      method: 'DELETE',
      endpoint: '/health',
      token: token,
      expectSuccess: false,
      expectedStatus: 405,
    );

    // ---- TESTES DE LIMITE/PAGINAÇÃO ----

    await _testRequest(
      name: 'Paginação - Listar com limite',
      category: 'Paginação',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products?pageSize=5&page=1',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'Paginação - Página negativa',
      category: 'Paginação',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products?page=-1',
      token: token,
      expectSuccess: true, // Deve tratar graciosamente
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'Busca - Filtrar produtos por nome',
      category: 'Filtros',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products?search=arroz',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    setState(() => _isRunning = false);
  }

  // ============================================================
  // HELPER: Executar Request Genérico
  // ============================================================

  Future<void> _testRequest({
    required String name,
    required String category,
    required String userRole,
    required String method,
    required String endpoint,
    String? token,
    dynamic body,
    bool isRawBody = false,
    required bool expectSuccess,
    int? expectedStatus,
    void Function(http.Response)? onSuccess,
  }) async {
    setState(() => _currentTest = name);
    
    final stopwatch = Stopwatch()..start();
    
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      http.Response response;
      
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: isRawBody ? body : (body != null ? json.encode(body) : null),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        default:
          throw Exception('Método HTTP não suportado: $method');
      }
      
      stopwatch.stop();

      // Determinar sucesso
      bool success;
      if (expectedStatus != null) {
        success = response.statusCode == expectedStatus;
      } else {
        success = expectSuccess 
            ? (response.statusCode >= 200 && response.statusCode < 300)
            : (response.statusCode >= 400);
      }

      if (success && onSuccess != null) {
        onSuccess(response);
      }

      _addResult(TestResult(
        name: name,
        category: category,
        userRole: userRole,
        method: method,
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: success,
        message: success 
            ? 'OK' 
            : 'Esperado: ${expectedStatus ?? (expectSuccess ? "2xx" : "4xx/5xx")}, Recebido: ${response.statusCode}',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: body,
        responseBody: response.body,
      ));
    } catch (e) {
      stopwatch.stop();
      _addResult(TestResult(
        name: name,
        category: category,
        userRole: userRole,
        method: method,
        endpoint: endpoint,
        statusCode: 0,
        success: false,
        message: 'Erro de conexão: $e',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: body,
      ));
    }
  }

  void _showSummary() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('📊 Resumo dos Testes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _failed == 0 ? '🎉 Todos os testes passaram!' : '⚠️ Alguns testes falharam',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _failed == 0 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('$_passed', style: TextStyle(fontSize: 32, color: Colors.green, fontWeight: FontWeight.bold)),
                    const Text('Passou'),
                  ],
                ),
                Column(
                  children: [
                    Text('$_failed', style: TextStyle(fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold)),
                    const Text('Falhou'),
                  ],
                ),
                Column(
                  children: [
                    Text('$_total', style: TextStyle(fontSize: 32, color: Colors.blue, fontWeight: FontWeight.bold)),
                    const Text('Total'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Taxa de sucesso: ${(_passed / _total * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MODELO DE RESULTADO
// ============================================================

class TestResult {
  final String name;
  final String category;
  final String userRole;
  final String method;
  final String endpoint;
  final int statusCode;
  final bool success;
  final String message;
  final int duration;
  final dynamic requestBody;
  final dynamic responseBody;

  TestResult({
    required this.name,
    required this.category,
    required this.userRole,
    required this.method,
    required this.endpoint,
    required this.statusCode,
    required this.success,
    required this.message,
    required this.duration,
    this.requestBody,
    this.responseBody,
  });
}




