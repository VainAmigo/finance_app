import 'package:finance_app/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const AuthInitial()) {
    _watchAuth();
  }

  final UserRepository _userRepository;

  void _watchAuth() {
    emit(const AuthLoading());
    _userRepository.watchCurrentUser().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());
    try {
      await _userRepository.signInWithGoogle();
    } catch (e) {
      emit(AuthError(_formatAuthError(e.toString())));
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    emit(const AuthLoading());
    try {
      await _userRepository.signInWithEmail(email, password);
    } catch (e) {
      emit(AuthError(_formatAuthError(e.toString())));
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    emit(const AuthLoading());
    try {
      await _userRepository.signUpWithEmail(
        email,
        password,
        displayName: displayName,
      );
    } catch (e) {
      emit(AuthError(_formatAuthError(e.toString())));
    }
  }

  static String _formatAuthError(String raw) {
    if (raw.contains('user-not-found') || raw.contains('ERROR_USER_NOT_FOUND')) {
      return 'Пользователь не найден. Проверьте email.';
    }
    if (raw.contains('wrong-password') || raw.contains('ERROR_WRONG_PASSWORD')) {
      return 'Неверный пароль.';
    }
    if (raw.contains('email-already-in-use') || raw.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
      return 'Этот email уже зарегистрирован.';
    }
    if (raw.contains('invalid-email') || raw.contains('ERROR_INVALID_EMAIL')) {
      return 'Неверный формат email.';
    }
    if (raw.contains('weak-password') || raw.contains('ERROR_WEAK_PASSWORD')) {
      return 'Пароль слишком слабый. Используйте минимум 6 символов.';
    }
    if (raw.contains('NetworkException')) {
      return 'Ошибка сети. Проверьте подключение.';
    }
    return raw;
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    await _userRepository.signOut();
  }
}
