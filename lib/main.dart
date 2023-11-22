import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/app.dart';

import 'src/firebase_options.dart';
import 'src/repository/authentication_repository/authentication_repository.dart';

Future<void> main() async {
  // Garante a inicialização do binding de widgets do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as opções padrão para a plataforma atual e coloca o `AuthenticationRepository` no GetX para gerenciamento de estado
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (_) => Get.put(
      AuthenticationRepository(),
    ),
  );

  // Carrega variáveis de ambiente usando FlutterConfig
  await FlutterConfig.loadEnvVariables();

  // Configura um manipulador global de erros para registrar exceções no Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    log('Detalhes de exceção: ${details.exception}');
    log('Detalhes de stack: ${details.stack}');
    log('Informação adicional: ${details.informationCollector?.call() ?? "Vazio"}');
    log('Contexto do erro: ${details.context}');
    log('Biblioteca do erro: ${details.library}');
    log('Silent Error: ${details.silent}');
    log('Filtro de Stack: ${details.stackFilter}');
  };

  // Inicia o aplicativo
  runApp(MyApp());
}
