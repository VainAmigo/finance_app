import 'package:finance_app/presentation/presentaion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Барьер аутентификации.
/// Показывает Login если не авторизован, перенаправляет на Main при успешной авторизации.
class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr is AuthAuthenticated,
      listener: (context, state) {
        if (state is AuthAuthenticated && context.mounted) {
          Navigator.of(context).pushReplacementNamed(AppRouter.main);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const LoginView();
        },
      ),
    );
  }
}
