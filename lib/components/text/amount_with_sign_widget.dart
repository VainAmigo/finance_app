import 'package:finance_app/core/core.dart';
import 'package:flutter/material.dart';

/// Виджет для отображения суммы с разным цветом для целой и дробной части.
///
/// Целая часть отображается белым (onSurface), дробная часть и символ
/// валюты — серым (onSecondary).
class AmountWithSignWidget extends StatelessWidget {
  const AmountWithSignWidget({
    super.key,
    required this.amount,
    required this.sign,
    this.preset = AmountTextPreset.large,
    this.decimalPlaces = 2,
  });

  final double amount;
  final String sign;

  /// Пресет размера текста.
  final AmountTextPreset preset;

  /// Количество знаков после запятой.
  final int decimalPlaces;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formatted = AmountFormatter.formatWithParts(
      amount,
      decimalPlaces: decimalPlaces,
    );

    final fontSize = amountTextSize(preset);
    final decimalFontSize = amountDecimalTextSize(preset);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: formatted.integerPart,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontFamily: theme.textTheme.bodyLarge?.fontFamily,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '${formatted.decimalPart}$sign',
            style: TextStyle(
              color: colorScheme.onSecondary,
              fontFamily: theme.textTheme.bodyLarge?.fontFamily,
              fontSize: decimalFontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Пресеты размеров текста для отображения сумм.
  static const double amountTextSmall = 14.0;
  static const double amountTextMedium = 18.0;
  static const double amountTextLarge = 44.0;

  static double amountTextSize(AmountTextPreset preset) {
    return switch (preset) {
      AmountTextPreset.small => amountTextSmall,
      AmountTextPreset.medium => amountTextMedium,
      AmountTextPreset.large => amountTextLarge,
    };
  }
  static double amountDecimalTextSize(AmountTextPreset preset) {
    return switch (preset) {
      AmountTextPreset.small => amountTextSmall,
      AmountTextPreset.medium => amountTextMedium * 0.8,
      AmountTextPreset.large => amountTextLarge * 0.6,
    };
  }
}

/// Пресеты размеров текста для отображения денежных сумм.
enum AmountTextPreset { small, medium, large }
