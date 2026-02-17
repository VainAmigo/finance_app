import 'package:finance_app/domain/entities/entity.dart';

/// Тип лимита категории.
enum LimitType {
  amount,
  percent,
}

class CategoryEntity extends Entity {
  final String categoryId;
  final String colorId;
  final DateTime createdAt;
  final String currency;
  final bool hasSubCategories;
  final String iconId;
  final String name;
  final LimitType? limitType;
  final double? limitValue;

  const CategoryEntity({
    required this.categoryId,
    required this.colorId,
    required this.createdAt,
    required this.currency,
    required this.hasSubCategories,
    required this.iconId,
    required this.name,
    required this.limitType,
    required this.limitValue,
  });
}