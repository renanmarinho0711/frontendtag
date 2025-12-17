import 'package:tagbean/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagbean/features/products/data/models/product_model.dart';
import 'package:intl/intl.dart';
import 'package:tagbean/design_system/theme/theme_colors.dart';

/// @deprecated Use [ProdutoRepository] ao invés desta classe.
/// Esta classe usava dados mockados locais.
/// A aplicação agora usa ProdutoRepository para comunicação com o backend.
/// 
/// ATENÇÃO: Esta classe será removida em versões futuras.
/// Migre para: `import 'package:tagbean/features/products/data/repositories/products_repository.dart';`
@Deprecated('Use ProdutoRepository para comunicação com o backend. Esta classe será removida.')
class ProdutoService {
  static const String _keyProdutos = 'produtos';
  
  // Salvar produtos no SharedPreferences
  Future<void> salvarProdutos(List<ProdutoModel> produtos) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> produtosJson = produtos.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList(_keyProdutos, produtosJson);
  }

  // Carregar produtos do SharedPreferences
  Future<List<ProdutoModel>> carregarProdutos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? produtosJson = prefs.getStringList(_keyProdutos);
    
    if (produtosJson == null || produtosJson.isEmpty) {
      return _getProdutosIniciais();
    }
    
    return produtosJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return ProdutoModel.fromMap(map);
    }).toList();
  }

  // Adicionar produto
  Future<void> adicionarProduto(ProdutoModel produto) async {
    final produtos = await carregarProdutos();
    produtos.add(produto);
    await salvarProdutos(produtos);
  }

  // Atualizar produto
  Future<void> atualizarProduto(String codigo, ProdutoModel produtoAtualizado) async {
    final produtos = await carregarProdutos();
    final index = produtos.indexWhere((p) => p.codigo == codigo);
    
    if (index != -1) {
      produtos[index] = produtoAtualizado;
      await salvarProdutos(produtos);
    }
  }

  // Excluir produto
  Future<void> excluirProduto(String codigo) async {
    final produtos = await carregarProdutos();
    produtos.removeWhere((p) => p.codigo == codigo);
    await salvarProdutos(produtos);
  }

  // Buscar produto por código
  Future<ProdutoModel?> buscarProdutoPorCodigo(String codigo) async {
    final produtos = await carregarProdutos();
    try {
      return produtos.firstWhere((p) => p.codigo == codigo);
    } catch (e) {
      return null;
    }
  }

  // Associar tag ao produto
  Future<void> associarTag(String codigoProduto, String tagId) async {
    final produtos = await carregarProdutos();
    final index = produtos.indexWhere((p) => p.codigo == codigoProduto);
    
    if (index != -1) {
      final produtoAtualizado = produtos[index].copyWith(
        tag: tagId,
        status: 'Ativo',
        ultimaAtualizacao: _getDataHoraAtual(),
      );
      produtos[index] = produtoAtualizado;
      await salvarProdutos(produtos);
    }
  }

  // Desassociar tag do produto
  Future<void> desassociarTag(String codigoProduto) async {
    final produtos = await carregarProdutos();
    final index = produtos.indexWhere((p) => p.codigo == codigoProduto);
    
    if (index != -1) {
      final produtoAtualizado = produtos[index].copyWith(
        tag: null,
        status: 'Sem Tag',
        ultimaAtualizacao: _getDataHoraAtual(),
      );
      produtos[index] = produtoAtualizado;
      await salvarProdutos(produtos);
    }
  }

  // Obter estatísticas
  Future<Map<String, int>> getEstatisticas() async {
    final produtos = await carregarProdutos();
    
    final total = produtos.length;
    final comTag = produtos.where((p) => p.tag != null).length;
    final semTag = produtos.where((p) => p.tag == null).length;
    
    return {
      'total': total,
      'comTag': comTag,
      'semTag': semTag,
    };
  }

  // Helper para obter data/hora atual formatada
  String _getDataHoraAtual() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(now);
  }

  // Produtos iniciais para demonstração
  List<ProdutoModel> _getProdutosIniciais() {
    return [
      ProdutoModel(
        codigo: '7891234567890',
        nome: 'Cerveja Skol 350ml',
        preco: 3.50,
        precoKg: null,
        categoria: 'Bebidas',
        tag: 'TAG-001',
        status: 'Ativo',
        descricao: 'Cerveja pilsen premium',
        ultimaAtualizacao: '23/11/2025 10:30',
        cor: AppThemeColors.blueMaterial,
        icone: Icons.local_drink_rounded,
        historicoPrecos: [
          HistoricoPreco(
            data: '23/11/2025 10:30',
            precoAnterior: 3.20,
            precoNovo: 3.50,
            usuario: 'Admin',
          ),
          HistoricoPreco(
            data: '20/11/2025 14:15',
            precoAnterior: 3.00,
            precoNovo: 3.20,
            usuario: 'Sistema',
          ),
          HistoricoPreco(
            data: '15/11/2025 09:00',
            precoAnterior: 2.80,
            precoNovo: 3.00,
            usuario: 'Admin',
          ),
        ],
      ),
      ProdutoModel(
        codigo: '7899876543210',
        nome: 'Arroz Tio João 5kg',
        preco: 25.90,
        precoKg: 5.18,
        categoria: 'Mercearia',
        tag: 'TAG-015',
        status: 'Ativo',
        descricao: 'Arroz tipo 1, grãos longos',
        ultimaAtualizacao: '23/11/2025 09:15',
        cor: AppThemeColors.brownMain,
        icone: Icons.shopping_basket_rounded,
      ),
      ProdutoModel(
        codigo: '7891000100103',
        nome: 'Coca-Cola 2L',
        preco: 8.99,
        precoKg: null,
        categoria: 'Bebidas',
        tag: null,
        status: 'Sem Tag',
        descricao: 'Refrigerante cola 2 litros',
        ultimaAtualizacao: '21/11/2025 15:45',
        cor: AppThemeColors.blueMaterial,
        icone: Icons.local_drink_rounded,
      ),
      ProdutoModel(
        codigo: '7891000100104',
        nome: 'Feijão Preto 1kg',
        preco: 7.50,
        precoKg: 7.50,
        categoria: 'Mercearia',
        tag: 'TAG-032',
        status: 'Ativo',
        descricao: 'Feijão preto tipo 1',
        ultimaAtualizacao: '23/11/2025 08:00',
        cor: AppThemeColors.brownMain,
        icone: Icons.shopping_basket_rounded,
      ),
    ];
  }
}



