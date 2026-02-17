import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_app/data/models/category_model.dart';

/// Источник данных Firestore для категорий.
/// Подколлекция: users/{userId}/categories/{categoryId}
class FirebaseCategoryDatasource {
  FirebaseCategoryDatasource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const String _usersCollection = 'users';
  static const String _categoriesSubcollection = 'categories';

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _categories =>
      _firestore
          .collection(_usersCollection)
          .doc(_userId)
          .collection(_categoriesSubcollection);

  Future<void> addCategory(CategoryModel model) async {
    await _categories.doc(model.categoryId).set(model.toFirestore());
  }

  Future<void> updateCategory(CategoryModel model) async {
    await _categories.doc(model.categoryId).update(model.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categories.doc(categoryId).delete();
  }

  Future<CategoryModel?> getCategory(String categoryId) async {
    final doc = await _categories.doc(categoryId).get();
    if (!doc.exists || doc.data() == null) return null;
    return CategoryModel.fromFirestore(doc);
  }

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _categories.orderBy('createdAt').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<CategoryModel>> watchCategories() {
    return _categories
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList());
  }
}
