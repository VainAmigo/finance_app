import 'package:finance_app/domain/entities/category_entity.dart';

/// Интерфейс репозитория категорий.
abstract class CategoryRepository {
  Future<void> addCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String categoryId);
  Future<CategoryEntity?> getCategory(String categoryId);
  Future<List<CategoryEntity>> getCategories();
  Stream<List<CategoryEntity>> watchCategories();
}
