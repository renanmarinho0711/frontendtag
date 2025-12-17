/// Filtro de status para tags
enum FilterStatus {
  all('todas', 'Todas'),
  associated('associadas', 'Associadas'),
  available('disponiveis', 'Disponíveis'),
  offline('offline', 'Offline');

  const FilterStatus(this.id, this.label);
  
  final String id;
  final String label;
}
