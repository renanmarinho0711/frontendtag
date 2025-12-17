/// Constantes de strings para internacionalização
/// TODO: Migrar para sistema de i18n completo (flutter_localizations)
class AppStrings {
  AppStrings._();

  // ==================== App ====================
  static const appName = 'TagBean';
  static const appTagline = 'Gestão Inteligente de Etiquetas Eletrônicas';

  // ==================== Auth ====================
  static const login = 'Entrar';
  static const logout = 'Sair';
  static const register = 'Cadastrar';
  static const email = 'E-mail';
  static const password = 'Senha';
  static const confirmPassword = 'Confirmar Senha';
  static const forgotPassword = 'Esqueci minha senha';
  static const resetPassword = 'Redefinir Senha';
  static const rememberMe = 'Lembrar-me';
  static const welcomeBack = 'Bem-vindo de volta!';
  static const createAccount = 'Criar Conta';
  static const alreadyHaveAccount = 'Já tem uma conta?';
  static const dontHaveAccount = 'Não tem uma conta?';

  // ==================== Validation ====================
  static const requiredField = 'Campo obrigatório';
  static const invalidEmail = 'E-mail inválido';
  static const invalidPassword = 'Senha deve ter no mínimo 6 caracteres';
  static const passwordsDontMatch = 'As senhas não coincidem';
  static const invalidPhone = 'Telefone inválido';
  static const invalidCpf = 'CPF inválido';
  static const invalidCnpj = 'CNPJ inválido';
  static const invalidCep = 'CEP inválido';
  static const invalidGtin = 'GTIN inválido';
  static const invalidMac = 'MAC Address inválido';

  // ==================== Actions ====================
  static const save = 'Salvar';
  static const cancel = 'Cancelar';
  static const confirm = 'Confirmar';
  static const delete = 'Excluir';
  static const edit = 'Editar';
  static const add = 'Adicionar';
  static const create = 'Criar';
  static const update = 'Atualizar';
  static const search = 'Buscar';
  static const filter = 'Filtrar';
  static const clear = 'Limpar';
  static const refresh = 'Atualizar';
  static const retry = 'Tentar novamente';
  static const close = 'Fechar';
  static const back = 'Voltar';
  static const next = 'Próximo';
  static const previous = 'Anterior';
  static const finish = 'Finalizar';
  static const submit = 'Enviar';
  static const apply = 'Aplicar';
  static const select = 'Selecionar';
  static const selectAll = 'Selecionar todos';
  static const deselectAll = 'Desselecionar todos';
  static const copy = 'Copiar';
  static const share = 'Compartilhar';
  static const export = 'Exportar';
  static const import_ = 'Importar'; // import é keyword
  static const download = 'Baixar';
  static const upload = 'Enviar';
  static const print = 'Imprimir';
  static const sync = 'Sincronizar';

  // ==================== Status ====================
  static const active = 'Ativo';
  static const inactive = 'Inativo';
  static const pending = 'Pendente';
  static const completed = 'Concluído';
  static const error = 'Erro';
  static const success = 'Sucesso';
  static const warning = 'Aviso';
  static const info = 'Informação';
  static const loading = 'Carregando...';
  static const processing = 'Processando...';
  static const syncing = 'Sincronizando...';
  static const online = 'Online';
  static const offline = 'Offline';

  // ==================== Messages ====================
  static const savedSuccessfully = 'Salvo com sucesso!';
  static const deletedSuccessfully = 'Excluído com sucesso!';
  static const updatedSuccessfully = 'Atualizado com sucesso!';
  static const createdSuccessfully = 'Criado com sucesso!';
  static const syncedSuccessfully = 'Sincronizado com sucesso!';
  static const copiedToClipboard = 'Copiado para a área de transferência';
  
  static const confirmDelete = 'Tem certeza que deseja excluir?';
  static const confirmLogout = 'Tem certeza que deseja sair?';
  static const unsavedChanges = 'Você tem alterações não salvas. Deseja descartar-las?';
  
  static const noItemsFound = 'Nenhum item encontrado';
  static const noResultsFound = 'Nenhum resultado encontrado';
  static const somethingWentWrong = 'Algo deu errado';
  static const tryAgainLater = 'Tente novamente mais tarde';
  static const checkConnection = 'Verifique sua conexão com a internet';
  static const sessionExpired = 'Sua sessão expirou. Faça login novamente.';

  // ==================== Navigation ====================
  static const home = 'Início';
  static const dashboard = 'Dashboard';
  static const products = 'Produtos';
  static const tags = 'Etiquetas';
  static const stores = 'Lojas';
  static const categories = 'Categorias';
  static const strategies = 'Estratégias';
  static const pricing = 'Precificação';
  static const reports = 'Relatórios';
  static const settings = 'Configurações';
  static const profile = 'Perfil';
  static const notifications = 'Notificações';
  static const help = 'Ajuda';
  static const about = 'Sobre';

  // ==================== Products ====================
  static const productName = 'Nome do Produto';
  static const productCode = 'Código';
  static const barcode = 'Código de Barras';
  static const gtin = 'GTIN';
  static const sku = 'SKU';
  static const price = 'Preço';
  static const originalPrice = 'Preço Original';
  static const promotionalPrice = 'Preço Promocional';
  static const costPrice = 'Preço de Custo';
  static const margin = 'Margem';
  static const stock = 'Estoque';
  static const category = 'Categoria';
  static const brand = 'Marca';
  static const supplier = 'Fornecedor';
  static const unit = 'Unidade';
  static const weight = 'Peso';
  static const dimensions = 'Dimensões';
  static const description = 'Descrição';

  // ==================== Tags ====================
  static const tagId = 'ID da Etiqueta';
  static const macAddress = 'MAC Address';
  static const tagStatus = 'Status da Etiqueta';
  static const tagSize = 'Tamanho';
  static const tagTemplate = 'Template';
  static const tagBattery = 'Bateria';
  static const tagSignal = 'Sinal';
  static const lastSync = 'Última Sincronização';
  static const assignedProduct = 'Produto Vinculado';
  static const unassigned = 'Não Vinculado';
  static const bindTag = 'Vincular Etiqueta';
  static const unbindTag = 'Desvincular Etiqueta';

  // ==================== Stores ====================
  static const storeName = 'Nome da Loja';
  static const storeCode = 'Código da Loja';
  static const address = 'endereco';
  static const city = 'Cidade';
  static const state = 'Estado';
  static const zipCode = 'CEP';
  static const phone = 'Telefone';
  static const manager = 'Gerente';
  static const gateways = 'Gateways';

  // ==================== Time ====================
  static const today = 'Hoje';
  static const yesterday = 'Ontem';
  static const tomorrow = 'Amanhã';
  static const thisWeek = 'Esta semana';
  static const thisMonth = 'Este mês';
  static const thisYear = 'Este ano';
  static const lastDays = 'Últimos {0} dias';
  static const allTime = 'Todo período';

  // ==================== Filters ====================
  static const filterBy = 'Filtrar por';
  static const sortBy = 'Ordenar por';
  static const orderBy = 'Ordem';
  static const ascending = 'Crescente';
  static const descending = 'Decrescente';
  static const all = 'Todos';
  static const none = 'Nenhum';
  static const clearFilters = 'Limpar filtros';
  static const applyFilters = 'Aplicar filtros';

  // ==================== Units ====================
  static const piece = 'Unidade';
  static const pieces = 'Unidades';
  static const kilogram = 'Quilograma';
  static const gram = 'Grama';
  static const liter = 'Litro';
  static const milliliter = 'Mililitro';
  static const meter = 'Metro';
  static const centimeter = 'Centímetro';
  static const box = 'Caixa';
  static const pack = 'Pacote';

  // ==================== Errors ====================
  static const errorNetwork = 'Erro de conexão. Verifique sua internet.';
  static const errorTimeout = 'Tempo esgotado. Tente novamente.';
  static const errorServer = 'Erro no servidor. Tente novamente mais tarde.';
  static const errorUnauthorized = 'Acesso não autorizado.';
  static const errorForbidden = 'Você não tem permissão para esta ação.';
  static const errorNotFound = 'Recurso não encontrado.';
  static const errorValidation = 'Dados inválidos. Verifique as informações.';
  static const errorUnknown = 'Erro desconhecido. Tente novamente.';
}



