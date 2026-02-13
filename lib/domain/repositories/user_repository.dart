import 'package:finance_app/domain/entities/user_entity.dart';

/// Интерфейс репозитория пользователей.
/// Domain слой определяет КОНТРАКТ — что нужно уметь делать с данными.
/// Реализация — в Data слое.
abstract class UserRepository {
  /// Получить текущего пользователя.
  Future<UserEntity?> getCurrentUser();

  /// Выйти из аккаунта.
  Future<void> signOut();

  /// Получить пользователя по ID.
  Future<UserEntity?> getUserById(String id);

  /// Подписаться на изменения текущего пользователя.
  Stream<UserEntity?> watchCurrentUser();

  /// Вход через Google.
  Future<UserEntity> signInWithGoogle();

  /// Вход по email и паролю.
  Future<UserEntity> signInWithEmail(String email, String password);

  /// Регистрация по email и паролю.
  Future<UserEntity> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  });
}
