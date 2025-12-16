// Dados de teste para usuários
class TestUsers {
  static const admin = {
    'email': 'admin@soltag.com',
    'password': 'Senha@123',
    'name': 'Administrador',
    'role': 'admin',
  };
  
  static const manager = {
    'email': 'gerente@soltag.com',
    'password': 'Senha@123',
    'name': 'Gerente Teste',
    'role': 'manager',
  };
  
  static const operator = {
    'email': 'operador@soltag.com',
    'password': 'Senha@123',
    'name': 'Operador Teste',
    'role': 'operator',
  };
  
  static const invalidUser = {
    'email': 'naoexiste@soltag.com',
    'password': 'SenhaErrada',
  };
  
  static const invalidEmailFormats = [
    'email_invalido',
    'email@',
    '@dominio.com',
    'email sem @',
    '',
  ];
  
  static const invalidPasswords = [
    '', // vazia
    '123', // muito curta
    'semletra123', // sem maiúsculas/especiais
  ];
}
