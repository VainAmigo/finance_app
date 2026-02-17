import 'package:finance_app/data/models/category_model.dart';
import 'package:finance_app/domain/entities/category_entity.dart';

/// Преобразование между CategoryModel (Data) и CategoryEntity (Domain).
class CategoryMapper {
  const CategoryMapper();

  CategoryEntity toEntity(CategoryModel model) {
    return CategoryEntity(
      categoryId: model.categoryId,
      colorId: model.colorId,
      createdAt: model.createdAt,
      currency: model.currency,
      hasSubCategories: model.hasSubCategories,
      iconId: model.iconId,
      name: model.name,
      limitType: model.limitType,
      limitValue: model.limitValue,
    );
  }

  CategoryModel toModel(CategoryEntity entity) {
    return CategoryModel(
      categoryId: entity.categoryId,
      colorId: entity.colorId,
      createdAt: entity.createdAt,
      currency: entity.currency,
      hasSubCategories: entity.hasSubCategories,
      iconId: entity.iconId,
      name: entity.name,
      limitType: entity.limitType,
      limitValue: entity.limitValue,
    );
  }
}
