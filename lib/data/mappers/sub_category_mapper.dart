import 'package:finance_app/data/models/sub_category_model.dart';
import 'package:finance_app/domain/entities/sub_category_entity.dart';

/// Преобразование между SubCategoryModel (Data) и SubCategoryEntity (Domain).
class SubCategoryMapper {
  const SubCategoryMapper();

  SubCategoryEntity toEntity(SubCategoryModel model) {
    return SubCategoryEntity(
      categoryId: model.categoryId,
      createdAt: model.createdAt,
      name: model.name,
      subCategoryId: model.subCategoryId,
    );
  }

  SubCategoryModel toModel(SubCategoryEntity entity) {
    return SubCategoryModel(
      categoryId: entity.categoryId,
      createdAt: entity.createdAt,
      name: entity.name,
      subCategoryId: entity.subCategoryId,
    );
  }
}
