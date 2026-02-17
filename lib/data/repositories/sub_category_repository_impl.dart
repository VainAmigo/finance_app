import 'package:finance_app/data/datasources/remote/firebase_sub_category_datasource.dart';
import 'package:finance_app/data/mappers/sub_category_mapper.dart';
import 'package:finance_app/domain/entities/sub_category_entity.dart';
import 'package:finance_app/domain/repositories/sub_category_repository.dart';

/// Реализация SubCategoryRepository.
class SubCategoryRepositoryImpl implements SubCategoryRepository {
  SubCategoryRepositoryImpl({
    FirebaseSubCategoryDatasource? datasource,
    SubCategoryMapper? mapper,
  })  : _datasource = datasource ?? FirebaseSubCategoryDatasource(),
        _mapper = mapper ?? const SubCategoryMapper();

  final FirebaseSubCategoryDatasource _datasource;
  final SubCategoryMapper _mapper;

  @override
  Future<void> addSubCategory(SubCategoryEntity subCategory) async {
    await _datasource.addSubCategory(_mapper.toModel(subCategory));
  }

  @override
  Future<void> updateSubCategory(SubCategoryEntity subCategory) async {
    await _datasource.updateSubCategory(_mapper.toModel(subCategory));
  }

  @override
  Future<void> deleteSubCategory(String subCategoryId) async {
    await _datasource.deleteSubCategory(subCategoryId);
  }

  @override
  Future<SubCategoryEntity?> getSubCategory(String subCategoryId) async {
    final model = await _datasource.getSubCategory(subCategoryId);
    return model != null ? _mapper.toEntity(model) : null;
  }

  @override
  Future<List<SubCategoryEntity>> getSubCategories() async {
    final models = await _datasource.getSubCategories();
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<SubCategoryEntity>> getSubCategoriesByCategory(
    String categoryId,
  ) async {
    final models =
        await _datasource.getSubCategoriesByCategory(categoryId);
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Stream<List<SubCategoryEntity>> watchSubCategories() {
    return _datasource.watchSubCategories().map(
          (models) => models.map(_mapper.toEntity).toList(),
        );
  }

  @override
  Stream<List<SubCategoryEntity>> watchSubCategoriesByCategory(
    String categoryId,
  ) {
    return _datasource.watchSubCategoriesByCategory(categoryId).map(
          (models) => models.map(_mapper.toEntity).toList(),
        );
  }
}
