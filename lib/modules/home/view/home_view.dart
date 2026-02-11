import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizing.defaultPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  'Главная',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
