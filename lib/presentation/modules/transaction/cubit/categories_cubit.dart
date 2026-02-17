import 'package:finance_app/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required CategoryRepository categoryRepository,
    required SubCategoryRepository subCategoryRepository,
  })  : _categoryRepository = categoryRepository,
        _subCategoryRepository = subCategoryRepository,
        super(const CategoriesInitial()) {
    load();
  }

  final CategoryRepository _categoryRepository;
  final SubCategoryRepository _subCategoryRepository;

  Future<void> load() async {
    emit(const CategoriesLoading());

    try {
      final categories = await _categoryRepository.getCategories();
      final subCategories = await _subCategoryRepository.getSubCategories();

      final subMap = <String, List<SubCategoryEntity>>{};
      for (final s in subCategories) {
        subMap.putIfAbsent(s.categoryId, () => []).add(s);
      }

      final items = categories
          .map((c) => CategoryWithSubCategories(
                c,
                subMap[c.categoryId] ?? [],
              ))
          .toList();

      emit(CategoriesLoaded(items));
    } catch (e, st) {
      debugPrint('CategoriesCubit.load error: $e\n$st');
      emit(CategoriesError(e.toString()));
    }
  }
}
