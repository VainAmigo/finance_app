import 'package:finance_app/data/datasources/remote/firebase_user_datasource.dart';
import 'package:finance_app/data/mappers/user_mapper.dart';
import 'package:finance_app/data/models/user_model.dart';
import 'package:finance_app/domain/entities/user_entity.dart';
import 'package:finance_app/domain/repositories/user_repository.dart';

/// Реализация UserRepository.
/// Связывает Domain (интерфейс) и Data (Firebase).
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    FirebaseUserDatasource? datasource,
    UserMapper? mapper,
  })  : _datasource = datasource ?? FirebaseUserDatasource(),
        _mapper = mapper ?? const UserMapper();

  final FirebaseUserDatasource _datasource;
  final UserMapper _mapper;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final fbUser = _datasource.currentFirebaseUser;
    if (fbUser == null) return null;

    final model = await _datasource.getUserById(fbUser.uid);
    if (model != null) return _mapper.toEntity(model);

    return _mapper.toEntity(UserModel(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    final model = await _datasource.getUserById(id);
    return model != null ? _mapper.toEntity(model) : null;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final fbUser = await _datasource.signInWithGoogle();

    final userModel = UserModel(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
      createdAt: DateTime.now(),
    );
    await _datasource.setUser(userModel);

    return _mapper.toEntity(userModel);
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final fbUser = await _datasource.signInWithEmail(email, password);

    final userModel = UserModel(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
      createdAt: DateTime.now(),
    );
    await _datasource.setUser(userModel);

    return _mapper.toEntity(userModel);
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    final fbUser = await _datasource.signUpWithEmail(
      email,
      password,
      displayName: displayName,
    );

    final userModel = UserModel(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName ?? displayName,
      photoUrl: fbUser.photoURL,
      createdAt: DateTime.now(),
    );
    await _datasource.setUser(userModel);

    return _mapper.toEntity(userModel);
  }

  @override
  Stream<UserEntity?> watchCurrentUser() {
    return _datasource.watchAuthState().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      final model = await _datasource.getUserById(fbUser.uid);
      if (model != null) return _mapper.toEntity(model);
      return _mapper.toEntity(UserModel(
        id: fbUser.uid,
        email: fbUser.email ?? '',
        displayName: fbUser.displayName,
        photoUrl: fbUser.photoURL,
        createdAt: DateTime.now(),
      ));
    });
  }
}
