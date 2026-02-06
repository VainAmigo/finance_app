import 'package:finance_app/modules/modules.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeState _themeState = const AppThemeState();

  void _setThemeState(AppThemeState Function(AppThemeState) update) {
    setState(() => _themeState = update(_themeState));
  }

  ThemeMode get _themeMode {
    switch (_themeState.themeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      state: _themeState,
      setState: _setThemeState,
      child: MaterialApp(
        title: 'Finance Tracker',
        theme: AppThemes.themeFor(_themeState.palette, Brightness.light),
        darkTheme: AppThemes.themeFor(_themeState.palette, Brightness.dark),
        themeMode: _themeMode,
        home: const MainView(),
      ),
    );
  }
}
