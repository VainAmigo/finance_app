import 'package:finance_app/domain/entities/entity.dart';

/// Типы транзакций.
enum TransactionType {
  expense,
  income,
}

class TransactionEntity extends Entity {
  final String transactionId;
  final double amount;
  final String categoryId;
  final DateTime createdAt;
  final String currency;
  final DateTime date;
  final String? subCategoryId;
  final TransactionType type;

  const TransactionEntity({
    required this.transactionId,
    required this.amount,
    required this.categoryId,
    required this.createdAt,
    required this.currency,
    required this.date,
    this.subCategoryId,
    required this.type,
  });
}
