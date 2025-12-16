// Dados de teste para tags
class TestTags {
  static const validTag = {
    'macAddress': 'AA:BB:CC:DD:EE:FF',
    'type': 'gd29',
    'status': 'available',
    'battery': 100,
  };
  
  static const tagForBinding = {
    'macAddress': 'FF:EE:DD:CC:BB:AA',
    'productGtin': '7891234567890',
  };
  
  static const tagStatuses = [
    'Todas',
    'Disponíveis',
    'Vinculadas',
    'Offline',
    'Baixa bateria',
  ];
  
  static const tagTypes = [
    'gd29',
    'gd42',
    'gd75',
  ];
  
  static const importFormats = [
    'csv',
    'json',
    'xlsx',
  ];
  
  static const csvImportData = '''
mac_address,type,store_location
AA:BB:CC:DD:EE:01,gd29,A1-01
AA:BB:CC:DD:EE:02,gd29,A1-02
AA:BB:CC:DD:EE:03,gd42,A2-01
''';
  
  static const diagnosticTests = [
    'Bateria',
    'Conexão',
    'Atualização de preço',
    'Resposta do sensor',
  ];
}
