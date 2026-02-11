import 'package:finance_app/components/components.dart';
import 'package:finance_app/themes/app_theme/app_theme_mode.dart';
import 'package:finance_app/themes/app_theme/theme_scope.dart';
import 'package:flutter/material.dart';

/// Виджет выбора режима темы для раздела настроек.
class SettingsThemeModeWidget extends StatelessWidget {
  const SettingsThemeModeWidget({super.key});

  static const _segments = [
    SegmentItem<AppThemeMode>(
      value: AppThemeMode.system,
      label: 'System',
      icon: Icons.palette_outlined,
    ),
    SegmentItem<AppThemeMode>(
      value: AppThemeMode.dark,
      label: 'Dark',
      icon: Icons.dark_mode_outlined,
    ),
    SegmentItem<AppThemeMode>(
      value: AppThemeMode.light,
      label: 'Light',
      icon: Icons.light_mode_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scope = AppThemeScope.of(context);

    return SegmentedControl<AppThemeMode>(
      segments: _segments,
      selectedValue: scope.state.themeMode,
      onChanged: (mode) {
        scope.setState((s) => s.copyWith(themeMode: mode));
      },
    );
  }
}
