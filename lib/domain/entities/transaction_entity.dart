import 'package:finance_app/domain/entities/entity.dart';

/// Сущность транзакции.
class TransactionEntity extends Entity {
  final String id;
  final String userId;
  final double amount;
  final String currencyCode;
  final String title;
  final String? categoryId;
  final DateTime date;
  final bool isIncome;

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currencyCode,
    required this.title,
    this.categoryId,
    required this.date,
    required this.isIncome,
  });
}
