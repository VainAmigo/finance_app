import 'package:finance_app/components/components.dart';
import 'package:finance_app/modules/settings/widgets/settings_theme_widget.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

class SettingasView extends StatelessWidget {
  const SettingasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.defaultPadding,
          ),
          child: Column(
            children: [
              TabTitleWidget(
                title: 'Settings',
                subtitle: 'Manage your account and preferences',
              ),
              const SizedBox(height: AppSizing.spaceBtwSections),

              TitledSection(
                title: 'App settings',
                children: [
                  _buildSettingsList(
                    context,
                    'App Theme',
                    Icons.palette,
                    isFirst: true,
                    onTap: () {
                      AppBottomSheet.showFittedModalBottomSheet(
                        context,
                        child: const SettingsThemeWidget(),
                      );
                    },
                  ),
                  const SizedBox(height: AppSizing.spaceBtwElementsExtra),
                  _buildSettingsList(context, 'Language', Icons.language),
                  const SizedBox(height: AppSizing.spaceBtwElementsExtra),
                  _buildSettingsList(
                    context,
                    'Currency and formats',
                    Icons.attach_money,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSizing.spaceBtwElements),

              TitledSection(
                title: 'Privacy',
                children: [
                  _buildSettingsList(
                    context,
                    'Privacy Policy',
                    Icons.privacy_tip,
                    isFirst: true,
                  ),
                  const SizedBox(height: AppSizing.spaceBtwElementsExtra),
                  _buildSettingsList(
                    context,
                    'Security',
                    Icons.security,
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList(
    BuildContext context,
    String title,
    IconData icon, {
    bool isLast = false,
    bool isFirst = false,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: isFirst
              ? Radius.circular(AppSizing.borderRadius12)
              : Radius.circular(AppSizing.borderRadius4),
          bottom: isLast
              ? Radius.circular(AppSizing.borderRadius12)
              : Radius.circular(AppSizing.borderRadius4),
        ),
        side: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
      ),
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
      title: Text(title, style: AppTextStyles.listTileTitle(context)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
