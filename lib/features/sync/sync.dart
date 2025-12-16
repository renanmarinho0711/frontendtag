// Módulo de Sincronização do TagBean
/// 
/// Este módulo gerencia toda a sincronização de dados entre
/// o sistema local e a Minew Cloud.
/// 
/// ## Estrutura
/// 
/// ```
/// sync/
/// ├── data/
/// │   ├── exceptions/     # Exceções específicas
/// │   ├── models/         # DTOs e modelos de dados
/// │   ├── repositories/   # Acesso a dados
/// │   └── services/       # Serviços (logging, retry)
/// ├── domain/
/// │   └── usecases/       # Casos de uso
/// └── presentation/
///     ├── providers/      # Gerenciamento de estado
///     ├── screens/        # Telas
///     └── widgets/        # Widgets reutilizáveis
/// ```
library sync;

// Models
export 'data/models/sync_models.dart';
export 'data/models/minew_models.dart';

// Exceptions
export 'data/exceptions/sync_exceptions.dart';

// Repositories
export 'data/repositories/sync_repository.dart';
export 'data/repositories/minew_sync_repository.dart';
export 'data/repositories/sync_history_repository.dart';

// Services
export 'data/services/sync_logger.dart';
export 'data/services/retry_service.dart';

// Use Cases
export 'domain/usecases/sync_tags_usecase.dart';
export 'domain/usecases/sync_minew_usecase.dart';

// Providers
export 'presentation/providers/sync_provider.dart';
export 'presentation/providers/minew_provider.dart';

// Widgets
export 'presentation/widgets/widgets.dart';

// Screens
export 'presentation/screens/sync_control_screen.dart';
export 'presentation/screens/sync_log_screen.dart';
export 'presentation/screens/sync_settings_screen.dart';


