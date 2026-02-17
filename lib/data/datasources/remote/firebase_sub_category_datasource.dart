import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_app/data/models/sub_category_model.dart';

/// Источник данных Firestore для подкатегорий.
/// Подколлекция: users/{userId}/subcategories/{subCategoryId}
class FirebaseSubCategoryDatasource {
  FirebaseSubCategoryDatasource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const String _usersCollection = 'users';
  static const String _subCategoriesSubcollection = 'subcategories';

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _subCategories =>
      _firestore
          .collection(_usersCollection)
          .doc(_userId)
          .collection(_subCategoriesSubcollection);

  Future<void> addSubCategory(SubCategoryModel model) async {
    await _subCategories.doc(model.subCategoryId).set(model.toFirestore());
  }

  Future<void> updateSubCategory(SubCategoryModel model) async {
    await _subCategories.doc(model.subCategoryId).update(model.toFirestore());
  }

  Future<void> deleteSubCategory(String subCategoryId) async {
    await _subCategories.doc(subCategoryId).delete();
  }

  Future<SubCategoryModel?> getSubCategory(String subCategoryId) async {
    final doc = await _subCategories.doc(subCategoryId).get();
    if (!doc.exists || doc.data() == null) return null;
    return SubCategoryModel.fromFirestore(doc);
  }

  Future<List<SubCategoryModel>> getSubCategories() async {
    final snapshot = await _subCategories.orderBy('createdAt').get();
    return snapshot.docs
        .map((doc) => SubCategoryModel.fromFirestore(doc))
        .toList();
  }

  Future<List<SubCategoryModel>> getSubCategoriesByCategory(
    String categoryId,
  ) async {
    final snapshot = await _subCategories
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt')
        .get();
    return snapshot.docs
        .map((doc) => SubCategoryModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<SubCategoryModel>> watchSubCategories() {
    return _subCategories
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubCategoryModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<SubCategoryModel>> watchSubCategoriesByCategory(
    String categoryId,
  ) {
    return _subCategories
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubCategoryModel.fromFirestore(doc))
            .toList());
  }
}
