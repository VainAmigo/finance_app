import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:finance_app/data/models/user_model.dart';

/// Источник данных Firebase Auth + Firestore для пользователей.
/// Работает только с DTO (UserModel), не знает о Domain entities.
class FirebaseUserDatasource {
  FirebaseUserDatasource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const String _usersCollection = 'users';

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(_usersCollection);

  /// Получить текущего пользователя из Auth.
  User? get currentFirebaseUser => _auth.currentUser;

  /// Получить данные пользователя из Firestore.
  Future<UserModel?> getUserById(String id) async {
    final doc = await _users.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Сохранить/обновить пользователя в Firestore.
  Future<void> setUser(UserModel model) async {
    await _users.doc(model.id).set(model.toFirestore());
  }

  /// Подписаться на изменения пользователя.
  Stream<UserModel?> watchUser(String id) {
    return _users.doc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Вход по email и паролю.
  Future<User> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user!;
  }

  /// Регистрация по email и паролю.
  Future<User> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user!;
    if (displayName != null && displayName.isNotEmpty) {
      await user.updateDisplayName(displayName);
      await user.reload();
      return _auth.currentUser!;
    }
    return user;
  }

  /// Вход через Google.
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    return result.user!;
  }

  /// Выход.
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  /// Подписаться на изменения Auth (текущий пользователь).
  Stream<User?> watchAuthState() {
    return _auth.authStateChanges();
  }
}
