import 'package:finance_app/domain/entities/sub_category_entity.dart';

/// Интерфейс репозитория подкатегорий.
abstract class SubCategoryRepository {
  Future<void> addSubCategory(SubCategoryEntity subCategory);
  Future<void> updateSubCategory(SubCategoryEntity subCategory);
  Future<void> deleteSubCategory(String subCategoryId);
  Future<SubCategoryEntity?> getSubCategory(String subCategoryId);
  Future<List<SubCategoryEntity>> getSubCategories();
  Future<List<SubCategoryEntity>> getSubCategoriesByCategory(String categoryId);
  Stream<List<SubCategoryEntity>> watchSubCategories();
  Stream<List<SubCategoryEntity>> watchSubCategoriesByCategory(
    String categoryId,
  );
}
