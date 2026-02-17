import 'package:finance_app/domain/entities/category_entity.dart';
import 'package:finance_app/domain/entities/category_summary_entity.dart';
import 'package:finance_app/domain/entities/sub_category_entity.dart';
import 'package:finance_app/domain/entities/transaction_entity.dart';
import 'package:finance_app/domain/repositories/category_repository.dart';
import 'package:finance_app/domain/repositories/sub_category_repository.dart';
import 'package:finance_app/domain/repositories/transaction_repository.dart';

/// Use case: расчёт сумм по категориям.
///
/// Логика:
/// - Сумма категории = сумма транзакций, где:
///   - categoryId совпадает И (hasSubCategories == false ИЛИ subCategoryId == null)
///   - ИЛИ subCategoryId принадлежит подкатегории этой категории (hasSubCategories == true)
/// - Учитываются только expense-транзакции для расходов
class CalculateCategorySummariesUseCase {
  CalculateCategorySummariesUseCase({
    required CategoryRepository categoryRepository,
    required SubCategoryRepository subCategoryRepository,
    required TransactionRepository transactionRepository,
  })  : _categoryRepository = categoryRepository,
        _subCategoryRepository = subCategoryRepository,
        _transactionRepository = transactionRepository;

  final CategoryRepository _categoryRepository;
  final SubCategoryRepository _subCategoryRepository;
  final TransactionRepository _transactionRepository;

  /// Получить сводки по всем категориям.
  /// [filter] — фильтр по дате и типу транзакций.
  Future<List<CategorySummaryEntity>> call([
    TransactionFilter? filter,
  ]) async {
    final categories = await _categoryRepository.getCategories();
    final subCategories = await _subCategoryRepository.getSubCategories();
    final transactions =
        await _transactionRepository.getAllTransactionsForSummary(filter);

    return _calculateSummaries(
      categories: categories,
      subCategories: subCategories,
      transactions: transactions,
    );
  }

  List<CategorySummaryEntity> _calculateSummaries({
    required List<CategoryEntity> categories,
    required List<SubCategoryEntity> subCategories,
    required List<TransactionEntity> transactions,
  }) {
    final subCategoryToCategory = <String, String>{};
    for (final sc in subCategories) {
      subCategoryToCategory[sc.subCategoryId] = sc.categoryId;
    }

    final categoryTotals = <String, double>{};
    for (final cat in categories) {
      categoryTotals[cat.categoryId] = 0;
    }

    for (final tx in transactions) {
      final categoryId = _resolveCategoryId(
        transaction: tx,
        subCategoryToCategory: subCategoryToCategory,
      );
      if (categoryId != null && categoryTotals.containsKey(categoryId)) {
        categoryTotals[categoryId] =
            (categoryTotals[categoryId] ?? 0) + tx.amount;
      }
    }

    return categories
        .map(
          (c) => CategorySummaryEntity(
            category: c,
            totalAmount: categoryTotals[c.categoryId] ?? 0,
          ),
        )
        .toList();
  }

  /// Определяет categoryId для транзакции.
  /// - Если subCategoryId задан — ищем родительскую категорию.
  /// - Иначе — используем categoryId транзакции.
  String? _resolveCategoryId({
    required TransactionEntity transaction,
    required Map<String, String> subCategoryToCategory,
  }) {
    if (transaction.subCategoryId != null &&
        transaction.subCategoryId!.isNotEmpty) {
      return subCategoryToCategory[transaction.subCategoryId];
    }
    return transaction.categoryId;
  }
}
