import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_theme_mode.dart';

/// Состояние темы приложения: режим (система/светлая/тёмная) и палитра.
class AppThemeState {
  const AppThemeState({
    this.themeMode = AppThemeMode.system,
    this.palette = AppPalette.mintGreen,
  });

  final AppThemeMode themeMode;
  final AppPalette palette;

  AppThemeState copyWith({
    AppThemeMode? themeMode,
    AppPalette? palette,
  }) {
    return AppThemeState(
      themeMode: themeMode ?? this.themeMode,
      palette: palette ?? this.palette,
    );
  }
}

/// Предоставляет доступ к настройкам темы и методам их изменения.
class AppThemeScope extends InheritedWidget {
  const AppThemeScope({
    required this.state,
    required this.setState,
    required super.child,
    super.key,
  });

  final AppThemeState state;
  final void Function(AppThemeState Function(AppThemeState) update) setState;

  static AppThemeScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'AppThemeScope not found. Wrap app with AppThemeScope.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) =>
      state.themeMode != oldWidget.state.themeMode ||
      state.palette != oldWidget.state.palette;
}
