import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/expenses.dart';

var colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      // Força o app a ficar em apenas uma orientação
      DeviceOrientation.portraitUp,
    ],
  ).then(
    (fn) {
      runApp(
        MaterialApp(
          theme: ThemeData().copyWith(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            cardTheme: const CardTheme().copyWith(
              color: darkColorScheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkColorScheme.primaryContainer,
                foregroundColor: darkColorScheme.onPrimaryContainer,
              ),
            ),
            textTheme: ThemeData().textTheme.copyWith(
                  titleLarge: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                    fontSize: 16,
                  ),
                ),
          ),
          home: const Expenses(),
        ),
      );
    },
  );
}
