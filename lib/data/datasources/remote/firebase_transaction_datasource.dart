import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_app/data/models/transaction_model.dart';
import 'package:finance_app/domain/entities/transaction_entity.dart';

/// Источник данных Firestore для транзакций.
/// Подколлекция: users/{userId}/transactions/{transactionId}
class FirebaseTransactionDatasource {
  FirebaseTransactionDatasource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const String _usersCollection = 'users';
  static const String _transactionsSubcollection = 'transactions';

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _transactions =>
      _firestore
          .collection(_usersCollection)
          .doc(_userId)
          .collection(_transactionsSubcollection);

  Future<void> addTransaction(TransactionModel model) async {
    await _transactions.doc(model.transactionId).set(model.toFirestore());
  }

  Future<void> updateTransaction(TransactionModel model) async {
    await _transactions.doc(model.transactionId).update(model.toFirestore());
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactions.doc(transactionId).delete();
  }

  Future<TransactionModel?> getTransaction(String transactionId) async {
    final doc = await _transactions.doc(transactionId).get();
    if (!doc.exists || doc.data() == null) return null;
    return TransactionModel.fromFirestore(doc);
  }

  Future<List<TransactionModel>> getTransactions({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    TransactionType? type,
  }) async {
    Query<Map<String, dynamic>> query = _transactions;

    if (from != null) {
      query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    }
    if (to != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));
    }
    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    final snapshot = await query.orderBy('date', descending: true).get();
    return snapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();
  }

  /// Получить все транзакции (для расчёта сумм по категориям).
  Future<List<TransactionModel>> getAllTransactions({
    DateTime? from,
    DateTime? to,
    TransactionType? type,
  }) async {
    Query<Map<String, dynamic>> query = _transactions;

    if (from != null) {
      query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    }
    if (to != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));
    }
    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    final snapshot = await query.orderBy('date', descending: true).get();
    return snapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<TransactionModel>> watchTransactions({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    TransactionType? type,
  }) {
    Query<Map<String, dynamic>> query = _transactions;

    if (from != null) {
      query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    }
    if (to != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));
    }
    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    return query
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }
}
