part of 'categories_cubit.dart';

/// Модель категории с подкатегориями для отображения в UI.
class CategoryWithSubCategories {
  const CategoryWithSubCategories(this.category, this.subCategories);

  final CategoryEntity category;
  final List<SubCategoryEntity> subCategories;
}

sealed class CategoriesState {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded(this.items);

  final List<CategoryWithSubCategories> items;
}

class CategoriesError extends CategoriesState {
  const CategoriesError(this.message);

  final String message;
}
