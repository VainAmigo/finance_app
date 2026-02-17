import 'package:finance_app/domain/entities/category_entity.dart';

/// Сводка по категории: категория + сумма расходов/доходов.
/// Сумма считается по categoryId или по subCategoryId (если hasSubCategories).
class CategorySummaryEntity {
  final CategoryEntity category;
  final double totalAmount;

  const CategorySummaryEntity({
    required this.category,
    required this.totalAmount,
  });
}
