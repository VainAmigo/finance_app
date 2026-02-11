import 'package:finance_app/components/components.dart';
import 'package:finance_app/modules/modules.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: AppBottomNav(
        destinations: mainBottomNavDestinations,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
