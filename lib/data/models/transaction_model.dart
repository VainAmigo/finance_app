import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/domain/entities/transaction_entity.dart';

/// DTO модель транзакции для Firebase Firestore.
class TransactionModel {
  final String transactionId;
  final double amount;
  final String categoryId;
  final DateTime createdAt;
  final String currency;
  final DateTime date;
  final String? subCategoryId;
  final TransactionType type;

  const TransactionModel({
    required this.transactionId,
    required this.amount,
    required this.categoryId,
    required this.createdAt,
    required this.currency,
    required this.date,
    this.subCategoryId,
    required this.type,
  });

  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return TransactionModel(
      transactionId: doc.id,
      amount: (data['amount'] as num).toDouble(),
      categoryId: data['categoryId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      currency: data['currency'] as String,
      date: (data['date'] as Timestamp).toDate(),
      subCategoryId: data['subCategoryId'] as String?,
      type: _parseTransactionType(data['type'] as String?),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'categoryId': categoryId,
      'createdAt': Timestamp.fromDate(createdAt),
      'currency': currency,
      'date': Timestamp.fromDate(date),
      'subCategoryId': subCategoryId,
      'type': type.name,
    };
  }

  static TransactionType _parseTransactionType(String? value) {
    switch (value?.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'expense':
      case 'expence':
        return TransactionType.expense;
      default:
        return TransactionType.expense;
    }
  }
}
