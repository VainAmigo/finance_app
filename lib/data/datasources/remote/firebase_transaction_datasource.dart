import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/data/models/transaction_model.dart';

/// Источник данных транзакций из Firestore.
class FirebaseTransactionDatasource {
  FirebaseTransactionDatasource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _transactionsCollection = 'transactions';

  CollectionReference<Map<String, dynamic>> get _transactions =>
      _firestore.collection(_transactionsCollection);

  Future<List<TransactionModel>> getByUserId(String userId) async {
    final snapshot = await _transactions
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();
  }

  Future<TransactionModel?> getById(String id) async {
    final doc = await _transactions.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return TransactionModel.fromFirestore(doc);
  }

  Future<void> create(TransactionModel model) async {
    final docRef = _transactions.doc();
    await docRef.set({
      ...model.toFirestore(),
    });
  }

  Future<void> update(TransactionModel model) async {
    await _transactions.doc(model.id).update(model.toFirestore());
  }

  Future<void> delete(String id) async {
    await _transactions.doc(id).delete();
  }

  Stream<List<TransactionModel>> watchByUserId(String userId) {
    return _transactions
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((d) => TransactionModel.fromFirestore(d)).toList());
  }
}
