import 'package:finance_app/presentation/presentaion.dart';
import 'package:flutter/material.dart';

class AddTransactionDateSheetWidget extends StatelessWidget {
  const AddTransactionDateSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSizing.bottomPadding,
        left: AppSizing.defaultPadding,
        right: AppSizing.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ModalSheetTitleWidget(
            title: 'Select date',
          ),
          const SizedBox(height: AppSizing.spaceBtwSections),
          PrimaryButton(
            text: 'Choose date',
            onPressed: () {},
            size: PrimaryButtonSize.large,
            icon: Icons.calendar_month,
            backgroundColor: colorScheme.secondary,
          ),
          const SizedBox(height: AppSizing.spaceBtwElementsExtra),
          _buildDateRowWidget(context),
        ],
      ),
    );
  }

  Widget _buildDateRowWidget(BuildContext context) {
    return Row(
      spacing: AppSizing.spaceBtwElementsExtra,
      children: [
        Expanded(
          child: _buildDateRowElement(context, false, 'Yesterday', () {}),
        ),
        Expanded(child: _buildDateRowElement(context, true, 'Today', () {})),
      ],
    );
  }

  Widget _buildDateRowElement(
    BuildContext context,
    bool isSelected,
    String title,
    Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizing.borderRadius16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizing.spaceBtwElements,
          vertical: AppSizing.spaceBtwElementsExtra,
        ),
        height: AppSizing.heightM,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: isSelected
              ? BorderRadius.circular(AppSizing.borderRadius100)
              : BorderRadius.circular(AppSizing.borderRadius16),
        ),
        child: Center(
          child: Text(title, style: AppTextStyles.text16w400(context)),
        ),
      ),
    );
  }
}
