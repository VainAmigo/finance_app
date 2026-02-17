import 'package:finance_app/domain/entities/sub_category_entity.dart';

/// Сводка по подкатегории: подкатегория + сумма транзакций.
class SubCategorySummaryEntity {
  final SubCategoryEntity subCategory;
  final double totalAmount;

  const SubCategorySummaryEntity({
    required this.subCategory,
    required this.totalAmount,
  });
}
