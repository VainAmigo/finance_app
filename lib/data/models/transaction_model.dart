import 'package:cloud_firestore/cloud_firestore.dart';

/// DTO модель транзакции для Firestore.
class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String currencyCode;
  final String title;
  final String? categoryId;
  final DateTime date;
  final bool isIncome;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currencyCode,
    required this.title,
    this.categoryId,
    required this.date,
    required this.isIncome,
  });

  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] as String,
      amount: (data['amount'] as num).toDouble(),
      currencyCode: data['currencyCode'] as String,
      title: data['title'] as String,
      categoryId: data['categoryId'] as String?,
      date: (data['date'] as Timestamp).toDate(),
      isIncome: data['isIncome'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'currencyCode': currencyCode,
      'title': title,
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'isIncome': isIncome,
    };
  }
}
