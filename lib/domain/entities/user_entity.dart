import 'package:finance_app/domain/entities/entity.dart';

/// Сущность пользователя в Domain слое.
/// Содержит только бизнес-данные, без логики сериализации.
class UserEntity extends Entity {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });
}
