import 'package:finance_app/domain/entities/transaction_entity.dart';

/// Интерфейс репозитория транзакций.
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactionsByUserId(String userId);
  Future<TransactionEntity?> getTransactionById(String id);
  Future<void> createTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
  Stream<List<TransactionEntity>> watchTransactionsByUserId(String userId);
}
