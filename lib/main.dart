import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

// Core imports
import 'package:tagbean/core/core.dart';

// App imports
import 'package:tagbean/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Localização para datas em português
  await initializeDateFormatting('pt_BR', null);

  // Configurar logger
  LoggerService.info('Iniciando TagBean App', tag: 'MAIN');

  // Configurações de sistema - permite todas as orientações
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Configurações de UI do sistema
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFFFFFF),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Configurar error handler global
  FlutterError.onError = (details) {
    LoggerService.error(
      'Flutter Error',
      tag: 'FLUTTER',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Envolver app com ProviderScope para Riverpod
  runApp(const ProviderScope(child: TagBeanApp()));
}



