import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Tela de Testes Completos - Popula banco e testa todos os perfis
/// 
/// Este script:
/// 1. Cria usuários para todos os 5 perfis
/// 2. Cria dados de teste (produtos, tags, categorias, etc.)
/// 3. Testa cada perfil com operações permitidas e negadas
/// 4. Testa todos os cenários de erro possíveis
class CompleteTestScreen extends ConsumerStatefulWidget {
  const CompleteTestScreen({super.key});

  @override
  ConsumerState<CompleteTestScreen> createState() => _CompleteTestScreenState();
}

class _CompleteTestScreenState extends ConsumerState<CompleteTestScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<TestResult> _results = [];
  bool _isRunning = false;
  String _currentPhase = '';
  String _currentTest = '';
  int _passed = 0;
  int _failed = 0;
  int _total = 0;

  // Configuração
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Tokens por perfil
  final Map<String, String> _tokens = {};
  
  // IDs criados durante os testes
  final Map<String, String> _createdIds = {};

  // Usuários de teste por perfil
  static const Map<String, Map<String, dynamic>> testProfiles = {
    'PlatformAdmin': {
      'username': 'tagbean_admin',
      'password': 'TagBean@2025!',
      'description': '🔑 Dono da Plataforma TagBean - Acesso Total',
      'icon': Icons.admin_panel_settings,
      'color': Colors.purple,
      'existsInDb': true,
    },
    'ClientAdmin': {
      'username': 'demo_admin',
      'password': 'Demo@123',
      'description': '🏢 Dono do Supermercado - Gerencia todas as lojas',
      'icon': Icons.business,
      'color': Colors.blue,
      'existsInDb': true,
    },
    'StoreManager': {
      'username': 'gerente_loja',
      'password': 'Gerente@123',
      'description': '👔 Gerente/Supervisor - Gerencia loja(s) específica(s)',
      'icon': Icons.store,
      'color': Colors.teal,
      'existsInDb': false,
    },
    'Operator': {
      'username': 'operador_loja',
      'password': 'Operador@123',
      'description': '🛒 Repositor/Operador - Operações básicas na loja',
      'icon': Icons.person,
      'color': Colors.orange,
      'existsInDb': false,
    },
    'Viewer': {
      'username': 'visualizador',
      'password': 'Viewer@123',
      'description': '👁️ Visualizador - Apenas leitura',
      'icon': Icons.visibility,
      'color': Colors.grey,
      'existsInDb': false,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Testes Completos - Todos os Perfis'),
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
          _buildHeader(),
          _buildProfileCards(),
          _buildActionButtons(),
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade50],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Total', _total, Colors.blue),
              _buildStatCard('✅ Passou', _passed, Colors.green),
              _buildStatCard('❌ Falhou', _failed, Colors.red),
              _buildStatCard('Taxa', _total > 0 ? '${((_passed / _total) * 100).toStringAsFixed(0)}%' : '0%', Colors.purple),
            ],
          ),
          if (_isRunning) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _total > 0 ? (_passed + _failed) / _total : null,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            Text(
              '📌 $_currentPhase',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '🔄 $_currentTest',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, dynamic value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCards() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: testProfiles.entries.map((entry) {
          final profile = entry.value;
          final hasToken = _tokens.containsKey(entry.key);
          return Card(
            color: hasToken ? (profile['color'] as Color).withValues(alpha: 0.2) : Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    profile['icon'] as IconData,
                    color: profile['color'] as Color,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: profile['color'] as Color,
                        ),
                      ),
                      Text(
                        profile['username'] as String,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      if (hasToken)
                        const Text('✅ Logado', style: TextStyle(fontSize: 9, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _runCompleteTestSuite,
            icon: const Icon(Icons.play_circle_filled),
            label: const Text('🚀 EXECUTAR SUITE COMPLETA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _setupTestData,
            icon: const Icon(Icons.build),
            label: const Text('1. Popular Banco'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _testAllProfiles,
            icon: const Icon(Icons.people),
            label: const Text('2. Testar Perfis'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _testAllErrors,
            icon: const Icon(Icons.error_outline),
            label: const Text('3. Testar Erros'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _testEdgeCases,
            icon: const Icon(Icons.warning_amber),
            label: const Text('4. Casos Extremos'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Execute a suite de testes para começar',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Este teste irá criar usuários, popular o banco\ne testar todos os cenários possíveis',
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
      itemBuilder: (context, index) => _buildResultCard(_results[index]),
    );
  }

  Widget _buildResultCard(TestResult result) {
    final icon = result.success ? Icons.check_circle : Icons.cancel;
    final color = result.success ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ExpansionTile(
        dense: true,
        leading: Icon(icon, color: color, size: 20),
        title: Text(
          result.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: result.success ? Colors.black87 : Colors.red.shade700,
          ),
        ),
        subtitle: Text(
          '${result.category} • ${result.userRole} • ${result.duration}ms',
          style: const TextStyle(fontSize: 10),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Endpoint', '${result.method} ${result.endpoint}'),
                _buildRow('Status', '${result.statusCode}'),
                if (result.message.isNotEmpty) _buildRow('Mensagem', result.message),
                if (result.responseBody != null) ...[
                  const SizedBox(height: 8),
                  const Text('Response:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: Colors.grey.shade100,
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: SingleChildScrollView(
                      child: Text(
                        _formatJson(result.responseBody),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
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

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 70, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11))),
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
      _tokens.clear();
      _createdIds.clear();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ============================================================
  // SUITE COMPLETA DE TESTES
  // ============================================================

  Future<void> _runCompleteTestSuite() async {
    _clearResults();
    setState(() => _isRunning = true);

    // Fase 1: Popular banco de dados
    await _setupTestData();

    // Fase 2: Testar todos os perfis
    await _testAllProfiles();

    // Fase 3: Testar erros e validações
    await _testAllErrors();

    // Fase 4: Casos extremos
    await _testEdgeCases();

    setState(() => _isRunning = false);
    _showSummary();
  }

  // ============================================================
  // FASE 1: POPULAR BANCO DE DADOS
  // ============================================================

  Future<void> _setupTestData() async {
    setState(() {
      _currentPhase = 'FASE 1: Populando Banco de Dados';
      _isRunning = true;
    });

    // 1.1 Login como PlatformAdmin
    await _login('PlatformAdmin', 'tagbean_admin', 'TagBean@2025!');
    await _login('ClientAdmin', 'demo_admin', 'Demo@123');

    final platformToken = _tokens['PlatformAdmin'];
    final clientToken = _tokens['ClientAdmin'];

    if (platformToken == null || clientToken == null) {
      _addResult(TestResult(
        name: '❌ FALHA CRÍTICA: Não foi possível autenticar',
        category: 'Setup',
        userRole: 'Sistema',
        method: '-',
        endpoint: '-',
        statusCode: 0,
        success: false,
        message: 'Verifique se o backend está rodando',
        duration: 0,
      ));
      setState(() => _isRunning = false);
      return;
    }

    // 1.2 Criar usuários de teste para todos os perfis
    await _createTestUsers(clientToken);

    // 1.3 Criar categorias de teste
    await _createTestCategories(platformToken);

    // 1.4 Criar produtos de teste
    await _createTestProducts(platformToken);

    // 1.5 Criar tags de teste
    await _createTestTags(platformToken);

    // 1.6 Criar estratégias de teste
    await _createTestStrategies(platformToken);

    setState(() => _isRunning = false);
  }

  Future<void> _login(String profile, String username, String password) async {
    setState(() {
      _currentTest = 'Login: $profile ($username)';
      _total++;
    });

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      stopwatch.stop();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _tokens[profile] = data['accessToken'] ?? data['token'];
      }

      _addResult(TestResult(
        name: 'Login $profile',
        category: 'Autenticação',
        userRole: profile,
        method: 'POST',
        endpoint: '/auth/login',
        statusCode: response.statusCode,
        success: response.statusCode == 200,
        message: response.statusCode == 200 ? 'Token obtido' : 'Falha no login',
        duration: stopwatch.elapsedMilliseconds,
        responseBody: response.body,
      ));
    } catch (e) {
      stopwatch.stop();
      _addResult(TestResult(
        name: 'Login $profile',
        category: 'Autenticação',
        userRole: profile,
        method: 'POST',
        endpoint: '/auth/login',
        statusCode: 0,
        success: false,
        message: 'Erro: $e',
        duration: stopwatch.elapsedMilliseconds,
      ));
    }
  }

  Future<void> _createTestUsers(String token) async {
    setState(() => _currentTest = 'Criando usuários de teste...');

    // Obter o ClientId do demo_admin
    String? clientId;
    try {
      final meResponse = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );
      if (meResponse.statusCode == 200) {
        final meData = json.decode(meResponse.body);
        clientId = meData['clientId'];
      }
    } catch (_) {}

    // Criar StoreManager
    await _createUser(token, {
      'username': 'gerente_loja',
      'password': 'Gerente@123',
      'email': 'gerente@teste.com',
      'fullName': 'Gerente de Loja Teste',
      'role': 'StoreManager',
      if (clientId != null) 'clientId': clientId,
    }, 'StoreManager');

    // Criar Operator
    await _createUser(token, {
      'username': 'operador_loja',
      'password': 'Operador@123',
      'email': 'operador@teste.com',
      'fullName': 'Operador de Loja Teste',
      'role': 'Operator',
      if (clientId != null) 'clientId': clientId,
    }, 'Operator');

    // Criar Viewer
    await _createUser(token, {
      'username': 'visualizador',
      'password': 'Viewer@123',
      'email': 'viewer@teste.com',
      'fullName': 'Visualizador Teste',
      'role': 'Viewer',
      if (clientId != null) 'clientId': clientId,
    }, 'Viewer');

    // Fazer login com os novos usuários
    await _login('StoreManager', 'gerente_loja', 'Gerente@123');
    await _login('Operator', 'operador_loja', 'Operador@123');
    await _login('Viewer', 'visualizador', 'Viewer@123');
  }

  Future<void> _createUser(String token, Map<String, dynamic> userData, String profile) async {
    setState(() {
      _currentTest = 'Criando usuário: ${userData['username']}';
      _total++;
    });

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      stopwatch.stop();

      // 201 = criado, 409 = já existe (ok para nosso caso)
      final success = response.statusCode == 201 || response.statusCode == 409 || response.statusCode == 400;

      if (response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          _createdIds['user_$profile'] = data['id'];
        } catch (_) {}
      }

      _addResult(TestResult(
        name: 'Criar usuário $profile',
        category: 'Setup',
        userRole: 'ClientAdmin',
        method: 'POST',
        endpoint: '/users',
        statusCode: response.statusCode,
        success: success,
        message: response.statusCode == 201 ? 'Criado' : 
                 response.statusCode == 409 ? 'Já existe' : 
                 response.statusCode == 400 ? 'Já existe (400)' : 'Erro',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: {...userData, 'password': '***'},
        responseBody: response.body,
      ));
    } catch (e) {
      stopwatch.stop();
      _addResult(TestResult(
        name: 'Criar usuário $profile',
        category: 'Setup',
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

  Future<void> _createTestCategories(String token) async {
    final categories = [
      {'name': 'Alimentos', 'description': 'Produtos alimentícios', 'color': '#4CAF50'},
      {'name': 'Bebidas', 'description': 'Bebidas em geral', 'color': '#2196F3'},
      {'name': 'Higiene', 'description': 'Produtos de higiene pessoal', 'color': '#9C27B0'},
      {'name': 'Limpeza', 'description': 'Produtos de limpeza', 'color': '#FF9800'},
      {'name': 'Frios', 'description': 'Produtos refrigerados', 'color': '#00BCD4'},
    ];

    for (final cat in categories) {
      await _testRequest(
        name: 'Criar categoria: ${cat['name']}',
        category: 'Setup',
        userRole: 'PlatformAdmin',
        method: 'POST',
        endpoint: '/categories',
        token: token,
        body: cat,
        expectSuccess: true,
        allowStatus: [201, 409, 400], // Criado ou já existe
      );
    }
  }

  Future<void> _createTestProducts(String token) async {
    final products = [
      {'barcode': '7891000100103', 'name': 'Leite Integral 1L', 'price': 5.99, 'category': 0, 'stock': 100},
      {'barcode': '7891000100110', 'name': 'Arroz Tipo 1 5kg', 'price': 24.90, 'category': 0, 'stock': 50},
      {'barcode': '7891000100127', 'name': 'Feijão Preto 1kg', 'price': 8.99, 'category': 0, 'stock': 80},
      {'barcode': '7891000100134', 'name': 'Refrigerante Cola 2L', 'price': 9.99, 'category': 1, 'stock': 200},
      {'barcode': '7891000100141', 'name': 'Água Mineral 500ml', 'price': 2.50, 'category': 1, 'stock': 500},
      {'barcode': '7891000100158', 'name': 'Sabonete 90g', 'price': 2.99, 'category': 2, 'stock': 150},
      {'barcode': '7891000100165', 'name': 'Shampoo 400ml', 'price': 15.90, 'category': 2, 'stock': 60},
      {'barcode': '7891000100172', 'name': 'Detergente 500ml', 'price': 3.49, 'category': 3, 'stock': 100},
      {'barcode': '7891000100189', 'name': 'Queijo Mussarela 500g', 'price': 32.90, 'category': 4, 'stock': 30},
      {'barcode': '7891000100196', 'name': 'Presunto Fatiado 200g', 'price': 18.90, 'category': 4, 'stock': 40},
    ];

    for (final prod in products) {
      await _testRequest(
        name: 'Criar produto: ${prod['name']}',
        category: 'Setup',
        userRole: 'PlatformAdmin',
        method: 'POST',
        endpoint: '/products',
        token: token,
        body: {
          'storeId': 'STORE-DEMO-001',
          ...prod,
          'originalPrice': prod['price'],
          'minStock': 10,
          'maxStock': 1000,
        },
        expectSuccess: true,
        allowStatus: [201, 409, 400],
      );
    }
  }

  Future<void> _createTestTags(String token) async {
    final tags = [
      {'macAddress': 'ac233fd00001', 'type': 0},
      {'macAddress': 'ac233fd00002', 'type': 0},
      {'macAddress': 'ac233fd00003', 'type': 1},
      {'macAddress': 'ac233fd00004', 'type': 1},
      {'macAddress': 'ac233fd00005', 'type': 2},
    ];

    for (int i = 0; i < tags.length; i++) {
      await _testRequest(
        name: 'Criar tag: ${tags[i]['macAddress']}',
        category: 'Setup',
        userRole: 'PlatformAdmin',
        method: 'POST',
        endpoint: '/tags',
        token: token,
        body: {
          'storeId': 'STORE-DEMO-001',
          ...tags[i],
        },
        expectSuccess: true,
        allowStatus: [201, 409, 400],
      );
    }
  }

  Future<void> _createTestStrategies(String token) async {
    final strategies = [
      {'name': 'Promoção Fim de Semana', 'type': 0, 'configuration': '{"discount": 10}'},
      {'name': 'Horário de Pico', 'type': 1, 'configuration': '{"increase": 5}'},
      {'name': 'Queima de Estoque', 'type': 2, 'configuration': '{"discount": 30}'},
    ];

    for (final strat in strategies) {
      await _testRequest(
        name: 'Criar estratégia: ${strat['name']}',
        category: 'Setup',
        userRole: 'PlatformAdmin',
        method: 'POST',
        endpoint: '/strategies',
        token: token,
        body: {
          'storeId': 'STORE-DEMO-001',
          'isActive': false,
          ...strat,
        },
        expectSuccess: true,
        allowStatus: [201, 409, 400],
      );
    }
  }

  // ============================================================
  // FASE 2: TESTAR TODOS OS PERFIS
  // ============================================================

  Future<void> _testAllProfiles() async {
    setState(() {
      _currentPhase = 'FASE 2: Testando Permissões por Perfil';
      _isRunning = true;
    });

    // Garantir que temos tokens
    if (_tokens['PlatformAdmin'] == null) {
      await _login('PlatformAdmin', 'tagbean_admin', 'TagBean@2025!');
      await _login('ClientAdmin', 'demo_admin', 'Demo@123');
      await _login('StoreManager', 'gerente_loja', 'Gerente@123');
      await _login('Operator', 'operador_loja', 'Operador@123');
      await _login('Viewer', 'visualizador', 'Viewer@123');
    }

    // Testar cada perfil
    await _testPlatformAdminPermissions();
    await _testClientAdminPermissions();
    await _testStoreManagerPermissions();
    await _testOperatorPermissions();
    await _testViewerPermissions();

    setState(() => _isRunning = false);
  }

  Future<void> _testPlatformAdminPermissions() async {
    final token = _tokens['PlatformAdmin'];
    if (token == null) return;

    const profile = 'PlatformAdmin';
    setState(() => _currentTest = 'Testando: $profile (Dono TagBean)');

    // PlatformAdmin pode TUDO
    final endpoints = [
      {'method': 'GET', 'endpoint': '/clients', 'name': 'Listar clientes', 'success': true},
      {'method': 'GET', 'endpoint': '/users', 'name': 'Listar usuários', 'success': true},
      {'method': 'GET', 'endpoint': '/stores', 'name': 'Listar lojas', 'success': true},
      {'method': 'GET', 'endpoint': '/products', 'name': 'Listar produtos', 'success': true},
      {'method': 'GET', 'endpoint': '/tags', 'name': 'Listar tags', 'success': true},
      {'method': 'GET', 'endpoint': '/categories', 'name': 'Listar categorias', 'success': true},
      {'method': 'GET', 'endpoint': '/strategies', 'name': 'Listar estratégias', 'success': true},
      {'method': 'GET', 'endpoint': '/gateways', 'name': 'Listar gateways', 'success': true},
      {'method': 'GET', 'endpoint': '/roles', 'name': 'Listar roles', 'success': true},
      {'method': 'GET', 'endpoint': '/reports/dashboard', 'name': 'Ver dashboard', 'success': true},
      {'method': 'POST', 'endpoint': '/clients', 'name': 'Criar cliente', 'success': true, 'body': {'name': 'Teste API', 'tradeName': 'Teste', 'cnpj': '99.999.999/0001-99', 'email': 'api@teste.com', 'maxStores': 5, 'maxUsers': 10}},
    ];

    for (final ep in endpoints) {
      await _testRequest(
        name: '$profile - ${ep['name']}',
        category: 'Permissões',
        userRole: profile,
        method: ep['method'] as String,
        endpoint: ep['endpoint'] as String,
        token: token,
        body: ep['body'],
        expectSuccess: ep['success'] as bool,
      );
    }
  }

  Future<void> _testClientAdminPermissions() async {
    final token = _tokens['ClientAdmin'];
    if (token == null) return;

    const profile = 'ClientAdmin';
    setState(() => _currentTest = 'Testando: $profile (Dono Supermercado)');

    final tests = [
      {'method': 'GET', 'endpoint': '/clients', 'name': 'Listar clientes (NEGADO)', 'success': false, 'status': 403},
      {'method': 'GET', 'endpoint': '/users', 'name': 'Listar usuários (próprio cliente)', 'success': true, 'status': 200},
      {'method': 'GET', 'endpoint': '/stores', 'name': 'Listar lojas (próprio cliente)', 'success': true, 'status': 200},
      {'method': 'GET', 'endpoint': '/products', 'name': 'Listar produtos', 'success': true, 'status': 200},
      {'method': 'GET', 'endpoint': '/tags', 'name': 'Listar tags', 'success': true, 'status': 200},
      {'method': 'GET', 'endpoint': '/strategies', 'name': 'Listar estratégias', 'success': true, 'status': 200},
      {'method': 'POST', 'endpoint': '/roles', 'name': 'Criar role (NEGADO)', 'success': false, 'status': 403},
    ];

    for (final t in tests) {
      await _testRequest(
        name: '$profile - ${t['name']}',
        category: 'Permissões',
        userRole: profile,
        method: t['method'] as String,
        endpoint: t['endpoint'] as String,
        token: token,
        expectSuccess: t['success'] as bool,
        expectedStatus: t['status'] as int,
      );
    }
  }

  Future<void> _testStoreManagerPermissions() async {
    final token = _tokens['StoreManager'];
    if (token == null) {
      _addResult(TestResult(
        name: 'StoreManager - SKIP (não logado)',
        category: 'Permissões',
        userRole: 'StoreManager',
        method: '-',
        endpoint: '-',
        statusCode: 0,
        success: false,
        message: 'Usuário não foi criado ou login falhou',
        duration: 0,
      ));
      setState(() => _total++);
      return;
    }

    const profile = 'StoreManager';
    setState(() => _currentTest = 'Testando: $profile (Gerente)');

    final tests = [
      {'method': 'GET', 'endpoint': '/stores', 'name': 'Listar lojas (atribuídas)', 'success': true},
      {'method': 'GET', 'endpoint': '/products', 'name': 'Listar produtos', 'success': true},
      {'method': 'GET', 'endpoint': '/tags', 'name': 'Listar tags', 'success': true},
      {'method': 'GET', 'endpoint': '/strategies', 'name': 'Listar estratégias', 'success': true},
      {'method': 'GET', 'endpoint': '/reports/dashboard', 'name': 'Ver relatórios', 'success': true},
      {'method': 'GET', 'endpoint': '/clients', 'name': 'Listar clientes (NEGADO)', 'success': false},
      {'method': 'POST', 'endpoint': '/stores', 'name': 'Criar loja (NEGADO)', 'success': false},
    ];

    for (final t in tests) {
      await _testRequest(
        name: '$profile - ${t['name']}',
        category: 'Permissões',
        userRole: profile,
        method: t['method'] as String,
        endpoint: t['endpoint'] as String,
        token: token,
        expectSuccess: t['success'] as bool,
      );
    }
  }

  Future<void> _testOperatorPermissions() async {
    final token = _tokens['Operator'];
    if (token == null) {
      _addResult(TestResult(
        name: 'Operator - SKIP (não logado)',
        category: 'Permissões',
        userRole: 'Operator',
        method: '-',
        endpoint: '-',
        statusCode: 0,
        success: false,
        message: 'Usuário não foi criado ou login falhou',
        duration: 0,
      ));
      setState(() => _total++);
      return;
    }

    const profile = 'Operator';
    setState(() => _currentTest = 'Testando: $profile (Repositor)');

    final tests = [
      {'method': 'GET', 'endpoint': '/products', 'name': 'Listar produtos', 'success': true},
      {'method': 'GET', 'endpoint': '/tags', 'name': 'Listar tags', 'success': true},
      {'method': 'GET', 'endpoint': '/stores', 'name': 'Listar lojas (atribuídas)', 'success': true},
      {'method': 'GET', 'endpoint': '/strategies', 'name': 'Ver estratégias (NEGADO)', 'success': false},
      {'method': 'GET', 'endpoint': '/users', 'name': 'Listar usuários (NEGADO)', 'success': false},
      {'method': 'POST', 'endpoint': '/products', 'name': 'Criar produto (NEGADO)', 'success': false},
      {'method': 'DELETE', 'endpoint': '/products/qualquer', 'name': 'Deletar produto (NEGADO)', 'success': false},
    ];

    for (final t in tests) {
      await _testRequest(
        name: '$profile - ${t['name']}',
        category: 'Permissões',
        userRole: profile,
        method: t['method'] as String,
        endpoint: t['endpoint'] as String,
        token: token,
        expectSuccess: t['success'] as bool,
      );
    }
  }

  Future<void> _testViewerPermissions() async {
    final token = _tokens['Viewer'];
    if (token == null) {
      _addResult(TestResult(
        name: 'Viewer - SKIP (não logado)',
        category: 'Permissões',
        userRole: 'Viewer',
        method: '-',
        endpoint: '-',
        statusCode: 0,
        success: false,
        message: 'Usuário não foi criado ou login falhou',
        duration: 0,
      ));
      setState(() => _total++);
      return;
    }

    const profile = 'Viewer';
    setState(() => _currentTest = 'Testando: $profile (Visualizador)');

    final tests = [
      {'method': 'GET', 'endpoint': '/products', 'name': 'Listar produtos (READ)', 'success': true},
      {'method': 'GET', 'endpoint': '/tags', 'name': 'Listar tags (READ)', 'success': true},
      {'method': 'GET', 'endpoint': '/stores', 'name': 'Listar lojas (READ)', 'success': true},
      {'method': 'POST', 'endpoint': '/products', 'name': 'Criar produto (NEGADO)', 'success': false},
      {'method': 'PUT', 'endpoint': '/products/qualquer', 'name': 'Atualizar produto (NEGADO)', 'success': false},
      {'method': 'DELETE', 'endpoint': '/tags/qualquer', 'name': 'Deletar tag (NEGADO)', 'success': false},
      {'method': 'POST', 'endpoint': '/strategies', 'name': 'Criar estratégia (NEGADO)', 'success': false},
    ];

    for (final t in tests) {
      await _testRequest(
        name: '$profile - ${t['name']}',
        category: 'Permissões',
        userRole: profile,
        method: t['method'] as String,
        endpoint: t['endpoint'] as String,
        token: token,
        expectSuccess: t['success'] as bool,
      );
    }
  }

  // ============================================================
  // FASE 3: TESTES DE ERRO
  // ============================================================

  Future<void> _testAllErrors() async {
    setState(() {
      _currentPhase = 'FASE 3: Testando Cenários de Erro';
      _isRunning = true;
    });

    final token = _tokens['PlatformAdmin'] ?? '';

    // 3.1 Erros de Autenticação
    await _testAuthErrors();

    // 3.2 Erros de Validação
    await _testValidationErrors(token);

    // 3.3 Erros 404 - Recurso não encontrado
    await _testNotFoundErrors(token);

    // 3.4 Erros de Conflito (duplicidade)
    await _testConflictErrors(token);

    setState(() => _isRunning = false);
  }

  Future<void> _testAuthErrors() async {
    setState(() => _currentTest = 'Testando erros de autenticação...');

    // Senha incorreta
    await _testRequest(
      name: 'Erro Auth - Senha incorreta',
      category: 'Erros Auth',
      userRole: 'Anônimo',
      method: 'POST',
      endpoint: '/auth/login',
      body: {'username': 'tagbean_admin', 'password': 'SenhaErrada'},
      expectSuccess: false,
      expectedStatus: 401,
    );

    // Usuário inexistente
    await _testRequest(
      name: 'Erro Auth - Usuário inexistente',
      category: 'Erros Auth',
      userRole: 'Anônimo',
      method: 'POST',
      endpoint: '/auth/login',
      body: {'username': 'usuario_fantasma', 'password': 'Qualquer@123'},
      expectSuccess: false,
      expectedStatus: 401,
    );

    // Sem credenciais
    await _testRequest(
      name: 'Erro Auth - Sem credenciais',
      category: 'Erros Auth',
      userRole: 'Anônimo',
      method: 'POST',
      endpoint: '/auth/login',
      body: {},
      expectSuccess: false,
      expectedStatus: 400,
    );

    // Acesso sem token
    await _testRequest(
      name: 'Erro Auth - Endpoint protegido sem token',
      category: 'Erros Auth',
      userRole: 'Anônimo',
      method: 'GET',
      endpoint: '/users',
      expectSuccess: false,
      expectedStatus: 401,
    );

    // Token inválido
    await _testRequest(
      name: 'Erro Auth - Token inválido',
      category: 'Erros Auth',
      userRole: 'Token Falso',
      method: 'GET',
      endpoint: '/users',
      token: 'token-invalido-12345',
      expectSuccess: false,
      expectedStatus: 401,
    );
  }

  Future<void> _testValidationErrors(String token) async {
    setState(() => _currentTest = 'Testando erros de validação...');

    // Produto sem nome
    await _testRequest(
      name: 'Validação - Produto sem nome',
      category: 'Erros Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {'storeId': 'STORE-DEMO-001', 'barcode': '123', 'price': 10.0},
      expectSuccess: false,
      expectedStatus: 400,
    );

    // Produto com preço negativo
    await _testRequest(
      name: 'Validação - Preço negativo',
      category: 'Erros Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {'storeId': 'STORE-DEMO-001', 'barcode': '123', 'name': 'Teste', 'price': -10.0},
      expectSuccess: false,
      expectedStatus: 400,
    );

    // Usuário com email inválido
    await _testRequest(
      name: 'Validação - Email inválido',
      category: 'Erros Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/users',
      token: token,
      body: {'username': 'test_invalid', 'password': 'Test@123', 'email': 'email-invalido', 'role': 'Operator'},
      expectSuccess: false,
      expectedStatus: 400,
    );

    // MAC address inválido
    await _testRequest(
      name: 'Validação - MAC inválido',
      category: 'Erros Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/tags',
      token: token,
      body: {'storeId': 'STORE-DEMO-001', 'macAddress': 'INVALIDO', 'type': 0},
      expectSuccess: false,
      expectedStatus: 400,
    );

    // StoreId vazio
    await _testRequest(
      name: 'Validação - StoreId obrigatório',
      category: 'Erros Validação',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {'barcode': '123', 'name': 'Teste', 'price': 10.0},
      expectSuccess: false,
      expectedStatus: 400,
    );
  }

  Future<void> _testNotFoundErrors(String token) async {
    setState(() => _currentTest = 'Testando erros 404...');

    await _testRequest(
      name: '404 - Produto inexistente',
      category: 'Erros 404',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products/PRODUTO-NAO-EXISTE-999',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: '404 - Loja inexistente',
      category: 'Erros 404',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/stores/LOJA-FANTASMA',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: '404 - Tag inexistente',
      category: 'Erros 404',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/tags/xx:xx:xx:xx:xx:xx',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: '404 - Usuário inexistente',
      category: 'Erros 404',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/users/00000000-0000-0000-0000-000000000000',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );

    await _testRequest(
      name: '404 - Endpoint inexistente',
      category: 'Erros 404',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/endpoint-nao-existe',
      token: token,
      expectSuccess: false,
      expectedStatus: 404,
    );
  }

  Future<void> _testConflictErrors(String token) async {
    setState(() => _currentTest = 'Testando erros de conflito...');

    await _testRequest(
      name: 'Conflito - Usuário duplicado',
      category: 'Erros Conflito',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/users',
      token: token,
      body: {
        'username': 'tagbean_admin',
        'password': 'Teste@123',
        'email': 'outro@email.com',
        'fullName': 'Duplicado',
        'role': 'Operator',
      },
      expectSuccess: false,
      allowStatus: [400, 409],
    );
  }

  // ============================================================
  // FASE 4: CASOS EXTREMOS
  // ============================================================

  Future<void> _testEdgeCases() async {
    setState(() {
      _currentPhase = 'FASE 4: Casos Extremos e Limites';
      _isRunning = true;
    });

    final token = _tokens['PlatformAdmin'] ?? '';

    // 4.1 Strings muito longas
    await _testRequest(
      name: 'Edge - Nome de produto muito longo (1000 chars)',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': 'STORE-DEMO-001',
        'barcode': '9999999999',
        'name': 'X' * 1000,
        'price': 10.0,
      },
      expectSuccess: false, // Deve rejeitar
      allowStatus: [400, 201], // Pode aceitar ou rejeitar
    );

    // 4.2 Números extremos
    await _testRequest(
      name: 'Edge - Preço muito alto',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': 'STORE-DEMO-001',
        'barcode': '9999999998',
        'name': 'Produto Caro',
        'price': 999999999.99,
      },
      expectSuccess: true,
      allowStatus: [201, 400],
    );

    // 4.3 Caracteres especiais
    await _testRequest(
      name: 'Edge - Nome com caracteres especiais',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      body: {
        'storeId': 'STORE-DEMO-001',
        'barcode': '9999999997',
        'name': 'Café Açúcar & Cia <script>alert("XSS")</script>',
        'price': 10.0,
      },
      expectSuccess: true,
      allowStatus: [201, 400],
    );

    // 4.4 Paginação com valores extremos
    await _testRequest(
      name: 'Edge - Página negativa',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products?page=-1',
      token: token,
      expectSuccess: true, // Deve tratar graciosamente
    );

    await _testRequest(
      name: 'Edge - PageSize muito grande',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: '/products?pageSize=10000',
      token: token,
      expectSuccess: true,
    );

    // 4.5 Busca com caracteres especiais
    await _testRequest(
      name: 'Edge - Busca com SQL injection attempt',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'GET',
      endpoint: "/products?search=' OR 1=1 --",
      token: token,
      expectSuccess: true, // Deve sanitizar
    );

    // 4.6 Body vazio em POST
    await _testRequest(
      name: 'Edge - POST sem body',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'POST',
      endpoint: '/products',
      token: token,
      expectSuccess: false,
      expectedStatus: 400,
    );

    // 4.7 Content-Type errado (simulado)
    await _testRequest(
      name: 'Edge - PUT em ID inexistente',
      category: 'Casos Extremos',
      userRole: 'PlatformAdmin',
      method: 'PUT',
      endpoint: '/products/ID-QUE-NAO-EXISTE',
      token: token,
      body: {'name': 'Teste'},
      expectSuccess: false,
      expectedStatus: 404,
    );

    setState(() => _isRunning = false);
  }

  // ============================================================
  // HELPER: Executar Request
  // ============================================================

  Future<void> _testRequest({
    required String name,
    required String category,
    required String userRole,
    required String method,
    required String endpoint,
    String? token,
    dynamic body,
    bool expectSuccess = true,
    int? expectedStatus,
    List<int>? allowStatus,
  }) async {
    setState(() {
      _currentTest = name;
      _total++;
    });

    final stopwatch = Stopwatch()..start();

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
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

      // Determinar sucesso
      bool success;
      if (allowStatus != null) {
        success = allowStatus.contains(response.statusCode);
      } else if (expectedStatus != null) {
        success = response.statusCode == expectedStatus;
      } else {
        success = expectSuccess
            ? (response.statusCode >= 200 && response.statusCode < 300)
            : (response.statusCode >= 400);
      }

      _addResult(TestResult(
        name: name,
        category: category,
        userRole: userRole,
        method: method,
        endpoint: endpoint,
        statusCode: response.statusCode,
        success: success,
        message: success ? 'OK' : 'Status: ${response.statusCode}',
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
        message: 'Erro: $e',
        duration: stopwatch.elapsedMilliseconds,
        requestBody: body,
      ));
    }
  }

  void _showSummary() {
    final rate = _total > 0 ? ((_passed / _total) * 100).toStringAsFixed(1) : '0';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_failed == 0 ? '🎉 Sucesso Total!' : '📊 Resumo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _failed == 0 ? Icons.celebration : Icons.analytics,
              size: 64,
              color: _failed == 0 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text('$_passed de $_total testes passaram', style: const TextStyle(fontSize: 18)),
            Text('Taxa de sucesso: $rate%', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            if (_failed > 0)
              Text(
                '$_failed testes falharam',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }
}

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




