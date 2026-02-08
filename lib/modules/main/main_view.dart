import 'package:finance_app/components/components.dart';
import 'package:finance_app/modules/modules.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingasView()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizing.defaultPadding),
        child: Column(
          children: [
            Text('Hello, World!'),
            PrimaryButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTransactionView()),
                );
              },
              text: 'Добавить транзакцию',
            ),
          ],
        ),
      ),
    );
  }
}
