import 'package:finance_app/presentation/presentaion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_destinations.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  static const _tabs = [
    HomeView(),
    Center(child: Text('Transactions')),
    AnalyticView(),
    SettingasView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthUnauthenticated && context.mounted) {
          Navigator.of(context).pushReplacementNamed(AppRouter.auth);
        }
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _tabs),
        bottomNavigationBar: AppBottomNav(
          destinations: mainBottomNavDestinations,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
