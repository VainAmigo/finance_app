import 'package:finance_app/components/components.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

class SettingasView extends StatelessWidget {
  const SettingasView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeScope = AppThemeScope.of(context);
    final state = themeScope.state;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizing.defaultPadding),
        children: [
          _SectionTitle(title: 'Режим темы'),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SegmentedButton<AppThemeMode>(
              segments: AppThemeMode.values
                  .map(
                    (mode) => ButtonSegment<AppThemeMode>(
                      value: mode,
                      label: Text(mode.label),
                      icon: Icon(_iconForThemeMode(mode)),
                    ),
                  )
                  .toList(),
              selected: {state.themeMode},
              onSelectionChanged: (Set<AppThemeMode> selected) {
                themeScope.setState(
                  (s) => s.copyWith(themeMode: selected.first),
                );
              },
            ),
          ),
          _SectionTitle(title: 'Палитра'),
          ...AppPalette.values.map((palette) {
            final isSelected = state.palette == palette;
            final previewTheme = AppThemes.themeFor(
              palette,
              Theme.of(context).brightness,
            );
            final previewColor = previewTheme.colorScheme.primary;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                tileColor: colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),

                  side: BorderSide(
                    color: isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: previewColor,
                  radius: 20,
                ),
                title: Text(
                  palette.label,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: colorScheme.primary)
                    : null,
                onTap: () {
                  themeScope.setState((s) => s.copyWith(palette: palette));
                },
              ),
            );
          }),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Выйти',
            onPressed: () {
              AppBottomSheet.showFittedModalBottomSheet(
                context,
                child: Container(),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _iconForThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
