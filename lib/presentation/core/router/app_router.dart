import 'package:finance_app/presentation/presentaion.dart';
import 'package:flutter/material.dart';

@immutable
final class AppRouter {
  const AppRouter._();

  static const main = '/';
  static const auth = '/auth';
  static const register = '/register';
  static const login = '/login';
  static const addTransaction = '/add-transaction';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      main => MaterialPageRoute(
        settings: const RouteSettings(name: main),
        builder: (_) => const MainView(),
      ),
      auth => MaterialPageRoute(
        settings: const RouteSettings(name: auth),
        builder: (_) => const AuthView(),
      ),
      register => MaterialPageRoute(
        settings: const RouteSettings(name: register),
        builder: (_) => const RegisterView(),
      ),
      login => MaterialPageRoute(
        settings: const RouteSettings(name: login),
        builder: (_) => const LoginView(),
      ),
      addTransaction => MaterialPageRoute(
        settings: const RouteSettings(name: addTransaction),
        builder: (_) => const AddTransactionView(),
      ),
      _ => throw Exception(
        'No builder specified for route named: [${settings.name}]',
      ),
    };
  }
}
