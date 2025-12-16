import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Tela de Testes Completos - Simula TODOS os perfis de usuário
/// 
/// Este teste cria usuários de teste para cada perfil e executa
/// operações simulando cenários reais de uso:
/// 
/// - PlatformAdmin: Dono da TagBean (acesso total)
/// - ClientAdmin: Dono do supermercado (acesso ao seu cliente)
/// - StoreManager: Gerente/Supervisor de loja
/// - Operator: Repositor/Operador de loja
/// - Viewer: Visualizador (somente leitura)
class FullApiTestScreen extends ConsumerStatefulWidget {
  const FullApiTestScreen({super.key});

  @override
  ConsumerState<FullApiTestScreen> createState() => _FullApiTestScreenState();
}

class _FullApiTestScreenState extends ConsumerState<FullApiTestScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<TestResult> _results = [];
  bool _isRunning = false;
  String _currentTest = '';
  String _currentPhase = '';
  int _passed = 0;
  int _failed = 0;
  int _total = 0;
  double _progress = 0;

  // Configuração
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Tokens e IDs criados durante os testes
  final Map<String, String> _tokens = {};
  final Map<String, String> _userIds = {};
  String? _testClientId;
  String? _testStoreId;
  String? _testProductId;

  // Credenciais base
  static const Map<String, Map<String, String>> baseUsers = {
    'PlatformAdmin': {
      'username': 'tagbean_admin',
      'password': 'TagBean@2025!',
    },
    'ClientAdmin': {
      'username': 'demo_admin',
      'password': 'Demo@123',
    },
  };

  // Usuários de teste que serão criados
  final Map<String, Map<String, String>> testUsers = {
    'StoreManager': {
      'username': 'gerente_teste',
      'password': 'Gerente@123',
      'email': 'gerente@teste.com',
      'fullName': 'Gerente de Teste',
      'role': 'StoreManager',
    },
    'Operator': {
      'username': 'operador_teste',
      'password': 'Operador@123',
      'email': 'operador@teste.com',
      'fullName': 'Operador de Teste',
      'role': 'Operator',
    },
    'Viewer': {
      'username': 'viewer_teste',
      'password': 'Viewer@123',
      'email': 'viewer@teste.com',
      'fullName': 'Visualizador de Teste',
      'role': 'Viewer',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Teste Completo de Perfis'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
          _buildProgressHeader(),
          _buildActionButtons(),
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Total', _total, Colors.white),
              _buildStatCard('✅ OK', _passed, Colors.green.shade300),
              _buildStatCard('❌ Erro', _failed, Colors.red.shade300),
            ],
          ),
          if (_isRunning) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentPhase,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _currentTest,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(color: color.withAlpha(200))),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isRunning ? null : _runCompleteTest,
              icon: const Icon(Icons.play_circle_fill, size: 28),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '▶ EXECUTAR TESTE COMPLETO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickButton('Setup', Icons.build, _runSetupPhase),
              _buildQuickButton('Auth', Icons.login, _runAuthPhase),
              _buildQuickButton('CRUD', Icons.storage, _runCrudPhase),
              _buildQuickButton('Perfis', Icons.people, _runProfilePhase),
              _buildQuickButton('Erros', Icons.error, _runErrorPhase),
              _buildQuickButton('Cleanup', Icons.cleaning_services, _runCleanupPhase),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isRunning ? null : onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Execute o teste completo para ver os resultados',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'O teste criará usuários de todos os perfis e\n'
              'executará operações simulando uso real',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
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
    Color bgColor;
    IconData icon;
    
    if (result.isHeader) {
      return Card(
        color: Colors.deepPurple.shade50,
        child: ListTile(
          leading: const Icon(Icons.folder, color: Colors.deepPurple),
          title: Text(
            result.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (result.success) {
      bgColor = Colors.green.shade50;
      icon = Icons.check_circle;
    } else {
      bgColor = Colors.red.shade50;
      icon = Icons.cancel;
    }

    return Card(
      color: bgColor,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ExpansionTile(
        leading: Icon(icon, color: result.success ? Colors.green : Colors.red),
        title: Text(
          result.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: result.success ? Colors.black87 : Colors.red.shade700,
          ),
        ),
        subtitle: Text(
          '${result.userRole} • ${result.method} ${result.endpoint} • ${result.statusCode} • ${result.duration}ms',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (result.message.isNotEmpty)
                  _buildDetailRow('Mensagem', result.message),
                if (result.requestBody != null)
                  _buildCodeBlock('Request', result.requestBody),
                if (result.responseBody != null)
                  _buildCodeBlock('Response', result.responseBody),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String label, dynamic data) {
    String formatted;
    try {
      if (data is String) {
        formatted = const JsonEncoder.withIndent('  ').convert(json.decode(data));
      } else {
        formatted = const JsonEncoder.withIndent('  ').convert(data);
      }
    } catch (_) {
      formatted = data.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          margin: const EdgeInsets.only(top: 4, bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          constraints: const BoxConstraints(maxHeight: 150),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Text(
              formatted,
              style: TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }

  void _clearResults() {
    setState(() {
      _results.clear();
      _passed = 0;
      _failed = 0;
      _total = 0;
      _progress = 0;
    });
  }

  void _addResult(TestResult result) {
    setState(() {
      _results.add(result);
      if (!result.isHeader) {
        if (result.success) _passed++;
        else _failed++;
      }
    });
    _scrollToBottom();
  }

  void _addHeader(String title) {
    _addResult(TestResult.header(title));
  }

  void _scrollToBottom() {
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

  void _updateProgress(int current, int total, String phase) {
    setState(() {
      _progress = current / total;
      _currentPhase = phase;
    });
  }

  // ============================================================
  // TESTE COMPLETO
  // ============================================================

  Future<void> _runCompleteTest() async {
    _clearResults();
    setState(() {
      _isRunning = true;
      _total = 65; // Estimativa
    });

    await _runSetupPhase();
    await _runAuthPhase();
    await _runCrudPhase();
    await _runProfilePhase();
    await _runErrorPhase();
    await _runCleanupPhase();

    setState(() => _isRunning = false);
    _showSummary();
  }

  // ============================================================
  // FASE 1: SETUP - Autenticar admins e criar usuários de teste
  // ============================================================

  Future<void> _runSetupPhase() async {
    setState(() => _isRunning = true);
    _addHeader('📦 FASE 1: SETUP - Preparando ambiente de teste');
    _updateProgress(0, 10, 'Preparando ambiente...');

    // 1. Login PlatformAdmin
    await _login('PlatformAdmin', 'tagbean_admin', 'TagBean@2025!');
    _updateProgress(1, 10, 'Setup');

    // 2. Login ClientAdmin
    await _login('ClientAdmin', 'demo_admin', 'Demo@123');
    _updateProgress(2, 10, 'Setup');

    // 3. Criar usuário StoreManager
    await _createTestUser('StoreManager', testUsers['StoreManager']!);
    _updateProgress(3, 10, 'Setup');

    // 4. Criar usuário Operator
    await _createTestUser('Operator', testUsers['Operator']!);
    _updateProgress(4, 10, 'Setup');

    // 5. Criar usuário Viewer
    await _createTestUser('Viewer', testUsers['Viewer']!);
    _updateProgress(5, 10, 'Setup');

    // 6. Login com usuários criados
    for (final role in ['StoreManager', 'Operator', 'Viewer']) {
      await _login(role, testUsers[role]!['username']!, testUsers[role]!['password']!);
    }
    _updateProgress(8, 10, 'Setup');

    // 7. Buscar IDs de recursos existentes
    await _fetchTestResources();
    _updateProgress(10, 10, 'Setup concluído');

    setState(() => _isRunning = false);
  }

  Future<void> _login(String role, String username, String password) async {
    setState(() => _currentTest = 'Login $role');
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      stopwatch.stop();

      final success = response.statusCode == 200;
      if (success) {
        final data = json.decode(response.body);
        _tokens[role] = data['accessToken'] ?? data['token'];
      }

      _addResult(TestResult(
        name: 'Login $role ($username)',
        userRole: role,
        method: 'POST',
        endpoint: '/auth/login',
        statusCode: response.statusCode,
        success: success,
        message: success ? 'Token obtido com sucesso' : 'Falha no login',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: {'username': username, 'password': '***'},
        responseBody: response.body,
      ));
    } catch (e) {
      stopwatch.stop();
      _addResult(TestResult(
        name: 'Login $role ($username)',
        userRole: role,
        method: 'POST',
        endpoint: '/auth/login',
        statusCode: 0,
        success: false,
        message: 'Erro de conexão: $e',
        duration: stopwatch.elapsedMilliseconds,
      ));
    }
  }

  Future<void> _createTestUser(String role, Map<String, String> userData) async {
    setState(() => _currentTest = 'Criar usuário $role');
    final token = _tokens['ClientAdmin'] ?? _tokens['PlatformAdmin'];
    if (token == null) return;

    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(userData),
      );
      stopwatch.stop();

      // 201 = criado, 409 = já existe (ok para testes)
      final success = response.statusCode == 201 || response.statusCode == 409;

      if (response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          _userIds[role] = data['id']?.toString() ?? '';
        } catch (_) {}
      }

      _addResult(TestResult(
        name: 'Criar usuário $role',
        userRole: 'ClientAdmin',
        method: 'POST',
        endpoint: '/users',
        statusCode: response.statusCode,
        success: success,
        message: response.statusCode == 201
            ? 'Usuário criado'
            : response.statusCode == 409
                ? 'Usuário já existe (OK)'
                : 'Falha ao criar',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: {...userData, 'password': '***'},
        responseBody: response.body,
      ));
    } catch (e) {
      stopwatch.stop();
      _addResult(TestResult(
        name: 'Criar usuário $role',
        userRole: 'ClientAdmin',
        method: 'POST',
        endpoint: '/users',
        statusCode: 0,
        success: false,
        message: 'Erro: $e',
        duration: stopwatch.elapsedMilliseconds,
      ));
    }
  }

  Future<void> _fetchTestResources() async {
    setState(() => _currentTest = 'Buscando recursos de teste');
    final token = _tokens['PlatformAdmin'];
    if (token == null) return;

    // Buscar loja de teste
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stores'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          _testStoreId = data[0]['id']?.toString();
        }
      }
    } catch (_) {}

    // Buscar produto de teste
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data is List ? data : (data['items'] ?? []);
        if (items.isNotEmpty) {
          _testProductId = items[0]['id']?.toString();
        }
      }
    } catch (_) {}

    _addResult(TestResult(
      name: 'Recursos de teste obtidos',
      userRole: 'Sistema',
      method: 'GET',
      endpoint: '/stores, /products',
      statusCode: 200,
      success: _testStoreId != null,
      message: 'Loja: ${_testStoreId ?? "N/A"}, Produto: ${_testProductId ?? "N/A"}',
      duration: 0,
    ));
  }

  // ============================================================
  // FASE 2: AUTENTICAÇÃO
  // ============================================================

  Future<void> _runAuthPhase() async {
    setState(() => _isRunning = true);
    _addHeader('🔐 FASE 2: AUTENTICAÇÃO - Testes de login e segurança');

    // Testes já cobertos no setup, adicionar apenas erros
    await _testRequest(
      name: 'Senha incorreta',
      role: 'Anônimo',
      method: 'POST',
      endpoint: '/auth/login',
      body: {'username': 'tagbean_admin', 'password': 'SenhaErrada'},
      expectSuccess: false,
      expectedStatus: 401,
    );

    await _testRequest(
      name: 'Usuário inexistente',
      role: 'Anônimo',
      method: 'POST',
      endpoint: '/auth/login',
      body: {'username': 'usuario_fantasma', 'password': 'Senha@123'},
      expectSuccess: false,
      expectedStatus: 401,
    );

    await _testRequest(
      name: 'Acesso sem token',
      role: 'Anônimo',
      method: 'GET',
      endpoint: '/users',
      expectSuccess: false,
      expectedStatus: 401,
    );

    await _testRequest(
      name: 'Token inválido',
      role: 'Token Falso',
      method: 'GET',
      endpoint: '/users',
      token: 'token-invalido-123',
      expectSuccess: false,
      expectedStatus: 401,
    );

    setState(() => _isRunning = false);
  }

  // ============================================================
  // FASE 3: CRUD - Operações de dados
  // ============================================================

  Future<void> _runCrudPhase() async {
    setState(() => _isRunning = true);
    _addHeader('📝 FASE 3: CRUD - Operações de criação, leitura, atualização');

    final token = _tokens['ClientAdmin']!;

    // Criar produto
    final productCode = DateTime.now().millisecondsSinceEpoch.toString();
    await _testRequest(
      name: 'Criar produto',
      role: 'ClientAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': _testStoreId ?? 'STORE-DEMO-001',
        'barcode': productCode,
        'name': 'Produto Teste $productCode',
        'price': 29.99,
        'originalPrice': 39.99,
        'category': 0,
        'stock': 100,
      },
      expectSuccess: true,
      expectedStatus: 201,
      onSuccess: (resp) {
        try {
          final data = json.decode(resp.body);
          _testProductId = data['id']?.toString();
        } catch (_) {}
      },
    );

    // Listar produtos
    await _testRequest(
      name: 'Listar produtos',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/products',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // Buscar produto
    if (_testProductId != null) {
      await _testRequest(
        name: 'Buscar produto por ID',
        role: 'ClientAdmin',
        method: 'GET',
        endpoint: '/products/$_testProductId',
        token: token,
        expectSuccess: true,
        expectedStatus: 200,
      );

      // Atualizar produto
      await _testRequest(
        name: 'Atualizar produto',
        role: 'ClientAdmin',
        method: 'PUT',
        endpoint: '/products/$_testProductId',
        token: token,
        body: {'name': 'Produto Atualizado', 'price': 19.99},
        expectSuccess: true,
        expectedStatus: 200,
      );
    }

    // Listar tags
    await _testRequest(
      name: 'Listar tags',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/tags',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // Listar lojas
    await _testRequest(
      name: 'Listar lojas',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/stores',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    // Listar estratégias
    await _testRequest(
      name: 'Listar estratégias',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/strategies',
      token: token,
      expectSuccess: true,
      expectedStatus: 200,
    );

    setState(() => _isRunning = false);
  }

  // ============================================================
  // FASE 4: TESTES POR PERFIL
  // ============================================================

  Future<void> _runProfilePhase() async {
    setState(() => _isRunning = true);
    _addHeader('👥 FASE 4: PERFIS - Testes de permissÃ£o por tipo de usuário');

    // === PLATFORM ADMIN (TUDO) ===
    _addHeader('👑 PlatformAdmin - Dono da TagBean');
    
    await _testRequest(
      name: 'PlatformAdmin - Listar clientes',
      role: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/clients',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'PlatformAdmin - Gerenciar roles',
      role: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/roles',
      token: _tokens['PlatformAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    // === CLIENT ADMIN (LIMITADO AO CLIENTE) ===
    _addHeader('🏪 ClientAdmin - Dono do Supermercado');

    await _testRequest(
      name: 'ClientAdmin - Listar clientes (BLOQUEADO)',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/clients',
      token: _tokens['ClientAdmin'],
      expectSuccess: false,
      expectedStatus: 403,
    );

    await _testRequest(
      name: 'ClientAdmin - Listar suas lojas',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/stores',
      token: _tokens['ClientAdmin'],
      expectSuccess: true,
      expectedStatus: 200,
    );

    await _testRequest(
      name: 'ClientAdmin - Criar usuário',
      role: 'ClientAdmin',
      method: 'POST',
      endpoint: '/users',
      token: _tokens['ClientAdmin'],
      body: {
        'username': 'temp_user_${DateTime.now().millisecondsSinceEpoch}',
        'password': 'Temp@123',
        'email': 'temp${DateTime.now().millisecondsSinceEpoch}@teste.com',
        'fullName': 'Usuário Temporário',
        'role': 'Operator',
      },
      expectSuccess: true,
      expectedStatus: 201,
    );

    // === STORE MANAGER (GERENTE) ===
    if (_tokens['StoreManager'] != null) {
      _addHeader('👔 StoreManager - Gerente de Loja');

      await _testRequest(
        name: 'StoreManager - Listar produtos',
        role: 'StoreManager',
        method: 'GET',
        endpoint: '/products',
        token: _tokens['StoreManager'],
        expectSuccess: true,
        expectedStatus: 200,
      );

      await _testRequest(
        name: 'StoreManager - Listar tags',
        role: 'StoreManager',
        method: 'GET',
        endpoint: '/tags',
        token: _tokens['StoreManager'],
        expectSuccess: true,
        expectedStatus: 200,
      );

      await _testRequest(
        name: 'StoreManager - Criar usuário (BLOQUEADO)',
        role: 'StoreManager',
        method: 'POST',
        endpoint: '/users',
        token: _tokens['StoreManager'],
        body: {
          'username': 'novo_user',
          'password': 'Novo@123',
          'email': 'novo@teste.com',
          'fullName': 'Novo Usuário',
          'role': 'Operator',
        },
        expectSuccess: false,
        expectedStatus: 403,
      );

      await _testRequest(
        name: 'StoreManager - Ver relatórios',
        role: 'StoreManager',
        method: 'GET',
        endpoint: '/reports/dashboard',
        token: _tokens['StoreManager'],
        expectSuccess: true,
        expectedStatus: 200,
      );
    }

    // === OPERATOR (REPOSITOR) ===
    if (_tokens['Operator'] != null) {
      _addHeader('🛒 Operator - Repositor/Operador');

      await _testRequest(
        name: 'Operator - Listar produtos',
        role: 'Operator',
        method: 'GET',
        endpoint: '/products',
        token: _tokens['Operator'],
        expectSuccess: true,
        expectedStatus: 200,
      );

      await _testRequest(
        name: 'Operator - Atualizar preço produto',
        role: 'Operator',
        method: 'PUT',
        endpoint: '/products/${_testProductId ?? "PROD-001"}',
        token: _tokens['Operator'],
        body: {'price': 24.99},
        expectSuccess: true,
        expectedStatus: 200,
      );

      await _testRequest(
        name: 'Operator - Listar tags',
        role: 'Operator',
        method: 'GET',
        endpoint: '/tags',
        token: _tokens['Operator'],
        expectSuccess: true,
        expectedStatus: 200,
      );

      await _testRequest(
        name: 'Operator - Criar loja (BLOQUEADO)',
        role: 'Operator',
        method: 'POST',
        endpoint: '/stores',
        token: _tokens['Operator'],
        body: {
          'number': '999',
          'name': 'Loja Indevida',
        },
        expectSuccess: false,
        expectedStatus: 403,
      );

      await _testRequest(
        name: 'Operator - Criar estratégia (BLOQUEADO)',
        role: 'Operator',
        method: 'POST',
        endpoint: '/strategies',
        token: _tokens['Operator'],
        body: {
          'name': 'Estratégia Indevida',
          'type': 0,
        },
        expectSuccess: false,
        expectedStatus: 403,
      );
    }

    // === VIEWER (SOMENTE LEITURA) ===
    if (_tokens['Viewer'] != null) {
      _addHeader('👁️ Viewer - Visualizador');

      await _testRequest(
        name: 'Viewer - Listar produtos',
        role: 'Viewer',
        method: 'GET',
        endpoint: '/products',
        token: _tokens['Viewer'],
        expectSuccess: true,
        expectedStatus: 200,
      );

      await _testRequest(
        name: 'Viewer - Listar lojas',
        role: 'Viewer',
        method: 'GET',
        endpoint: '/stores',
        token: _tokens['Viewer'],
        expectSuccess: true,
        expectedStatus: 200,
      );

      await _testRequest(
        name: 'Viewer - Criar produto (BLOQUEADO)',
        role: 'Viewer',
        method: 'POST',
        endpoint: '/products',
        token: _tokens['Viewer'],
        body: {
          'storeId': 'STORE-DEMO-001',
          'barcode': '1234567890',
          'name': 'Produto Indevido',
          'price': 10.00,
        },
        expectSuccess: false,
        expectedStatus: 403,
      );

      await _testRequest(
        name: 'Viewer - Atualizar produto (BLOQUEADO)',
        role: 'Viewer',
        method: 'PUT',
        endpoint: '/products/${_testProductId ?? "PROD-001"}',
        token: _tokens['Viewer'],
        body: {'price': 1.00},
        expectSuccess: false,
        expectedStatus: 403,
      );

      await _testRequest(
        name: 'Viewer - Deletar produto (BLOQUEADO)',
        role: 'Viewer',
        method: 'DELETE',
        endpoint: '/products/${_testProductId ?? "PROD-001"}',
        token: _tokens['Viewer'],
        expectSuccess: false,
        expectedStatus: 403,
      );
    }

    setState(() => _isRunning = false);
  }

  // ============================================================
  // FASE 5: TESTES DE ERRO
  // ============================================================

  Future<void> _runErrorPhase() async {
    setState(() => _isRunning = true);
    _addHeader('❌ FASE 5: ERROS - Validações e tratamento de erros');

    final token = _tokens['ClientAdmin'] ?? _tokens['PlatformAdmin']!;

    // Validação de campos obrigatórios
    await _testRequest(
      name: 'Produto sem nome',
      role: 'ClientAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {'storeId': 'STORE-DEMO-001', 'barcode': '123', 'price': 10},
      expectSuccess: false,
      expectedStatus: 400,
    );

    await _testRequest(
      name: 'Produto com preço negativo',
      role: 'ClientAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': 'STORE-DEMO-001',
        'barcode': '123',
        'name': 'Teste',
        'price': -10,
      },
      expectSuccess: false,
      expectedStatus: 400,
    );

    // Recursos inexistentes (404)
    await _testRequest(
      name: 'Produto inexistente',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/products/PRODUTO-FANTASMA-12345',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: 'Loja inexistente',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/stores/LOJA-FANTASMA',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: 'Tag inexistente',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/tags/XX:XX:XX:XX:XX:XX',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: 'Endpoint inexistente',
      role: 'ClientAdmin',
      method: 'GET',
      endpoint: '/nao-existe',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    // Conflitos (409)
    await _testRequest(
      name: 'Usuário duplicado',
      role: 'ClientAdmin',
      method: 'POST',
      endpoint: '/users',
      token: token,
      body: {
        'username': 'demo_admin', // Já existe
        'password': 'Teste@123',
        'email': 'outro@email.com',
        'fullName': 'Duplicado',
        'role': 'Operator',
      },
      expectSuccess: false,
      expectedStatus: 409,
    );

    setState(() => _isRunning = false);
  }

  // ============================================================
  // FASE 6: CLEANUP
  // ============================================================

  Future<void> _runCleanupPhase() async {
    setState(() => _isRunning = true);
    _addHeader('🧹 FASE 6: CLEANUP - Limpeza de dados de teste');

    // Por segurança, não deletamos dados automaticamente
    // Apenas informamos o que foi criado

    _addResult(TestResult(
      name: 'Cleanup informativo',
      userRole: 'Sistema',
      method: 'INFO',
      endpoint: '-',
      statusCode: 200,
      success: true,
      message: 'Usuários de teste criados: gerente_teste, operador_teste, viewer_teste.\n'
          'Para remover, use a interface de administração.',
      duration: 0,
    ));

    setState(() => _isRunning = false);
  }

  // ============================================================
  // HELPER: Request genérico
  // ============================================================

  Future<void> _testRequest({
    required String name,
    required String role,
    required String method,
    required String endpoint,
    String? token,
    dynamic body,
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
          response = await http.post(uri, headers: headers, body: body != null ? json.encode(body) : null);
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: body != null ? json.encode(body) : null);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: headers, body: body != null ? json.encode(body) : null);
          break;
        default:
          throw Exception('Método não suportado: $method');
      }

      stopwatch.stop();

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
        userRole: role,
        method: method,
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: success,
        message: success
            ? 'OK'
            : 'Esperado: ${expectedStatus ?? (expectSuccess ? "2xx" : "4xx")}, Recebido: ${response.statusCode}',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: body,
        responseBody: response.body,
      ));
    } catch (e) {
      stopwatch.stop();
      _addResult(TestResult(
        name: name,
        userRole: role,
        method: method,
        endpoint: endpoint,
        statusCode: 0,
        success: false,
        message: 'Erro: $e',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: body,
      ));
    }
  }

  void _showSummary() {
    final percentage = _total > 0 ? (_passed / _total * 100).toStringAsFixed(1) : '0';
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _failed == 0 ? Icons.check_circle : Icons.warning,
              color: _failed == 0 ? Colors.green : Colors.orange,
              size: 32,
            ),
            const SizedBox(width: 12),
            const Text('Resultado dos Testes'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _failed == 0 ? '🎉 TODOS OS TESTES PASSARAM!' : '⚠️ Alguns testes falharam',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _failed == 0 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryColumn('✅', '$_passed', 'Passou', Colors.green),
                _buildSummaryColumn('❌', '$_failed', 'Falhou', Colors.red),
                _buildSummaryColumn('📊', '$_total', 'Total', Colors.blue),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Taxa de sucesso: $percentage%',
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

  Widget _buildSummaryColumn(String emoji, String value, String label, Color color) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 24)),
        Text(
          value,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

// ============================================================
// MODELO
// ============================================================

class TestResult {
  final String name;
  final String userRole;
  final String method;
  final String endpoint;
  final int statusCode;
  final bool success;
  final String message;
  final int duration;
  final dynamic requestBody;
  final dynamic responseBody;
  final bool isHeader;

  TestResult({
    required this.name,
    required this.userRole,
    required this.method,
    required this.endpoint,
    required this.statusCode,
    required this.success,
    required this.message,
    required this.duration,
    this.requestBody,
    this.responseBody,
    this.isHeader = false,
  });

  factory TestResult.header(String title) => TestResult(
        name: title,
        userRole: '',
        method: '',
        endpoint: '',
        statusCode: 0,
        success: true,
        message: '',
        duration: 0,
        isHeader: true,
      );
}




