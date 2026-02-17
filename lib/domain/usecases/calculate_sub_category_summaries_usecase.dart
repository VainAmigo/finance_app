import 'package:finance_app/domain/entities/sub_category_entity.dart';
import 'package:finance_app/domain/entities/sub_category_summary_entity.dart';
import 'package:finance_app/domain/entities/transaction_entity.dart';
import 'package:finance_app/domain/repositories/sub_category_repository.dart';
import 'package:finance_app/domain/repositories/transaction_repository.dart';

/// Use case: расчёт сумм по подкатегориям.
///
/// Сумма подкатегории = сумма транзакций, где subCategoryId совпадает.
/// Используется для детализированного отчёта по подкатегориям.
class CalculateSubCategorySummariesUseCase {
  CalculateSubCategorySummariesUseCase({
    required SubCategoryRepository subCategoryRepository,
    required TransactionRepository transactionRepository,
  })  : _subCategoryRepository = subCategoryRepository,
        _transactionRepository = transactionRepository;

  final SubCategoryRepository _subCategoryRepository;
  final TransactionRepository _transactionRepository;

  /// Получить сводки по подкатегориям указанной категории.
  Future<List<SubCategorySummaryEntity>> call(
    String categoryId, [
    TransactionFilter? filter,
  ]) async {
    final subCategories =
        await _subCategoryRepository.getSubCategoriesByCategory(categoryId);
    final transactions =
        await _transactionRepository.getAllTransactionsForSummary(filter);

    return _calculateSummaries(
      subCategories: subCategories,
      transactions: transactions,
    );
  }

  /// Получить сводки по всем подкатегориям.
  Future<List<SubCategorySummaryEntity>> callAll([
    TransactionFilter? filter,
  ]) async {
    final subCategories = await _subCategoryRepository.getSubCategories();
    final transactions =
        await _transactionRepository.getAllTransactionsForSummary(filter);

    return _calculateSummaries(
      subCategories: subCategories,
      transactions: transactions,
    );
  }

  List<SubCategorySummaryEntity> _calculateSummaries({
    required List<SubCategoryEntity> subCategories,
    required List<TransactionEntity> transactions,
  }) {
    final totals = <String, double>{};
    for (final sc in subCategories) {
      totals[sc.subCategoryId] = 0;
    }

    for (final tx in transactions) {
      if (tx.subCategoryId != null &&
          tx.subCategoryId!.isNotEmpty &&
          totals.containsKey(tx.subCategoryId)) {
        totals[tx.subCategoryId!] = (totals[tx.subCategoryId!] ?? 0) + tx.amount;
      }
    }

    return subCategories
        .map(
          (sc) => SubCategorySummaryEntity(
            subCategory: sc,
            totalAmount: totals[sc.subCategoryId] ?? 0,
          ),
        )
        .toList();
  }
}
