import 'package:finance_app/components/components.dart';
import 'package:finance_app/themes/themes.dart';
import 'package:flutter/material.dart';

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить транзакцию'),
        actions: [
          CustomTextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Сохранить',
          ),
          const SizedBox(width: AppSizing.defaultPadding),
        ],
      ),
      body: Column(children: [Text('Добавить транзакцию')]),
    );
  }
}
