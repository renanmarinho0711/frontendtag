// Dados de teste para produtos
class TestProducts {
  static const validProduct = {
    'name': 'Produto de Teste',
    'code': 'PROD001',
    'gtin': '7891234567890',
    'price': 99.90,
    'cost': 50.00,
    'stock': 100,
    'category': 'Bebidas',
    'description': 'Descrição do produto de teste',
  };
  
  static const minimalProduct = {
    'name': 'Produto Mínimo',
    'price': 10.00,
  };
  
  static const productForUpdate = {
    'name': 'Produto Atualizado',
    'price': 149.90,
    'stock': 200,
  };
  
  static const invalidProducts = [
    {'name': '', 'price': 10.00}, // sem nome
    {'name': 'Produto', 'price': null}, // sem preço
    {'name': 'Produto', 'price': -10.00}, // preço negativo
    {'name': 'Produto', 'gtin': '123'}, // GTIN inválido
  ];
  
  static const searchTerms = [
    'Coca-Cola',
    'Refrigerante',
    '7891234567890',
    'ProdutoQueNaoExiste12345',
  ];
  
  static const categories = [
    'Bebidas',
    'Alimentos',
    'Limpeza',
    'Higiene',
  ];
  
  static const stockStatuses = [
    'Todos',
    'Em estoque',
    'Baixo estoque',
    'Sem estoque',
  ];
}
