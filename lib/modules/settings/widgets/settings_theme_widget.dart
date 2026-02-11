import 'package:finance_app/components/components.dart';
import 'package:finance_app/modules/modules.dart';
import 'package:finance_app/modules/settings/widgets/settings_theme_mode_widget.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

/// Содержимое модального окна настроек темы.
class SettingsThemeWidget extends StatelessWidget {
  const SettingsThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: AppSizing.bottomPadding,
        left: AppSizing.defaultPadding,
        right: AppSizing.defaultPadding,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ModalSheetTitleWidget(
            title: 'App Theme',
            subtitle: 'Choose your preferred app theme',
          ),
          const SizedBox(height: AppSizing.spaceBtwSections),
          TitledSection(
            title: 'Theme mode',
            children: [
              SettingsThemeModeWidget(),
            ],
          ),
          const SizedBox(height: AppSizing.spaceBtwElements),
          TitledSection(
            title: 'Theme',
            children: [
              SettingsAppThemeModeWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
