import 'package:finance_app/data/datasources/remote/firebase_category_datasource.dart';
import 'package:finance_app/data/mappers/category_mapper.dart';
import 'package:finance_app/domain/entities/category_entity.dart';
import 'package:finance_app/domain/repositories/category_repository.dart';

/// Реализация CategoryRepository.
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    FirebaseCategoryDatasource? datasource,
    CategoryMapper? mapper,
  })  : _datasource = datasource ?? FirebaseCategoryDatasource(),
        _mapper = mapper ?? const CategoryMapper();

  final FirebaseCategoryDatasource _datasource;
  final CategoryMapper _mapper;

  @override
  Future<void> addCategory(CategoryEntity category) async {
    await _datasource.addCategory(_mapper.toModel(category));
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await _datasource.updateCategory(_mapper.toModel(category));
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await _datasource.deleteCategory(categoryId);
  }

  @override
  Future<CategoryEntity?> getCategory(String categoryId) async {
    final model = await _datasource.getCategory(categoryId);
    return model != null ? _mapper.toEntity(model) : null;
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await _datasource.getCategories();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return _datasource.watchCategories().map(
          (models) => models.map(_mapper.toEntity).toList(),
        );
  }
}
