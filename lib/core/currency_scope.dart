import 'package:finance_app/models/models.dart';
import 'package:flutter/material.dart';

/// Предоставляет доступ к выбранной валюте и методам её изменения.
class CurrencyScope extends InheritedWidget {
  const CurrencyScope({
    required this.currency,
    required this.setCurrency,
    required super.child,
    super.key,
  });

  final Currency currency;
  final void Function(Currency currency) setCurrency;

  static CurrencyScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CurrencyScope>();
    assert(
      scope != null,
      'CurrencyScope not found. Wrap app with CurrencyScope.',
    );
    return scope!;
  }

  /// Возвращает [CurrencyScope] или null, если он не найден.
  static CurrencyScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CurrencyScope>();
  }

  @override
  bool updateShouldNotify(CurrencyScope oldWidget) =>
      currency.code != oldWidget.currency.code;
}
