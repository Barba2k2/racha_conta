import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:racha_conta/src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  

  await FlutterConfig.loadEnvVariables();

  FlutterError.onError = (FlutterErrorDetails details) {
    log(details.exception.toString());
    log(details.stack.toString());
  };

  runApp(MyApp());
}
