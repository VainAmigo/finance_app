import 'package:finance_app/domain/entities/transaction_entity.dart';

/// Параметры фильтрации транзакций.
class TransactionFilter {
  final DateTime? from;
  final DateTime? to;
  final String? categoryId;
  final TransactionType? type;

  const TransactionFilter({
    this.from,
    this.to,
    this.categoryId,
    this.type,
  });
}

/// Интерфейс репозитория транзакций.
abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String transactionId);
  Future<TransactionEntity?> getTransaction(String transactionId);
  Future<List<TransactionEntity>> getTransactions([
    TransactionFilter? filter,
  ]);
  Future<List<TransactionEntity>> getAllTransactionsForSummary([
    TransactionFilter? filter,
  ]);
  Stream<List<TransactionEntity>> watchTransactions([
    TransactionFilter? filter,
  ]);
}
