import 'package:finance_app/modules/modules.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsAppThemeModeWidget extends StatelessWidget {
  const SettingsAppThemeModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final state = themeProvider.state;
    final palettes = AppPalette.values;
    final segmentCount = palettes.length;

    return Row(
      children: palettes.asMap().entries.map((entry) {
        final index = entry.key;
        final palette = entry.value;
        final isSelected = state.palette == palette;
        final previewTheme = AppThemes.themeFor(
          palette,
          Theme.of(context).brightness,
        );
        final blockColor = previewTheme.colorScheme.primary;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < segmentCount - 1 ? AppSizing.spaceBtwElementsExtra : 0,
            ),
            child: _ColorBlock(
              color: blockColor,
              isSelected: isSelected,
              onTap: () => themeProvider.setState((s) => s.copyWith(palette: palette)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorBlock extends StatelessWidget {
  const _ColorBlock({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = isSelected
        ? BorderRadius.circular(AppSizing.borderRadius100)
        : BorderRadius.circular(AppSizing.borderRadius8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizing.borderRadius100),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
            ),
          ),
        ),
      ),
    );
  }
}
